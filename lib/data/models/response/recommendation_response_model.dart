import 'dart:convert';

import '../recommendation_model.dart';

class RecommendationResponseModel {
  final bool success;
  final String message;
  final Data data;

  RecommendationResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RecommendationResponseModel.fromJson(String str) =>
      RecommendationResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RecommendationResponseModel.fromMap(Map<String, dynamic> json) =>
      RecommendationResponseModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data.toMap(),
  };
}

class Data {
  final List<RecommendationModel> recommendations;
  final int totalTransactions;
  final int totalProducts;
  final String targetMonth;
  final MonthRange monthRange;
  final String modelVersion;

  Data({
    required this.recommendations,
    required this.totalTransactions,
    required this.totalProducts,
    required this.targetMonth,
    required this.monthRange,
    required this.modelVersion,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    recommendations: List<RecommendationModel>.from(
      json["recommendations"].map((x) => RecommendationModel.fromMap(x)),
    ),
    totalTransactions: json["total_transactions"],
    totalProducts: json["total_products"],
    targetMonth: json["target_month"],
    monthRange: MonthRange.fromMap(json["month_range"]),
    modelVersion: json["model_version"],
  );

  Map<String, dynamic> toMap() => {
    "recommendations": List<dynamic>.from(
      recommendations.map((x) => x.toMap()),
    ),
    "total_transactions": totalTransactions,
    "total_products": totalProducts,
    "target_month": targetMonth,
    "month_range": monthRange.toMap(),
    "model_version": modelVersion,
  };
}

class MonthRange {
  final String start;
  final String end;

  MonthRange({required this.start, required this.end});

  factory MonthRange.fromJson(String str) =>
      MonthRange.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthRange.fromMap(Map<String, dynamic> json) =>
      MonthRange(start: json["start"], end: json["end"]);

  Map<String, dynamic> toMap() => {"start": start, "end": end};
}
