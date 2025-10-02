import 'package:flutter/material.dart';

import '../../../../cores/constants/colors.dart';
import '../../../../cores/themes/text_styles.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class PaymentAlertDialog extends StatefulWidget {
  final int totalPrice;
  final Function() onPaymentSuccess;

  const PaymentAlertDialog({
    super.key,
    required this.totalPrice,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentAlertDialog> createState() => _PaymentAlertDialogState();
}

class _PaymentAlertDialogState extends State<PaymentAlertDialog> {
  final TextEditingController _paymentController = TextEditingController();
  String _selectedPaymentMethod = 'Tunai';
  final List<String> _paymentMethods = [
    'Tunai',
    'Kartu Kredit',
    'E-Wallet',
    'Transfer Bank',
  ];

  int _changeAmount = 0;
  List<int> _quickAmounts = [];
  int? _selectedAmount;

  @override
  void initState() {
    super.initState();
    _paymentController.text = widget.totalPrice.toString();
    _calculateQuickAmounts();
    _setInitialSelectedAmount();
    _calculateChange();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  void _calculateQuickAmounts() {
    // Calculate appropriate quick amounts based on total price
    _quickAmounts = [];

    // Always add exact amount
    _quickAmounts.add(widget.totalPrice);

    // Add amounts that are higher than the total price
    if (widget.totalPrice < 20000) {
      _quickAmounts.add(20000);
    }
    if (widget.totalPrice < 50000) {
      _quickAmounts.add(50000);
    }
    if (widget.totalPrice < 100000) {
      _quickAmounts.add(100000);
    }

    // Remove duplicates and sort
    _quickAmounts = _quickAmounts.toSet().toList();
    _quickAmounts.sort();
  }

  void _setInitialSelectedAmount() {
    _selectedAmount = widget.totalPrice;
  }

  void _calculateChange() {
    final paymentAmount = int.tryParse(_paymentController.text) ?? 0;
    setState(() {
      _changeAmount = paymentAmount - widget.totalPrice;

      // Update selected amount based on the payment amount
      if (_quickAmounts.contains(paymentAmount)) {
        _selectedAmount = paymentAmount;
      } else {
        _selectedAmount = null;
      }
    });
  }

  void _setPaymentAmount(int amount) {
    setState(() {
      _paymentController.text = amount.toString();
      _selectedAmount = amount;
      _calculateChange();
    });
  }

  void _processPayment(BuildContext context) {
    final paymentAmount = int.tryParse(_paymentController.text) ?? 0;

    if (paymentAmount < widget.totalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah pembayaran kurang dari total pembayaran'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context);
    widget.onPaymentSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final isCashPayment = _selectedPaymentMethod == 'Tunai';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pembayaran', style: AppTextStyles.heading3),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total payment
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 8),

                        Center(
                          child: Text(
                            'Rp ${widget.totalPrice.toString()}',
                            style: AppTextStyles.heading1.copyWith(
                              color: AppColors.primary,
                              fontSize: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Payment method
                    CustomDropdown(
                      value: _selectedPaymentMethod,
                      items: _paymentMethods,
                      label: 'Metode Pembayaran',
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPaymentMethod = value;
                            // Reset change amount when payment method changes
                            if (!isCashPayment) {
                              _changeAmount = 0;
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Payment amount input - only show for cash payment
                    if (isCashPayment) ...[
                      CustomTextField(
                        controller: _paymentController,
                        label: 'Uang Bayar',
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _calculateChange();
                        },
                      ),
                      const SizedBox(height: 8),

                      // Change amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Kembalian', style: AppTextStyles.bodyMedium),
                          Text(
                            'Rp ${_changeAmount.toString()}',
                            style: AppTextStyles.priceSmall.copyWith(
                              color: _changeAmount >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Quick amount buttons - only show for cash payment
                      const Text(
                        'Pilihan Jumlah Bayar',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 8),

                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 3.5,
                        children: [
                          CustomButton.filled(
                            onPressed: () =>
                                _setPaymentAmount(widget.totalPrice),
                            label: 'Uang Pas',
                            color: _selectedAmount == widget.totalPrice
                                ? AppColors.primary
                                : Colors.grey[300]!,
                            textColor: _selectedAmount == widget.totalPrice
                                ? Colors.white
                                : Colors.black,
                          ),
                          ..._quickAmounts
                              .where((amount) => amount > widget.totalPrice)
                              .map((amount) {
                                return CustomButton.filled(
                                  onPressed: () => _setPaymentAmount(amount),
                                  label: 'Rp ${amount.toString()}',
                                  color: _selectedAmount == amount
                                      ? AppColors.primary
                                      : Colors.grey[300]!,
                                  textColor: _selectedAmount == amount
                                      ? Colors.white
                                      : Colors.black,
                                );
                              }),
                        ],
                      ),
                    ] else ...[
                      // Non-cash payment message
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pembayaran dengan $_selectedPaymentMethod',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tidak ada kembalian untuk metode pembayaran ini',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton.filled(
                onPressed: () => _processPayment(context),
                label: "Bayar",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
