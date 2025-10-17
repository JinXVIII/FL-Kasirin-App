import 'dart:convert';

class TransactionRequestModel {
  final String? buyer;
  final String paymentMethod;
  final int totalPrice;
  final int paidAmount;
  final int changeAmount;
  final List<TransactionItem> items;

  TransactionRequestModel({
    this.buyer,
    required this.paymentMethod,
    required this.totalPrice,
    required this.paidAmount,
    required this.changeAmount,
    required this.items,
  });

  factory TransactionRequestModel.fromJson(String str) =>
      TransactionRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionRequestModel.fromMap(Map<String, dynamic> json) =>
      TransactionRequestModel(
        buyer: json["buyer"],
        paymentMethod: json["payment_method"],
        totalPrice: json["total_price"],
        paidAmount: json["paid_amount"],
        changeAmount: json["change_amount"],
        items: List<TransactionItem>.from(
          json["items"].map((x) => TransactionItem.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "buyer": buyer,
    "payment_method": paymentMethod,
    "total_price": totalPrice,
    "paid_amount": paidAmount,
    "change_amount": changeAmount,
    "items": List<dynamic>.from(items.map((x) => x.toMap())),
  };
}

class TransactionItem {
  final int productId;
  final int quantity;
  final int price;
  final int subtotal;

  TransactionItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(String str) =>
      TransactionItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionItem.fromMap(Map<String, dynamic> json) => TransactionItem(
    productId: json["product_id"],
    quantity: json["quantity"],
    price: json["price"],
    subtotal: json["subtotal"],
  );

  Map<String, dynamic> toMap() => {
    "product_id": productId,
    "quantity": quantity,
    "price": price,
    "subtotal": subtotal,
  };
}
