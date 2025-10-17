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
}
