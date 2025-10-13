import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/models/response/auth_response_model.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRemoteDatasource _authRemoteDatasource;
  final AuthLocalDatasource _authLocalDatasource;

  AuthProvider({
    required AuthRemoteDatasource authRemoteDatasource,
    required AuthLocalDatasource authLocalDatasource,
  }) : _authRemoteDatasource = authRemoteDatasource,
       _authLocalDatasource = authLocalDatasource {
    _checkAuthStatus();
  }

  // State variables
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  AuthResponseModel? _authData;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  AuthResponseModel? get authData => _authData;
  User? get user => _authData?.user;
  String? get token => _authData?.token;

  // Check authentication status on initialization
  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final isAuth = await _authLocalDatasource.isAuth();
    if (isAuth) {
      final authData = await _authLocalDatasource.getAuthData();
      if (authData != null) {
        _authData = authData;
        _isAuthenticated = true;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Either<String, AuthResponseModel> result =
          await _authRemoteDatasource.login(email, password);

      result.fold(
        (error) {
          _errorMessage = error;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (authResponse) async {
          // Save auth data locally
          await _authLocalDatasource.saveAuthData(authResponse);

          _authData = authResponse;
          _isAuthenticated = true;
          _errorMessage = null;
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
      return result.isRight();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authLocalDatasource.removeAuthData();

    _authData = null;
    _isAuthenticated = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Refresh authentication status
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }
}
