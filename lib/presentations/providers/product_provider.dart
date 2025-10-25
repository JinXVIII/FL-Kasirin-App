import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../data/datasources/product_remote_datasource.dart';

import '../../data/models/product_model.dart';
import '../../data/models/product_type_model.dart';
import '../../data/models/request/product_request_model.dart';
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

  // Add product states
  bool _isAddingProduct = false;
  String? _addProductError;

  // Detail product states
  bool _isLoadingDetailProduct = false;
  String? _detailProductError;
  ProductModel? _detailProduct;

  // Edit product states
  bool _isEditingProduct = false;
  String? _editProductError;

  // Delete product states
  bool _isDeletingProduct = false;
  String? _deleteProductError;

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

  // Add product getters
  bool get isAddingProduct => _isAddingProduct;
  String? get addProductError => _addProductError;

  // Detail product getters
  bool get isLoadingDetailProduct => _isLoadingDetailProduct;
  String? get detailProductError => _detailProductError;
  ProductModel? get detailProduct => _detailProduct;

  // Edit product getters
  bool get isEditingProduct => _isEditingProduct;
  String? get editProductError => _editProductError;

  // Delete product getters
  bool get isDeletingProduct => _isDeletingProduct;
  String? get deleteProductError => _deleteProductError;

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

  // Add product method
  Future<bool> addProduct(ProductRequestModel productRequest) async {
    _setAddingProduct(true);
    _addProductError = null;

    final Either<String, AddProductResponseModel> result =
        await _remoteDatasource.addProduct(productRequest);

    return result.fold(
      (error) {
        _addProductError = error;
        _setAddingProduct(false);
        return false;
      },
      (response) {
        _setAddingProduct(false);
        getAllProducts();
        return true;
      },
    );
  }

  // Get product by ID method
  Future<bool> getProductById(int productId) async {
    _setLoadingDetailProduct(true);
    _detailProductError = null;

    final Either<String, DetailProductResponseModel> result =
        await _remoteDatasource.getProductById(productId);

    return result.fold(
      (error) {
        _detailProductError = error;
        _setLoadingDetailProduct(false);
        return false;
      },
      (response) {
        _detailProduct = response.data;
        _setLoadingDetailProduct(false);
        return true;
      },
    );
  }

  // Edit product method
  Future<bool> editProduct(
    ProductRequestModel productRequest,
    int productId,
  ) async {
    _setEditingProduct(true);
    _editProductError = null;

    final Either<String, EditProductResponseModel> result =
        await _remoteDatasource.editProduct(productRequest, productId);

    return result.fold(
      (error) {
        _editProductError = error;
        _setEditingProduct(false);
        return false;
      },
      (response) {
        _setEditingProduct(false);
        getAllProducts();
        return true;
      },
    );
  }

  // Delete product method
  Future<bool> deleteProduct(int productId) async {
    _setDeletingProduct(true);
    _deleteProductError = null;

    final Either<String, String> result = await _remoteDatasource.deleteProduct(
      productId,
    );

    return result.fold(
      (error) {
        _deleteProductError = error;
        _setDeletingProduct(false);
        return false;
      },
      (response) {
        _setDeletingProduct(false);
        getAllProducts();
        return true;
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
        final nameMatch = product.name.toLowerCase().contains(
          query.toLowerCase(),
        );
        final categoryMatch =
            product.productCategory?.name.toLowerCase().contains(
              query.toLowerCase(),
            ) ??
            false;
        return nameMatch || categoryMatch;
      }).toList();
    }
    notifyListeners();
  }

  // Set loading states
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setAddingProduct(bool value) {
    _isAddingProduct = value;
    notifyListeners();
  }

  void _setLoadingDetailProduct(bool value) {
    _isLoadingDetailProduct = value;
    _safeNotifyListeners();
  }

  void _setEditingProduct(bool value) {
    _isEditingProduct = value;
    _safeNotifyListeners();
  }

  void _setDeletingProduct(bool value) {
    _isDeletingProduct = value;
    _safeNotifyListeners();
  }

  void _setLoadingCategories(bool value) {
    _isLoadingCategories = value;
    notifyListeners();
  }

  void _setLoadingUnits(bool value) {
    _isLoadingUnits = value;
    notifyListeners();
  }

  void _safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Refresh methods
  void refresh() => getAllProducts();
  void refreshCategories() => getAllCategories();
  void refreshUnits() => getAllUnits();
}
