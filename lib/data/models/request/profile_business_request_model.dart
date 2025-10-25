import 'dart:convert';

class ProfileBusinessRequestModel {
  final String storeName;
  final int businessTypeId;
  final String address;
  final String? phoneNumber;

  ProfileBusinessRequestModel({
    required this.storeName,
    required this.businessTypeId,
    required this.address,
    this.phoneNumber,
  });

  factory ProfileBusinessRequestModel.fromJson(String str) =>
      ProfileBusinessRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileBusinessRequestModel.fromMap(Map<String, dynamic> json) =>
      ProfileBusinessRequestModel(
        storeName: json["store_name"],
        businessTypeId: json["business_type_id"],
        address: json["address"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toMap() => {
    "store_name": storeName,
    "business_type_id": businessTypeId,
    "address": address,
    if (phoneNumber != null) "phone_number": phoneNumber,
  };
}
