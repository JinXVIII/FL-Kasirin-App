import 'dart:convert';

import 'product_type_model.dart';

class ProductModel {
  final int id;
  final String userId;
  final String productCategoryId;
  final String productUnitId;
  final String name;
  final dynamic thumbnail;
  final String purchasePrice;
  final String sellingPrice;
  final String stock;
  final String isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductTypeModel productCategory;
  final ProductTypeModel productUnit;

  ProductModel({
    required this.id,
    required this.userId,
    required this.productCategoryId,
    required this.productUnitId,
    required this.name,
    required this.thumbnail,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.productCategory,
    required this.productUnit,
  });

  factory ProductModel.fromJson(String str) =>
      ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    userId: json["user_id"],
    productCategoryId: json["product_category_id"],
    productUnitId: json["product_unit_id"],
    name: json["name"],
    thumbnail: json["thumbnail"],
    purchasePrice: json["purchase_price"],
    sellingPrice: json["selling_price"],
    stock: json["stock"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    productCategory: ProductTypeModel.fromMap(json["product_category"]),
    productUnit: ProductTypeModel.fromMap(json["product_unit"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "product_category_id": productCategoryId,
    "product_unit_id": productUnitId,
    "name": name,
    "thumbnail": thumbnail,
    "purchase_price": purchasePrice,
    "selling_price": sellingPrice,
    "stock": stock,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product_category": productCategory.toMap(),
    "product_unit": productUnit.toMap(),
  };
}
