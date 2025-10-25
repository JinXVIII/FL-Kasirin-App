import 'dart:convert';

import '../product_type_model.dart';

class ProductTypeResponseModel {
  final String message;
  final List<ProductTypeModel> data;

  ProductTypeResponseModel({required this.message, required this.data});

  factory ProductTypeResponseModel.fromJson(String str) =>
      ProductTypeResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductTypeResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductTypeResponseModel(
        message: json["message"],
        data: List<ProductTypeModel>.from(
          json["data"].map((x) => ProductTypeModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
