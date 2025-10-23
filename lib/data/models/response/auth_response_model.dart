import 'dart:convert';

import '../user_model.dart';

class AuthResponseModel {
  final UserModel user;
  final String token;
  final bool? hasBusinessProfile;

  AuthResponseModel({
    required this.user,
    required this.token,
    this.hasBusinessProfile,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: UserModel.fromMap(json["user"]),
        token: json["token"],
        hasBusinessProfile: json["has_business_profile"],
      );

  Map<String, dynamic> toMap() => {
    "user": user.toMap(),
    "token": token,
    "has_business_profile": hasBusinessProfile,
  };
}
