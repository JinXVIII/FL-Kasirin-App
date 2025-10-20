import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'auth_local_datasource.dart';

import '../../cores/constants/variables.dart';

import '../models/request/transaction_request_model.dart';
import '../models/response/transaction_response_model.dart';

class TransactionRemoteDatasource {
  Future<Either<String, AddTransactionResponseModel>> createTransaction(
    TransactionRequestModel transactionRequestModel,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/transactions'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: transactionRequestModel.toJson(),
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 201) {
      debugPrint('Transaction created successfully');
      try {
        final transactionResponse = AddTransactionResponseModel.fromJson(
          response.body,
        );
        debugPrint('Transaction ID: ${transactionResponse.data.id}');
        debugPrint('Invoice Number: ${transactionResponse.data.invoiceNumber}');
        debugPrint(
          'Transaction created at: ${transactionResponse.data.createdAt}',
        );
        return Right(transactionResponse);
      } catch (e) {
        debugPrint('Error parsing response: $e');
        return Left('Error parsing response: $e');
      }
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, HistoryTransactionResponseModel>>
  getTransactionHistory({
    String? startDate,
    String? endDate,
    int page = 1,
  }) async {
    final authData = await AuthLocalDatasource().getAuthData();

    // Build query parameters
    Map<String, String> queryParams = {'page': page.toString()};
    if (startDate != null) queryParams['startdate'] = startDate;
    if (endDate != null) queryParams['enddate'] = endDate;

    // Create URI with query parameters
    final uri = Uri.parse(
      '${Variables.baseUrl}/transactions',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      debugPrint('Transaction history retrieved successfully');
      try {
        final historyResponse = HistoryTransactionResponseModel.fromJson(
          response.body,
        );
        debugPrint('Total transactions: ${historyResponse.data.total}');
        debugPrint('Current page: ${historyResponse.data.currentPage}');
        debugPrint('Has more: ${historyResponse.data.hasMore}');
        return Right(historyResponse);
      } catch (e) {
        debugPrint('Error parsing response: $e');
        return Left('Error parsing response: $e');
      }
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, DetailTransactionResponseModel>> getTransactionDetail(
    int transactionId,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/transactions/$transactionId'),
      headers: {
        'Authorization': 'Bearer ${authData?.token}',
        'Accept': 'application/json',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      debugPrint('Transaction detail retrieved successfully');
      try {
        final detailResponse = DetailTransactionResponseModel.fromJson(
          response.body,
        );
        debugPrint('Transaction ID: ${detailResponse.data.id}');
        debugPrint('Invoice Number: ${detailResponse.data.invoiceNumber}');
        debugPrint('Total Price: ${detailResponse.data.totalPrice}');
        debugPrint(
          'Details Count: ${detailResponse.data.details?.length ?? 0}',
        );
        return Right(detailResponse);
      } catch (e) {
        debugPrint('Error parsing response: $e');
        return Left('Error parsing response: $e');
      }
    } else {
      debugPrint('Error retrieving transaction detail: ${response.body}');
      return Left(response.body);
    }
  }
}
