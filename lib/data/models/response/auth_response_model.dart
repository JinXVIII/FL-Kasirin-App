import 'dart:convert';

import '../user_model.dart';

class AuthResponseModel {
  final User user;
  final String token;

  AuthResponseModel({required this.user, required this.token});

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(user: User.fromMap(json["user"]), token: json["token"]);

  Map<String, dynamic> toMap() => {"user": user.toMap(), "token": token};
}
