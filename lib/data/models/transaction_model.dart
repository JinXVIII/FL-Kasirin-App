import 'dart:convert';

class TransactionModel {
  final int? userId;
  final String invoiceNumber;
  final String? buyer;
  final String paymentMethod;
  final int totalPrice;
  final int paidAmount;
  final int changeAmount;
  final DateTime? updatedAt;
  final DateTime createdAt;
  final int id;

  TransactionModel({
    this.userId,
    required this.invoiceNumber,
    this.buyer,
    required this.paymentMethod,
    required this.totalPrice,
    required this.paidAmount,
    required this.changeAmount,
    this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory TransactionModel.fromJson(String str) =>
      TransactionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      TransactionModel(
        userId: json["user_id"],
        invoiceNumber: json["invoice_number"],
        buyer: json["buyer"],
        paymentMethod: json["payment_method"],
        totalPrice: json["total_price"],
        paidAmount: json["paid_amount"],
        changeAmount: json["change_amount"],
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "invoice_number": invoiceNumber,
    "buyer": buyer,
    "payment_method": paymentMethod,
    "total_price": totalPrice,
    "paid_amount": paidAmount,
    "change_amount": changeAmount,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
