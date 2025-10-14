import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../data/datasources/product_remote_datasource.dart';
import '../../data/models/product_model.dart';
import '../../data/models/product_type_model.dart';
import '../../data/models/response/product_response_model.dart';
import '../../data/models/response/product_type_response_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRemoteDatasource _remoteDatasource;

  ProductProvider(this._remoteDatasource);

  // Product states
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;

  // Category states
  List<ProductTypeModel> _categories = [];
  bool _isLoadingCategories = false;
  String? _categoriesError;

  // Unit states
  List<ProductTypeModel> _units = [];
  bool _isLoadingUnits = false;
  String? _unitsError;

  // Product getters
  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Category getters
  List<ProductTypeModel> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoriesError => _categoriesError;

  // Unit getters
  List<ProductTypeModel> get units => _units;
  bool get isLoadingUnits => _isLoadingUnits;
  String? get unitsError => _unitsError;

  // Product methods
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

  // Category methods
  Future<void> getAllCategories() async {
    _setLoadingCategories(true);
    _categoriesError = null;

    final Either<String, ProductTypeResponseModel> result =
        await _remoteDatasource.getAllProductCategories();

    result.fold(
      (error) {
        _categoriesError = error;
        _setLoadingCategories(false);
      },
      (response) {
        _categories = response.data;
        _setLoadingCategories(false);
      },
    );
  }

  // Unit methods
  Future<void> getAllUnits() async {
    _setLoadingUnits(true);
    _unitsError = null;

    final Either<String, ProductTypeResponseModel> result =
        await _remoteDatasource.getAllProductUnits();

    result.fold(
      (error) {
        _unitsError = error;
        _setLoadingUnits(false);
      },
      (response) {
        _units = response.data;
        _setLoadingUnits(false);
      },
    );
  }

  // Load all data (products, categories, units)
  Future<void> loadAllData() async {
    await Future.wait([getAllProducts(), getAllCategories(), getAllUnits()]);
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

  void _setLoadingCategories(bool value) {
    _isLoadingCategories = value;
    notifyListeners();
  }

  void _setLoadingUnits(bool value) {
    _isLoadingUnits = value;
    notifyListeners();
  }

  void refresh() {
    getAllProducts();
  }

  void refreshCategories() {
    getAllCategories();
  }

  void refreshUnits() {
    getAllUnits();
  }
}
