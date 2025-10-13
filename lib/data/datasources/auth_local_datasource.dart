import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response/auth_response_model.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', jsonEncode(authResponseModel.toJson()));
  }

  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }

  Future<AuthResponseModel?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('auth_data');
    if (data != null) {
      return AuthResponseModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<String?> getToken() async {
    final data = await getAuthData();
    return data?.token;
  }

  Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('auth_data');
    return data != null;
  }
}
