import 'dart:convert';

import '../business_profile_model.dart';

class BusinessProfileResponseModel {
  final String message;
  final Data data;

  BusinessProfileResponseModel({required this.message, required this.data});

  factory BusinessProfileResponseModel.fromJson(String str) =>
      BusinessProfileResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BusinessProfileResponseModel.fromMap(Map<String, dynamic> json) =>
      BusinessProfileResponseModel(
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"message": message, "data": data.toMap()};
}

class Data {
  final int id;
  final String name;
  final String email;
  final dynamic emailVerifiedAt;
  final String role;
  final dynamic profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BusinessProfileModel businessProfile;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.role,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.businessProfile,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    role: json["role"],
    profilePicture: json["profile_picture"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    businessProfile: BusinessProfileModel.fromMap(json["business_profile"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "role": role,
    "profile_picture": profilePicture,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "business_profile": businessProfile.toMap(),
  };
}
