import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'auth_local_datasource.dart';

import '../../cores/constants/variables.dart';

import '../models/response/auth_response_model.dart';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/auth/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 201) {
      debugPrint(response.body);
      return right(AuthResponseModel.fromJson(response.body));
    } else {
      debugPrint(response.body);
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      final message = errorBody['message'] ?? 'Terjadi kesalahan';
      return left(message);
    }
  }

  Future<Either<String, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/auth/login'),
      body: {'email': email, 'password': password},
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return right(AuthResponseModel.fromJson(response.body));
    } else {
      debugPrint(response.body);
      return left(response.body);
    }
  }

  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/auth/logout'),
      headers: {'Authorization': 'Bearer ${authData!.token}'},
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return right(response.body);
    } else {
      debugPrint(response.body);
      return left(response.body);
    }
  }
}
