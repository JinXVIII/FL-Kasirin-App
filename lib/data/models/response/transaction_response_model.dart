import 'dart:convert';

import '../transaction_model.dart';

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
