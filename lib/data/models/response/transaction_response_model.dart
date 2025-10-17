import 'dart:convert';

import '../transaction_model.dart';

class HistoryTransactionResponseModel {
  final bool success;
  final Data data;

  HistoryTransactionResponseModel({required this.success, required this.data});

  factory HistoryTransactionResponseModel.fromJson(String str) =>
      HistoryTransactionResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HistoryTransactionResponseModel.fromMap(Map<String, dynamic> json) =>
      HistoryTransactionResponseModel(
        success: json["success"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"success": success, "data": data.toMap()};
}

class AddTransactionResponseModel {
  final bool success;
  final String message;
  final TransactionModel data;

  AddTransactionResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddTransactionResponseModel.fromJson(String str) =>
      AddTransactionResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddTransactionResponseModel.fromMap(Map<String, dynamic> json) =>
      AddTransactionResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        data: TransactionModel.fromMap(json["data"] ?? {}),
      );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data.toMap(),
  };
}

class Data {
  final int currentPage;
  final List<TransactionModel> data;
  final int perPage;
  final int total;
  final bool hasMore;
  final dynamic prevPageUrl;
  final dynamic nextPageUrl;

  Data({
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.total,
    required this.hasMore,
    required this.prevPageUrl,
    required this.nextPageUrl,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<TransactionModel>.from(
      json["data"].map((x) => TransactionModel.fromMap(x)),
    ),
    perPage: json["per_page"],
    total: json["total"],
    hasMore: json["has_more"],
    prevPageUrl: json["prev_page_url"],
    nextPageUrl: json["next_page_url"],
  );

  Map<String, dynamic> toMap() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "per_page": perPage,
    "total": total,
    "has_more": hasMore,
    "prev_page_url": prevPageUrl,
    "next_page_url": nextPageUrl,
  };
}
