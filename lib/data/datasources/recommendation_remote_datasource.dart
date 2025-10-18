import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../cores/constants/variables.dart';

import '../models/response/recommendation_response_model.dart';

import 'auth_local_datasource.dart';

class RecommendationRemoteDatasource {
  Future<Either<String, RecommendationResponseModel>>
  getRecommendationProdductsML() async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/recommendations'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final recommendationResponse = RecommendationResponseModel.fromJson(
          response.body,
        );
        debugPrint(
          'Total transactions: ${recommendationResponse.data.inputSummary.uniqueProducts}',
        );
        debugPrint(
          'Product recommendation: ${recommendationResponse.data.responseMl.recommendations}',
        );

        return Right(recommendationResponse);
      } catch (e) {
        debugPrint('Error parsing response: $e');
        return Left('Error parsing response: $e');
      }
    } else {
      debugPrint('Error response: ${response.body}');
      return const Left('Terjadi kesalahan saat mengambil data produk');
    }
  }
}
