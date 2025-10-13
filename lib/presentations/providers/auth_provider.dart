import 'package:flutter/material.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/models/response/auth_response_model.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRemoteDatasource _authRemoteDatasource;
  final AuthLocalDatasource _authLocalDatasource;

  // State variables
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  AuthResponseModel? _authData;

  AuthProvider({
    required AuthRemoteDatasource authRemoteDatasource,
    required AuthLocalDatasource authLocalDatasource,
  }) : _authRemoteDatasource = authRemoteDatasource,
       _authLocalDatasource = authLocalDatasource {
    _checkAuthStatus();
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  AuthResponseModel? get authData => _authData;
  User? get user => _authData?.user;
  String? get token => _authData?.token;

  // Check authentication status
  Future<void> _checkAuthStatus() async {
    _setLoading(true);

    final authData = await _authLocalDatasource.getAuthData();
    if (authData != null) {
      _authData = authData;
      _isAuthenticated = true;
    }

    _setLoading(false);
  }

  // Login method
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRemoteDatasource.login(email, password);

      return result.fold(
        (error) {
          _setError(error);
          return false;
        },
        (authResponse) async {
          await _authLocalDatasource.saveAuthData(authResponse);
          _authData = authResponse;
          _isAuthenticated = true;
          _clearError();
          return true;
        },
      );
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout method
  Future<bool> logout() async {
    _setLoading(true);
    _clearError();

    try {
      // Call logout API (ignore result for simplicity)
      await _authRemoteDatasource.logout();

      // Remove local auth data
      await _authLocalDatasource.removeAuthData();
      _authData = null;
      _isAuthenticated = false;

      // Notify listeners about state change
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
      // Still remove local auth data even if API fails
      await _authLocalDatasource.removeAuthData();
      _authData = null;
      _isAuthenticated = false;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Public method to clear error
  void clearError() => _clearError();

  // Refresh authentication status
  Future<void> refreshAuthStatus() => _checkAuthStatus();
}
