import 'dart:convert';

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
  final UserInfo userInfo;
  final InputSummary inputSummary;
  final ResponseMl responseMl;

  Data({
    required this.userInfo,
    required this.inputSummary,
    required this.responseMl,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    userInfo: UserInfo.fromMap(json["user_info"]),
    inputSummary: InputSummary.fromMap(json["input_summary"]),
    responseMl: ResponseMl.fromMap(json["response_ml"]),
  );

  Map<String, dynamic> toMap() => {
    "user_info": userInfo.toMap(),
    "input_summary": inputSummary.toMap(),
    "response_ml": responseMl.toMap(),
  };
}

class InputSummary {
  final int totalTransactions;
  final int originalTransactionCount;
  final DateRange dateRange;
  final int uniqueProducts;

  InputSummary({
    required this.totalTransactions,
    required this.originalTransactionCount,
    required this.dateRange,
    required this.uniqueProducts,
  });

  factory InputSummary.fromJson(String str) =>
      InputSummary.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InputSummary.fromMap(Map<String, dynamic> json) => InputSummary(
    totalTransactions: json["total_transactions"],
    originalTransactionCount: json["original_transaction_count"],
    dateRange: DateRange.fromMap(json["date_range"]),
    uniqueProducts: json["unique_products"],
  );

  Map<String, dynamic> toMap() => {
    "total_transactions": totalTransactions,
    "original_transaction_count": originalTransactionCount,
    "date_range": dateRange.toMap(),
    "unique_products": uniqueProducts,
  };
}

class DateRange {
  final String start;
  final String end;

  DateRange({required this.start, required this.end});

  factory DateRange.fromJson(String str) => DateRange.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DateRange.fromMap(Map<String, dynamic> json) =>
      DateRange(start: json["start"], end: json["end"]);

  Map<String, dynamic> toMap() => {"start": start, "end": end};
}

class ResponseMl {
  final List<Recommendation> recommendations;
  final String targetMonth;
  final String modelVersion;
  final DataSummary dataSummary;

  ResponseMl({
    required this.recommendations,
    required this.targetMonth,
    required this.modelVersion,
    required this.dataSummary,
  });

  factory ResponseMl.fromJson(String str) =>
      ResponseMl.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseMl.fromMap(Map<String, dynamic> json) => ResponseMl(
    recommendations: List<Recommendation>.from(
      json["recommendations"].map((x) => Recommendation.fromMap(x)),
    ),
    targetMonth: json["target_month"],
    modelVersion: json["model_version"],
    dataSummary: DataSummary.fromMap(json["data_summary"]),
  );

  Map<String, dynamic> toMap() => {
    "recommendations": List<dynamic>.from(
      recommendations.map((x) => x.toMap()),
    ),
    "target_month": targetMonth,
    "model_version": modelVersion,
    "data_summary": dataSummary.toMap(),
  };
}

class DataSummary {
  final int totalProducts;
  final int totalTransactions;
  final int uniqueMonths;
  final String monthRange;
  final String source;

  DataSummary({
    required this.totalProducts,
    required this.totalTransactions,
    required this.uniqueMonths,
    required this.monthRange,
    required this.source,
  });

  factory DataSummary.fromJson(String str) =>
      DataSummary.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataSummary.fromMap(Map<String, dynamic> json) => DataSummary(
    totalProducts: json["total_products"],
    totalTransactions: json["total_transactions"],
    uniqueMonths: json["unique_months"],
    monthRange: json["month_range"],
    source: json["source"],
  );

  Map<String, dynamic> toMap() => {
    "total_products": totalProducts,
    "total_transactions": totalTransactions,
    "unique_months": uniqueMonths,
    "month_range": monthRange,
    "source": source,
  };
}

class Recommendation {
  final String productTypeDetail;
  final int predictedQuantity;
  final double recommendationScore;
  final int dataPoints;

  Recommendation({
    required this.productTypeDetail,
    required this.predictedQuantity,
    required this.recommendationScore,
    required this.dataPoints,
  });

  factory Recommendation.fromJson(String str) =>
      Recommendation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Recommendation.fromMap(Map<String, dynamic> json) => Recommendation(
    productTypeDetail: json["product_type_detail"],
    predictedQuantity: json["predicted_quantity"],
    recommendationScore: json["recommendation_score"]?.toDouble(),
    dataPoints: json["data_points"],
  );

  Map<String, dynamic> toMap() => {
    "product_type_detail": productTypeDetail,
    "predicted_quantity": predictedQuantity,
    "recommendation_score": recommendationScore,
    "data_points": dataPoints,
  };
}

class UserInfo {
  final String name;
  final String email;

  UserInfo({required this.name, required this.email});

  factory UserInfo.fromJson(String str) => UserInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserInfo.fromMap(Map<String, dynamic> json) =>
      UserInfo(name: json["name"], email: json["email"]);

  Map<String, dynamic> toMap() => {"name": name, "email": email};
}
