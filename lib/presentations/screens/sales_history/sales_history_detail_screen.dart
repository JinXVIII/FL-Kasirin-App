import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../cores/themes/text_styles.dart';

import '../../providers/transaction_provider.dart';

class SalesHistoryDetailScreen extends StatefulWidget {
  final int transactionId;

  const SalesHistoryDetailScreen({super.key, required this.transactionId});

  @override
  State<SalesHistoryDetailScreen> createState() =>
      _SalesHistoryDetailScreenState();
}

class _SalesHistoryDetailScreenState extends State<SalesHistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load transaction detail when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).getTransactionDetail(widget.transactionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Penjualan",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),

                  Text('Terjadi kesalahan', style: AppTextStyles.heading4),
                  const SizedBox(height: 8),

                  Text(
                    provider.detailError!,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      provider.getTransactionDetail(widget.transactionId);
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final transaction = provider.transactionDetail?.data;

          if (transaction == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.getTransactionDetail(widget.transactionId);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction info card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Transaction number and date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  transaction.invoiceNumber,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'dd MMM yyyy, HH:mm',
                                ).format(transaction.createdAt),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Buyer info (if available)
                          if (transaction.buyer != null &&
                              transaction.buyer!.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Pembeli: ${transaction.buyer}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Payment method
                          Row(
                            children: [
                              const Icon(
                                Icons.payment,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Metode Pembayaran: ${transaction.paymentMethod}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Divider
                          const Divider(),

                          // Total amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Pembayaran:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Rp ${NumberFormat('#,###').format(transaction.totalPrice)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),

                          // Payment details
                          if (transaction.paidAmount !=
                              transaction.totalPrice) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Dibayar:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  'Rp ${NumberFormat('#,###').format(transaction.paidAmount)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                            if (transaction.changeAmount > 0) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Kembali:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Rp ${NumberFormat('#,###').format(transaction.changeAmount)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.orange[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Items section
                  const Text(
                    'Item yang Dibeli',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  // Items list
                  if (transaction.details != null &&
                      transaction.details!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transaction.details!.length,
                      itemBuilder: (context, index) {
                        final detail = transaction.details![index];
                        final productName = detail.product.name;
                        final quantity = detail.quantity;
                        final price = detail.price;
                        final subtotal = detail.subtotal;

                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product name
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Quantity and price
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$quantity item x Rp ${NumberFormat('#,###').format(price)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),

                                    Text(
                                      'Rp ${NumberFormat('#,###').format(subtotal)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Tidak ada detail item'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
