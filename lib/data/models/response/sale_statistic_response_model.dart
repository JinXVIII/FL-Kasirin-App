import 'dart:convert';

class SaleStatisticResponseModel {
  final bool success;
  final List<SaleCountModel> data;

  SaleStatisticResponseModel({required this.success, required this.data});

  factory SaleStatisticResponseModel.fromJson(String str) =>
      SaleStatisticResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleStatisticResponseModel.fromMap(Map<String, dynamic> json) =>
      SaleStatisticResponseModel(
        success: json["success"],
        data: List<SaleCountModel>.from(
          json["data"].map((x) => SaleCountModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class SaleCountModel {
  final DateTime date;
  final int count;
  final dynamic totalRevenue;
  final String dayCode;
  final String dayName;

  SaleCountModel({
    required this.date,
    required this.count,
    required this.totalRevenue,
    required this.dayCode,
    required this.dayName,
  });

  factory SaleCountModel.fromJson(String str) =>
      SaleCountModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleCountModel.fromMap(Map<String, dynamic> json) => SaleCountModel(
    date: DateTime.parse(json["date"]),
    count: json["count"],
    totalRevenue: json["total_revenue"],
    dayCode: json["day_code"],
    dayName: json["day_name"],
  );

  Map<String, dynamic> toMap() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "count": count,
    "total_revenue": totalRevenue,
    "day_code": dayCode,
    "day_name": dayName,
  };
}
