import 'dart:convert';

class StatisticResponseModel {
  final bool success;
  final Data data;

  StatisticResponseModel({required this.success, required this.data});

  factory StatisticResponseModel.fromJson(String str) =>
      StatisticResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StatisticResponseModel.fromMap(Map<String, dynamic> json) =>
      StatisticResponseModel(
        success: json["success"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"success": success, "data": data.toMap()};
}

class Data {
  final StatisticModel today;
  final StatisticModel month;

  Data({required this.today, required this.month});

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    today: StatisticModel.fromMap(json["today"]),
    month: StatisticModel.fromMap(json["month"]),
  );

  Map<String, dynamic> toMap() => {
    "today": today.toMap(),
    "month": month.toMap(),
  };
}

class StatisticModel {
  final int transactions;
  final int revenue;

  StatisticModel({required this.transactions, required this.revenue});

  factory StatisticModel.fromJson(String str) =>
      StatisticModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StatisticModel.fromMap(Map<String, dynamic> json) => StatisticModel(
    transactions: json["transactions"],
    revenue: json["revenue"],
  );

  Map<String, dynamic> toMap() => {
    "transactions": transactions,
    "revenue": revenue,
  };
}
