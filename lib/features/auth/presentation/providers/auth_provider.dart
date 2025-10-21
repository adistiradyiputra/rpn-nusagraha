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
      
      final user = await _loginUseCase.execute(request);
      _user = user;
      _status = AuthStatus.authenticated;
      
      // Save user data to SharedPreferences
      await _saveUserData(user);
      
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
    if (ApiService.token != null) {
      _status = AuthStatus.authenticated;
      // Load user data from storage or API
      await _loadUserData();
      notifyListeners();
    } else {
      _status = AuthStatus.unauthenticated;
      _user = null; // Clear user data when no token
      notifyListeners();
    }
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
      await prefs.setString('user_data', json.encode(userJson));
    } catch (e) {
      print('Error saving user data: $e');
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
      
      // Clear user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
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

