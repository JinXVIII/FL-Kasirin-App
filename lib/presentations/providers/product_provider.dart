import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../data/datasources/product_remote_datasource.dart';
import '../../data/models/product_model.dart';
import '../../data/models/response/product_response_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRemoteDatasource _remoteDatasource;

  ProductProvider(this._remoteDatasource);

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getAllProducts() async {
    _setLoading(true);
    _error = null;

    final Either<String, ProductResponseModel> result = await _remoteDatasource
        .getAllProducts();

    result.fold(
      (error) {
        _error = error;
        _setLoading(false);
      },
      (response) {
        _products = response.data;
        _filteredProducts = List.from(_products);
        _setLoading(false);
      },
    );
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.productCategory.name.toLowerCase().contains(
              query.toLowerCase(),
            );
      }).toList();
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void refresh() {
    getAllProducts();
  }
}
