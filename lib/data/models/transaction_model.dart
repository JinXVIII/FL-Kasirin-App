import 'dart:convert';

import 'product_model.dart';

class TransactionModel {
  final int id;
  final int? userId;
  final String invoiceNumber;
  final String? buyer;
  final String paymentMethod;
  final int totalPrice;
  final int paidAmount;
  final int changeAmount;
  final DateTime? updatedAt;
  final DateTime createdAt;
  final List<DetailTransactionModel>? details;

  TransactionModel({
    required this.id,
    this.userId,
    required this.invoiceNumber,
    this.buyer,
    required this.paymentMethod,
    required this.totalPrice,
    required this.paidAmount,
    required this.changeAmount,
    this.updatedAt,
    required this.createdAt,
    this.details,
  });

  factory TransactionModel.fromJson(String str) =>
      TransactionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
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
        details: json["details"] != null
            ? List<DetailTransactionModel>.from(
                json["details"].map((x) => DetailTransactionModel.fromMap(x)),
              )
            : null,
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "invoice_number": invoiceNumber,
    "buyer": buyer,
    "payment_method": paymentMethod,
    "total_price": totalPrice,
    "paid_amount": paidAmount,
    "change_amount": changeAmount,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "details": details != null
        ? List<dynamic>.from(details!.map((x) => x.toMap()))
        : null,
  };
}

class DetailTransactionModel {
  final int id;
  final int transactionId;
  final int productId;
  final int quantity;
  final int price;
  final int subtotal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductModel product;

  DetailTransactionModel({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory DetailTransactionModel.fromJson(String str) =>
      DetailTransactionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailTransactionModel.fromMap(Map<String, dynamic> json) =>
      DetailTransactionModel(
        id: json["id"],
        transactionId: json["transaction_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        price: json["price"],
        subtotal: json["subtotal"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: ProductModel.fromMap(json["product"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "transaction_id": transactionId,
    "product_id": productId,
    "quantity": quantity,
    "price": price,
    "subtotal": subtotal,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product": product.toMap(),
  };
}
