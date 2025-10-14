import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../cores/constants/variables.dart';

import '../models/response/product_type_response_model.dart';
import '../models/response/product_response_model.dart';

import 'auth_local_datasource.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getAllProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/products'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      debugPrint('Error response: ${response.body}');
      return const Left('Terjadi kesalahan saat mengambil data produk');
    }
  }

  Future<Either<String, ProductTypeResponseModel>>
  getAllProductCategories() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/product-categories'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Right(ProductTypeResponseModel.fromJson(response.body));
    } else {
      debugPrint('Error response: ${response.body}');
      return const Left('Terjadi kesalahan saat mengambil data produk');
    }
  }

  Future<Either<String, ProductTypeResponseModel>> getAllProductUnits() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/product-units'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Right(ProductTypeResponseModel.fromJson(response.body));
    } else {
      debugPrint('Error response: ${response.body}');
      return const Left('Terjadi kesalahan saat mengambil data produk');
    }
  }
}
