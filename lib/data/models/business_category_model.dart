import 'dart:convert';

class BusinessCategoryModel {
  final int id;
  final String name;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BusinessCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessCategoryModel.fromJson(String str) =>
      BusinessCategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BusinessCategoryModel.fromMap(Map<String, dynamic> json) =>
      BusinessCategoryModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
