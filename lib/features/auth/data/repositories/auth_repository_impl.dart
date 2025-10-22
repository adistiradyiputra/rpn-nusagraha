import '../../domain/entities/user.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(LoginRequest request) async {
    try {
      final response = await ApiService.post(
        ApiConstants.loginEndpoint,
        {
          'username': request.username,
          'password': request.password,
        },
      );
      
      if (response['status'] == 200) {
        final data = response['data'];
        final type = response['type'];
        
        // Validasi token ada
        if (data['token'] == null || data['token'].toString().isEmpty) {
          throw Exception('Token tidak diterima dari server');
        }
        
        // Store token for future API calls - dengan error handling
        try {
          await ApiService.setToken(data['token']);
        } catch (e) {
          print('Error menyimpan token: $e');
          throw Exception('Gagal menyimpan token: $e');
        }
        
        // Parse last_fung
        LastFung? lastFung;
        if (data['last_fung'] != null) {
          lastFung = LastFung.fromJson(data['last_fung']);
        }
        
        // Parse last_gol
        LastGol? lastGol;
        if (data['last_gol'] != null) {
          lastGol = LastGol.fromJson(data['last_gol']);
        }
        
        // Determine jabFung: use last_fung.fung_jab if available, otherwise use jab_fung
        String? jabFung = lastFung?.fungJab ?? (data['jab_fung']?.toString().isNotEmpty == true ? data['jab_fung'] : null);
        
        // Parse jml_gSchoolar safely (might be string or int)
        int? jmlGSchoolar;
        if (data['jml_gSchoolar'] != null) {
          if (data['jml_gSchoolar'] is int) {
            jmlGSchoolar = data['jml_gSchoolar'];
          } else if (data['jml_gSchoolar'] is String) {
            jmlGSchoolar = int.tryParse(data['jml_gSchoolar']);
          }
        }
        
        // Parse jml_hki safely
        int? jmlHki;
        if (data['jml_hki'] != null) {
          if (data['jml_hki'] is int) {
            jmlHki = data['jml_hki'];
          } else if (data['jml_hki'] is String) {
            jmlHki = int.tryParse(data['jml_hki']);
          }
        }
        
        // Parse jml_publikasi safely
        int? jmlPublikasi;
        if (data['jml_publikasi'] != null) {
          if (data['jml_publikasi'] is int) {
            jmlPublikasi = data['jml_publikasi'];
          } else if (data['jml_publikasi'] is String) {
            jmlPublikasi = int.tryParse(data['jml_publikasi']);
          }
        }
        
        return User(
          id: data['id'] ?? data['nik'] ?? data['id_kar'] ?? '', // Use nik or id_kar as fallback
          username: data['username'] ?? data['nik'] ?? '', // Use nik as fallback for username
          email: data['email'] ?? '',
          fullName: data['fullname'] ?? data['nama'] ?? '',
          nik: data['nik'],
          jabFung: jabFung?.isNotEmpty == true ? jabFung : null, // Only set if not empty
          jabStruk: data['jab_struk'],
          puslit: data['puslit'],
          foto: data['foto'],
          idKar: data['id_kar'],
          noHp: data['no_hp'],
          kepakaran: data['kepakaran'], // Can be null if not present
          type: type,
          lastFung: lastFung, // Can be null if not present
          lastGol: lastGol,
          jmlHki: jmlHki, // Can be null if not present
          jmlGSchoolar: jmlGSchoolar, // Can be null if not present
          jmlPublikasi: jmlPublikasi, // Can be null if not present
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        throw Exception('Login Gagal');
      }
    } catch (e) {
      print('Login error detail: $e');
      throw Exception('Login Gagal');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await ApiService.get(ApiConstants.logoutEndpoint);
    } catch (e) {
      // Log error but don't throw - logout should always succeed locally
      print('Logout API error: $e');
    } finally {
      // Always clear token locally
      await ApiService.clearToken();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    // Check if token exists
    if (ApiService.token == null) {
      return null;
    }
    
    // In a real app, you might validate the token with the server
    // For now, return null to force re-login
    return null;
  }

  @override
  Future<bool> isLoggedIn() async {
    return ApiService.token != null;
  }

  @override
  Future<void> saveUserSession(User user) async {
    // Token is already stored in ApiService
    // You can add local storage here if needed
  }

  @override
  Future<void> clearUserSession() async {
    await ApiService.clearToken();
  }
}
