import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiService {
  static String? _token;
  static const String _tokenKey = 'auth_token';
  
  static String? get token => _token;
  
  /// Menyimpan token dengan verifikasi dan retry mechanism
  static Future<void> setToken(String token) async {
    if (token.isEmpty) {
      throw Exception('Token tidak boleh kosong');
    }
    
    // Set token di memory terlebih dahulu
    _token = token;
    
    // Simpan ke SharedPreferences dengan retry mechanism
    bool saved = false;
    int retryCount = 0;
    const maxRetries = 3;
    
    while (!saved && retryCount < maxRetries) {
      try {
        final prefs = await SharedPreferences.getInstance();
        
        // Simpan token
        final success = await prefs.setString(_tokenKey, token);
        
        if (success) {
          // Verifikasi bahwa token benar-benar tersimpan
          final savedToken = prefs.getString(_tokenKey);
          if (savedToken == token) {
            saved = true;
            print('Token berhasil disimpan (attempt ${retryCount + 1})');
          } else {
            print('Verifikasi gagal: token tersimpan tidak sesuai');
            retryCount++;
            if (retryCount < maxRetries) {
              await Future.delayed(Duration(milliseconds: 100 * retryCount));
            }
          }
        } else {
          print('SharedPreferences.setString() returned false');
          retryCount++;
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(milliseconds: 100 * retryCount));
          }
        }
      } catch (e) {
        print('Error saat menyimpan token (attempt ${retryCount + 1}): $e');
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(milliseconds: 100 * retryCount));
        }
      }
    }
    
    if (!saved) {
      // Token tetap di memory, tapi gagal disimpan ke persistent storage
      print('WARNING: Token hanya tersimpan di memory, tidak di persistent storage');
      throw Exception('Gagal menyimpan token setelah $maxRetries percobaan');
    }
  }
  
  /// Menghapus token dengan verifikasi
  static Future<void> clearToken() async {
    // Hapus dari memory
    _token = null;
    
    // Hapus dari SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      
      // Verifikasi token benar-benar terhapus
      final checkToken = prefs.getString(_tokenKey);
      if (checkToken != null) {
        print('WARNING: Token masih ada setelah dihapus, mencoba lagi...');
        await prefs.remove(_tokenKey);
      } else {
        print('Token berhasil dihapus');
      }
    } catch (e) {
      print('Error saat menghapus token: $e');
      // Tetap clear dari memory meskipun gagal dari storage
    }
  }
  
  /// Memuat token dari SharedPreferences
  static Future<void> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_tokenKey);
      
      if (_token != null && _token!.isNotEmpty) {
        print('Token berhasil dimuat dari storage');
      } else {
        print('Tidak ada token tersimpan');
      }
    } catch (e) {
      print('Error saat memuat token: $e');
      _token = null;
    }
  }
  
  static Map<String, String> get _headers {
    final headers = Map<String, String>.from(ApiConstants.defaultHeaders);
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }
  
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await http.get(
        url,
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await http.put(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
