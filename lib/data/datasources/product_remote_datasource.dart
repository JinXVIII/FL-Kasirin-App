import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../cores/constants/variables.dart';
import '../models/request/product_request_model.dart';
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

  Future<Either<String, AddProductResponseModel>> addProduct(
    ProductRequestModel productRequestModel,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final Map<String, String> headers = {
      'Authorization': 'Bearer ${authData?.token}',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/products'),
    );

    request.fields.addAll(productRequestModel.toMap());

    // Add thumbnail if provided (optional)
    if (productRequestModel.thumbnail != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'thumbnail',
          productRequestModel.thumbnail!.path,
        ),
      );
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();
    debugPrint("Response body: $body");

    if (response.statusCode == 201) {
      return right(AddProductResponseModel.fromJson(body));
    } else {
      return left(body);
    }
  }

  Future<Either<String, DetailProductResponseModel>> getProductById(
    int productId,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/products/$productId'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return right(DetailProductResponseModel.fromJson(response.body));
    } else {
      debugPrint('Error response: ${response.body}');
      return left(response.body);
    }
  }

  Future<Either<String, EditProductResponseModel>> editProduct(
    ProductRequestModel productRequestModel,
    int productId,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final Map<String, String> headers = {
      'Authorization': 'Bearer ${authData?.token}',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/products/$productId'),
    );

    // Add method spoofing for PUT
    request.fields['_method'] = 'PUT';
    request.fields.addAll(productRequestModel.toMap());

    // Add thumbnail if provided (optional)
    if (productRequestModel.thumbnail != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'thumbnail',
          productRequestModel.thumbnail!.path,
        ),
      );
      debugPrint('Thumbnail added successfully');
    }

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();
    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: $body');

    if (response.statusCode == 200) {
      debugPrint('Edit product successful');
      return right(EditProductResponseModel.fromJson(body));
    } else {
      debugPrint('Edit product failed');
      return left(body);
    }
  }

  Future<Either<String, String>> deleteProduct(int productId) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.delete(
      Uri.parse('${Variables.baseUrl}/products/$productId'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return const Right('Produk berhasil dihapus');
    } else {
      debugPrint('Error response: ${response.body}');
      return Left('Gagal menghapus produk: ${response.body}');
    }
  }
}
