import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final Map<String, dynamic> product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'product': product, 'quantity': quantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(product: json['product'], quantity: json['quantity']);
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  final String _cartKey = 'cart_items';

  List<CartItem> get cartItems => _cartItems;

  int get totalItems {
    return _cartItems.fold(0, (total, item) => total + item.quantity);
  }

  int get totalPrice {
    return _cartItems.fold(0, (total, item) {
      return total + (item.product['price'] as int) * item.quantity;
    });
  }

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString(_cartKey);

    if (cartString != null && cartString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(cartString);
        _cartItems = jsonList.map((json) => CartItem.fromJson(json)).toList();
      } catch (e) {
        _cartItems = [];
      }
    } else {
      _cartItems = [];
    }

    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartList = _cartItems.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, jsonEncode(cartList));
  }

  void addToCart(Map<String, dynamic> product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product['id'] == product['id'],
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += 1;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    _saveCart();
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product['id'] == productId,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += 1;
      _saveCart();
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product['id'] == productId,
    );

    if (existingIndex != -1) {
      if (_cartItems[existingIndex].quantity > 1) {
        _cartItems[existingIndex].quantity -= 1;
      } else {
        _cartItems.removeAt(existingIndex);
      }
      _saveCart();
      notifyListeners();
    }
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product['id'] == productId);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _cartItems = [];
    _saveCart();
    notifyListeners();
  }

  int getProductQuantity(int productId) {
    final item = _cartItems.firstWhere(
      (item) => item.product['id'] == productId,
      orElse: () => CartItem(product: {}, quantity: 0),
    );
    return item.quantity;
  }
}
