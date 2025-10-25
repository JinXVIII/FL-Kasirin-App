import 'dart:convert';

import 'business_type_model.dart';

class BusinessProfileModel {
  final int id;
  final int userId;
  final int businessTypeId;
  final String storeName;
  final String phoneNumber;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BusinessTypeModel businessType;

  BusinessProfileModel({
    required this.id,
    required this.userId,
    required this.businessTypeId,
    required this.storeName,
    required this.phoneNumber,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.businessType,
  });

  factory BusinessProfileModel.fromJson(String str) =>
      BusinessProfileModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BusinessProfileModel.fromMap(Map<String, dynamic> json) =>
      BusinessProfileModel(
        id: json["id"],
        userId: json["user_id"],
        businessTypeId: json["business_type_id"],
        storeName: json["store_name"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        businessType: BusinessTypeModel.fromMap(json["business_type"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "business_type_id": businessTypeId,
    "store_name": storeName,
    "phone_number": phoneNumber,
    "address": address,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "business_type": businessType.toMap(),
  };
}
