import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/themes/text_styles.dart';

import '../../providers/transaction_provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'widgets/sales_history_item_card.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();

    // Set default dates to current month
    _setDefaultDates();

    // Setup scroll controller for pagination
    _scrollController.addListener(_scrollListener);

    // Load initial data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactionHistory(refresh: true);
    });
  }

  void _setDefaultDates() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    _startDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(firstDayOfMonth);
    _endDateController.text = DateFormat('yyyy-MM-dd').format(now);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreTransactions();
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactionHistory({bool refresh = false}) async {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );

    final success = await transactionProvider.getTransactionHistory(
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      page: 1,
      refresh: refresh,
    );

    if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            transactionProvider.historyError ??
                'Gagal memuat riwayat transaksi',
          ),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  Future<void> _loadMoreTransactions() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );

    await transactionProvider.loadMoreTransactions(
      startDate: _startDateController.text,
      endDate: _endDateController.text,
    );

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontFamily: 'Poppins'),
              bodyMedium: TextStyle(fontFamily: 'Poppins'),
              labelLarge: TextStyle(fontFamily: 'Poppins'),
              labelSmall: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontFamily: 'Poppins'),
              bodyMedium: TextStyle(fontFamily: 'Poppins'),
              labelLarge: TextStyle(fontFamily: 'Poppins'),
              labelSmall: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _applyFilters() {
    _loadTransactionHistory(refresh: true);

    // Show snackbar with filter info
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Filter diterapkan: ${_startDateController.text} hingga ${_endDateController.text}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _refresh() async {
    await _loadTransactionHistory(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Penjualan", style: AppTextStyles.titlePage),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Start date filter
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _startDateController,
                            label: "Tanggal Awal",
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // End date filter
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectEndDate(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _endDateController,
                            label: "Tanggal Akhir",
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Apply filter button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.filled(
                    onPressed: _applyFilters,
                    label: "Terapkan Filter",
                  ),
                ),
              ],
            ),
          ),

          // Sales history list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Penjualan',
                        style: AppTextStyles.heading4,
                      ),
                      Consumer<TransactionProvider>(
                        builder: (context, provider, child) {
                          return Text(
                            '${provider.allTransactions.length} transaksi',
                            style: AppTextStyles.caption,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Sales history list
                  Expanded(
                    child: Consumer<TransactionProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoadingHistory &&
                            provider.allTransactions.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (provider.historyError != null &&
                            provider.allTransactions.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Terjadi kesalahan',
                                  style: AppTextStyles.heading4,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  provider.historyError!,
                                  style: AppTextStyles.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                CustomButton.filled(
                                  onPressed: _refresh,
                                  label: "Coba Lagi",
                                ),
                              ],
                            ),
                          );
                        }

                        if (provider.allTransactions.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Tidak ada data penjualan',
                                  style: AppTextStyles.heading4,
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                provider.allTransactions.length +
                                (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              // Show loading indicator at the bottom
                              if (index == provider.allTransactions.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final transaction =
                                  provider.allTransactions[index];
                              return SalesHistoryItemCard(
                                transaction: transaction,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
