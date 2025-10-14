import 'dart:convert';

class ProductTypeModel {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductTypeModel.fromJson(String str) =>
      ProductTypeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductTypeModel.fromMap(Map<String, dynamic> json) =>
      ProductTypeModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
