import 'dart:convert';

class BusinessTypeModel {
  final int id;
  final int businessCategoryId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BusinessTypeModel({
    required this.id,
    required this.businessCategoryId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessTypeModel.fromJson(String str) =>
      BusinessTypeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BusinessTypeModel.fromMap(Map<String, dynamic> json) =>
      BusinessTypeModel(
        id: json["id"],
        businessCategoryId: json["business_category_id"],
        name: json["name"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "business_category_id": businessCategoryId,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
