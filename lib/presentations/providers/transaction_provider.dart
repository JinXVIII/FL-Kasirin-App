import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../data/datasources/transaction_remote_datasource.dart';

import '../../data/models/transaction_model.dart';
import '../../data/models/request/transaction_request_model.dart';
import '../../data/models/response/transaction_response_model.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRemoteDatasource _remoteDatasource;

  TransactionProvider(this._remoteDatasource);

  // Transaction states
  bool _isProcessingTransaction = false;
  String? _transactionError;
  AddTransactionResponseModel? _lastTransaction;

  // Transaction history states
  bool _isLoadingHistory = false;
  String? _historyError;
  HistoryTransactionResponseModel? _transactionHistory;
  List<TransactionModel> _allTransactions = [];

  // Transaction detail states
  bool _isLoadingDetail = false;
  String? _detailError;
  DetailTransactionResponseModel? _transactionDetail;

  // Getters
  bool get isProcessingTransaction => _isProcessingTransaction;
  String? get transactionError => _transactionError;
  AddTransactionResponseModel? get lastTransaction => _lastTransaction;

  bool get isLoadingHistory => _isLoadingHistory;
  String? get historyError => _historyError;
  HistoryTransactionResponseModel? get transactionHistory =>
      _transactionHistory;
  List<TransactionModel> get allTransactions => _allTransactions;

  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;
  DetailTransactionResponseModel? get transactionDetail => _transactionDetail;

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

  // Get transaction history method
  Future<bool> getTransactionHistory({
    String? startDate,
    String? endDate,
    int page = 1,
    bool refresh = false,
  }) async {
    _setLoadingHistory(true);
    _historyError = null;

    // If refresh, clear existing data
    if (refresh) {
      _allTransactions = [];
      _transactionHistory = null;
    }

    final Either<String, HistoryTransactionResponseModel> result =
        await _remoteDatasource.getTransactionHistory(
          startDate: startDate,
          endDate: endDate,
          page: page,
        );

    return result.fold(
      (error) {
        _historyError = error;
        _setLoadingHistory(false);
        return false;
      },
      (response) {
        _transactionHistory = response;

        // If it's the first page or refresh, replace all transactions
        if (page == 1 || refresh) {
          _allTransactions = response.data.data;
        } else {
          // Otherwise, append to existing transactions
          _allTransactions.addAll(response.data.data);
        }

        _setLoadingHistory(false);
        return true;
      },
    );
  }

  // Get transaction detail method
  Future<bool> getTransactionDetail(int transactionId) async {
    _setLoadingDetail(true);
    _detailError = null;

    final Either<String, DetailTransactionResponseModel> result =
        await _remoteDatasource.getTransactionDetail(transactionId);

    return result.fold(
      (error) {
        _detailError = error;
        _setLoadingDetail(false);
        return false;
      },
      (response) {
        _transactionDetail = response;
        _setLoadingDetail(false);
        return true;
      },
    );
  }

  // Load more transactions (pagination)
  Future<bool> loadMoreTransactions({
    String? startDate,
    String? endDate,
  }) async {
    if (_transactionHistory?.data.hasMore == false || _isLoadingHistory) {
      return false;
    }

    final nextPage = (_transactionHistory?.data.currentPage ?? 0) + 1;
    return await getTransactionHistory(
      startDate: startDate,
      endDate: endDate,
      page: nextPage,
    );
  }

  // Set loading state for transaction
  void _setProcessingTransaction(bool value) {
    _isProcessingTransaction = value;
    notifyListeners();
  }

  // Set loading state for history
  void _setLoadingHistory(bool value) {
    _isLoadingHistory = value;
    notifyListeners();
  }

  // Set loading state for detail
  void _setLoadingDetail(bool value) {
    _isLoadingDetail = value;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _transactionError = null;
    _historyError = null;
    _detailError = null;
    notifyListeners();
  }

  // Clear last transaction
  void clearLastTransaction() {
    _lastTransaction = null;
    notifyListeners();
  }

  // Clear transaction history
  void clearTransactionHistory() {
    _allTransactions = [];
    _transactionHistory = null;
    _historyError = null;
    notifyListeners();
  }

  // Clear transaction detail
  void clearTransactionDetail() {
    _transactionDetail = null;
    _detailError = null;
    notifyListeners();
  }
}
