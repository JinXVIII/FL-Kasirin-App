import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../cores/constants/variables.dart';

import '../models/response/auth_response_model.dart';

class AuthRemoteDatasource {
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
      print(response.body);
      return right(AuthResponseModel.fromJson(response.body));
    } else {
      print(response.body);
      return left(response.body);
    }
  }
}
