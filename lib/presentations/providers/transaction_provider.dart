import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../data/datasources/transaction_remote_datasource.dart';
import '../../data/models/request/transaction_request_model.dart';
import '../../data/models/response/transaction_response_model.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRemoteDatasource _remoteDatasource;

  TransactionProvider(this._remoteDatasource);

  // Transaction states
  bool _isProcessingTransaction = false;
  String? _transactionError;
  AddTransactionResponseModel? _lastTransaction;

  // Getters
  bool get isProcessingTransaction => _isProcessingTransaction;
  String? get transactionError => _transactionError;
  AddTransactionResponseModel? get lastTransaction => _lastTransaction;

  // Create transaction method
  Future<bool> createTransaction(
    TransactionRequestModel transactionRequest,
  ) async {
    _setProcessingTransaction(true);
    _transactionError = null;

    final Either<String, AddTransactionResponseModel> result =
        await _remoteDatasource.createTransaction(transactionRequest);

    return result.fold(
      (error) {
        _transactionError = error;
        _setProcessingTransaction(false);
        return false;
      },
      (response) {
        _lastTransaction = response;
        _setProcessingTransaction(false);
        return true;
      },
    );
  }

  // Set loading state
  void _setProcessingTransaction(bool value) {
    _isProcessingTransaction = value;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _transactionError = null;
    notifyListeners();
  }

  // Clear last transaction
  void clearLastTransaction() {
    _lastTransaction = null;
    notifyListeners();
  }
}
