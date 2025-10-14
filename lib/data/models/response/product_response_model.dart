import 'dart:convert';

import '../product_model.dart';

class ProductResponseModel {
  final String message;
  final List<ProductModel> data;

  ProductResponseModel({required this.message, required this.data});

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        message: json["message"],
        data: List<ProductModel>.from(
          json["data"].map((x) => ProductModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
