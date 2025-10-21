import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../../presentations/providers/transaction_provider.dart';

class FinancialInformationCard extends StatefulWidget {
  const FinancialInformationCard({super.key});

  @override
  State<FinancialInformationCard> createState() =>
      _FinancialInformationCardState();
}

class _FinancialInformationCardState extends State<FinancialInformationCard> {
  @override
  void initState() {
    super.initState();
    // Load information sale data when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().getInformationSale();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Warung Madura United", style: AppTextStyles.whiteHeading3),
              const SizedBox(height: 4),

              Divider(thickness: 0.5, color: Colors.white),
              const SizedBox(height: 4),

              // Revenue data
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Omzet Hari Ini",
                            style: AppTextStyles.whiteBodySmall,
                          ),
                          if (transactionProvider.isLoadingInformationSale)
                            ValueLoadingShimmer()
                          else
                            Text(
                              transactionProvider
                                          .informationSaleData
                                          ?.data
                                          .today
                                          .revenue !=
                                      null
                                  ? "Rp ${_formatCurrency(transactionProvider.informationSaleData!.data.today.revenue)}"
                                  : "Rp 0",
                              style: AppTextStyles.whiteHeading4,
                            ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Omzet Bulan Ini",
                            style: AppTextStyles.whiteBodySmall,
                          ),
                          if (transactionProvider.isLoadingInformationSale)
                            ValueLoadingShimmer()
                          else
                            Text(
                              transactionProvider
                                          .informationSaleData
                                          ?.data
                                          .month
                                          .revenue !=
                                      null
                                  ? "Rp ${_formatCurrency(transactionProvider.informationSaleData!.data.month.revenue)}"
                                  : "Rp 0",
                              style: AppTextStyles.whiteHeading4,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Transaction count data
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaksi Hari Ini",
                            style: AppTextStyles.whiteBodySmall,
                          ),
                          if (transactionProvider.isLoadingInformationSale)
                            ValueLoadingShimmer()
                          else
                            Text(
                              transactionProvider
                                      .informationSaleData
                                      ?.data
                                      .today
                                      .transactions
                                      .toString() ??
                                  "0",
                              style: AppTextStyles.whiteHeading4,
                            ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaksi Bulan Ini",
                            style: AppTextStyles.whiteBodySmall,
                          ),
                          if (transactionProvider.isLoadingInformationSale)
                            ValueLoadingShimmer()
                          else
                            Text(
                              transactionProvider
                                      .informationSaleData
                                      ?.data
                                      .month
                                      .transactions
                                      .toString() ??
                                  "0",
                              style: AppTextStyles.whiteHeading4,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCurrency(String amount) {
    // Remove any non-digit characters
    final cleanAmount = amount.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanAmount.isEmpty) return '0';

    // Parse as integer
    final value = int.parse(cleanAmount);

    // Format with thousand separators
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}

class ValueLoadingShimmer extends StatelessWidget {
  const ValueLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(seconds: 1),
      color: Colors.white.withAlpha(10),
      colorOpacity: 0.3,
      enabled: true,
      direction: ShimmerDirection.fromLTRB(),
      child: Container(
        height: 20,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
