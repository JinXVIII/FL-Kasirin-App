import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  // Dummy data for sales history
  List<Map<String, dynamic>> _allSalesData = [];
  List<Map<String, dynamic>> _filteredSalesData = [];

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();

    // Set default dates to current month
    _setDefaultDates();

    // Generate dummy data
    _generateDummyData();

    // Apply initial filter after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilters();
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

  void _generateDummyData() {
    _allSalesData = [
      {
        'id': 1,
        'transactionNumber': 'TRX-20250901-001',
        'transactionDate': DateTime(2025, 9, 1, 10, 30),
        'totalAmount': 45000,
        'paymentMethod': 'Tunai',
        'items': [
          {'productName': 'Kopi Hitam', 'quantity': 2, 'price': 15000},
          {'productName': 'Teh Manis', 'quantity': 1, 'price': 10000},
          {'productName': 'Nasi Goreng', 'quantity': 1, 'price': 25000},
        ],
      },
      {
        'id': 2,
        'transactionNumber': 'TRX-20250902-001',
        'transactionDate': DateTime(2025, 9, 2, 14, 15),
        'totalAmount': 32000,
        'paymentMethod': 'E-Wallet',
        'items': [
          {'productName': 'Mie Ayam', 'quantity': 1, 'price': 20000},
          {'productName': 'Es Jeruk', 'quantity': 1, 'price': 12000},
        ],
      },
      {
        'id': 3,
        'transactionNumber': 'TRX-20250905-001',
        'transactionDate': DateTime(2025, 9, 5, 9, 45),
        'totalAmount': 67000,
        'paymentMethod': 'Kartu Kredit',
        'items': [
          {'productName': 'Ayam Goreng', 'quantity': 2, 'price': 22000},
          {'productName': 'Kopi Hitam', 'quantity': 1, 'price': 15000},
          {'productName': 'Teh Manis', 'quantity': 2, 'price': 10000},
        ],
      },
      {
        'id': 4,
        'transactionNumber': 'TRX-20250910-001',
        'transactionDate': DateTime(2025, 9, 10, 12, 20),
        'totalAmount': 25000,
        'paymentMethod': 'Tunai',
        'items': [
          {'productName': 'Nasi Goreng', 'quantity': 1, 'price': 25000},
        ],
      },
      {
        'id': 5,
        'transactionNumber': 'TRX-20250915-001',
        'transactionDate': DateTime(2025, 9, 15, 16, 30),
        'totalAmount': 54000,
        'paymentMethod': 'Transfer Bank',
        'items': [
          {'productName': 'Mie Ayam', 'quantity': 2, 'price': 20000},
          {'productName': 'Es Jeruk', 'quantity': 1, 'price': 12000},
          {'productName': 'Kopi Hitam', 'quantity': 1, 'price': 15000},
        ],
      },
      {
        'id': 6,
        'transactionNumber': 'TRX-20230920-001',
        'transactionDate': DateTime(2025, 9, 20, 11, 10),
        'totalAmount': 37000,
        'paymentMethod': 'Tunai',
        'items': [
          {'productName': 'Ayam Goreng', 'quantity': 1, 'price': 22000},
          {'productName': 'Teh Manis', 'quantity': 1, 'price': 10000},
          {'productName': 'Es Jeruk', 'quantity': 1, 'price': 12000},
        ],
      },
      {
        'id': 7,
        'transactionNumber': 'TRX-20230921-001',
        'transactionDate': DateTime.now(),
        'totalAmount': 42000,
        'paymentMethod': 'E-Wallet',
        'items': [
          {'productName': 'Nasi Goreng', 'quantity': 1, 'price': 25000},
          {'productName': 'Kopi Hitam', 'quantity': 1, 'price': 15000},
        ],
      },
    ];
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
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
    );

    if (picked != null) {
      setState(() {
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _applyFilters() {
    final startDate = DateFormat('yyyy-MM-dd').parse(_startDateController.text);
    final endDate = DateFormat('yyyy-MM-dd').parse(_endDateController.text);

    setState(() {
      _filteredSalesData = _allSalesData.where((sales) {
        final transactionDate = sales['transactionDate'] as DateTime;
        return transactionDate.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ) &&
            transactionDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    });

    // Show snackbar with filter info
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Filter diterapkan: ${_startDateController.text} hingga ${_endDateController.text}. Ditemukan ${_filteredSalesData.length} transaksi.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riwayat Penjualan",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_filteredSalesData.length} transaksi',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sales history list
                  _filteredSalesData.isEmpty
                      ? const Center(
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
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _filteredSalesData.length,
                            itemBuilder: (context, index) {
                              final salesData = _filteredSalesData[index];
                              return SalesHistoryItemCard(salesData: salesData);
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
