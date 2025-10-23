import 'dart:convert';

import '../business_type_model.dart';

class BusinessTypeResponseModel {
  final String message;
  final List<BusinessTypeModel> data;

  BusinessTypeResponseModel({required this.message, required this.data});

  factory BusinessTypeResponseModel.fromJson(String str) =>
      BusinessTypeResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BusinessTypeResponseModel.fromMap(Map<String, dynamic> json) =>
      BusinessTypeResponseModel(
        message: json["message"],
        data: List<BusinessTypeModel>.from(
          json["data"].map((x) => BusinessTypeModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}
