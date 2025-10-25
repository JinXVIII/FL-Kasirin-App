import 'dart:convert';

import '../business_category_model.dart';

class BusinessCategoryResponseModel {
  final String message;
  final List<BusinessCategoryModel> data;

  BusinessCategoryResponseModel({required this.message, required this.data});

  factory BusinessCategoryResponseModel.fromJson(String str) =>
      BusinessCategoryResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BusinessCategoryResponseModel.fromMap(Map<String, dynamic> json) =>
      BusinessCategoryResponseModel(
        message: json["message"],
        data: List<BusinessCategoryModel>.from(
          json["data"].map((x) => BusinessCategoryModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
