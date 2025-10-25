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

  Future<bool?> getStatus() async {
    final data = await getAuthData();
    return data?.hasBusinessProfile;
  }

  Future<void> updateBusinessProfileStatus(bool hasProfile) async {
    final data = await getAuthData();
    if (data != null) {
      final updatedData = AuthResponseModel(
        user: data.user,
        token: data.token,
        hasBusinessProfile: hasProfile,
      );
      await saveAuthData(updatedData);
    }
  }

  Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('auth_data');
    return data != null;
  }
}
