import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/services/api_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  
  AuthProvider(this._loginUseCase);

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Methods
  Future<bool> login(LoginRequest request) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Execute login - ini akan menyimpan token
      final user = await _loginUseCase.execute(request);
      
      // Verifikasi token tersimpan
      if (ApiService.token == null || ApiService.token!.isEmpty) {
        throw Exception('Token tidak berhasil disimpan. Silakan coba lagi.');
      }
      
      _user = user;
      _status = AuthStatus.authenticated;
      
      // Save user data to SharedPreferences
      try {
        await _saveUserData(user);
      } catch (e) {
        print('Warning: Gagal menyimpan data user: $e');
        // User data bisa dimuat ulang dari API, jadi tidak perlu error
      }
      
      return true;
    } catch (e) {
      // Extract clean error message
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      _setError(errorMessage);
      _status = AuthStatus.error;
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      // Pastikan token sudah dimuat dari storage
      await ApiService.loadToken();
      
      if (ApiService.token != null && ApiService.token!.isNotEmpty) {
        _status = AuthStatus.authenticated;
        // Load user data from storage or API
        await _loadUserData();
        
        // Jika tidak ada user data, set unauthenticated
        if (_user == null) {
          print('Token ada tapi user data tidak ada, perlu login ulang');
          _status = AuthStatus.unauthenticated;
          await ApiService.clearToken();
        }
      } else {
        _status = AuthStatus.unauthenticated;
        _user = null; // Clear user data when no token
      }
    } catch (e) {
      print('Error checking auth status: $e');
      _status = AuthStatus.unauthenticated;
      _user = null;
    }
    notifyListeners();
  }

  Future<void> _saveUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = {
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'fullName': user.fullName,
        'nik': user.nik,
        'jabFung': user.jabFung,
        'jabStruk': user.jabStruk,
        'puslit': user.puslit,
        'foto': user.foto,
        'idKar': user.idKar,
        'noHp': user.noHp,
        'kepakaran': user.kepakaran,
        'type': user.type,
        'lastFung': user.lastFung?.toJson(),
        'lastGol': user.lastGol?.toJson(),
        'jmlHki': user.jmlHki,
        'jmlGSchoolar': user.jmlGSchoolar,
        'jmlPublikasi': user.jmlPublikasi,
        'createdAt': user.createdAt.toIso8601String(),
        'updatedAt': user.updatedAt.toIso8601String(),
      };
      
      final jsonString = json.encode(userJson);
      final success = await prefs.setString('user_data', jsonString);
      
      if (success) {
        // Verifikasi data tersimpan
        final savedData = prefs.getString('user_data');
        if (savedData == jsonString) {
          print('User data berhasil disimpan dan diverifikasi');
        } else {
          print('Warning: User data tersimpan tapi tidak sama');
        }
      } else {
        print('Warning: SharedPreferences.setString() returned false untuk user data');
      }
    } catch (e) {
      print('Error saving user data: $e');
      // Tidak throw error, karena user data bisa dimuat ulang
    }
  }

  Future<void> _loadUserData() async {
    try {
      // Load user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        final Map<String, dynamic> userJson = json.decode(userData);
        
        // Parse last_fung
        LastFung? lastFung;
        if (userJson['lastFung'] != null) {
          lastFung = LastFung.fromJson(userJson['lastFung']);
        }
        
        // Parse last_gol
        LastGol? lastGol;
        if (userJson['lastGol'] != null) {
          lastGol = LastGol.fromJson(userJson['lastGol']);
        }
        
        _user = User(
          id: userJson['id'] ?? '',
          username: userJson['username'] ?? '',
          email: userJson['email'] ?? '',
          fullName: userJson['fullName'] ?? '',
          nik: userJson['nik'],
          jabFung: userJson['jabFung'],
          jabStruk: userJson['jabStruk'],
          puslit: userJson['puslit'],
          foto: userJson['foto'],
          idKar: userJson['idKar'],
          noHp: userJson['noHp'],
          kepakaran: userJson['kepakaran'],
          type: userJson['type'],
          lastFung: lastFung,
          lastGol: lastGol,
          jmlHki: userJson['jmlHki'],
          jmlGSchoolar: userJson['jmlGSchoolar'],
          jmlPublikasi: userJson['jmlPublikasi'],
          createdAt: DateTime.parse(userJson['createdAt']),
          updatedAt: DateTime.parse(userJson['updatedAt']),
        );
      } else {
        _user = null;
      }
    } catch (e) {
      print('Error loading user data: $e');
      _user = null;
    }
  }

  Future<void> logout() async {
    try {
      // Call repository logout to clear token from storage
      await _loginUseCase.repository.logout();
      
      // Clear user data from SharedPreferences dengan verifikasi
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      
      // Verifikasi bahwa data benar-benar terhapus
      final userData = prefs.getString('user_data');
      if (userData != null) {
        print('WARNING: User data masih ada setelah logout, mencoba lagi...');
        await prefs.remove('user_data');
      }
      
      // Verifikasi token juga terhapus
      if (ApiService.token != null) {
        print('WARNING: Token masih ada setelah logout');
        await ApiService.clearToken();
      }
      
      print('Logout berhasil, semua data dibersihkan');
    } catch (e) {
      // Log error but continue with local logout
      print('Logout error: $e');
    } finally {
      // Always clear local state
      _user = null;
      _status = AuthStatus.unauthenticated;
      _clearError();
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String message) {
    _errorMessage = message;
  }

  void _clearError() {
    _errorMessage = null;
  }

  void reset() {
    _status = AuthStatus.initial;
    _user = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}

