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

class AddProductResponseModel {
  final String message;
  final ProductModel data;

  AddProductResponseModel({required this.message, required this.data});

  factory AddProductResponseModel.fromJson(String str) =>
      AddProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddProductResponseModel.fromMap(Map<String, dynamic> json) =>
      AddProductResponseModel(
        message: json["message"],
        data: ProductModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"message": message, "data": data.toMap()};
}

class DetailProductResponseModel {
  final String message;
  final ProductModel data;

  DetailProductResponseModel({required this.message, required this.data});

  factory DetailProductResponseModel.fromJson(String str) =>
      DetailProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailProductResponseModel.fromMap(Map<String, dynamic> json) =>
      DetailProductResponseModel(
        message: json["message"],
        data: ProductModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"message": message, "data": data.toMap()};
}

class EditProductResponseModel {
  final String message;
  final ProductModel data;

  EditProductResponseModel({required this.message, required this.data});

  factory EditProductResponseModel.fromJson(String str) =>
      EditProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EditProductResponseModel.fromMap(Map<String, dynamic> json) =>
      EditProductResponseModel(
        message: json["message"],
        data: ProductModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"message": message, "data": data.toMap()};
}
