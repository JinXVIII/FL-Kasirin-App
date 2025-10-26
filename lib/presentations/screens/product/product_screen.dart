import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/routes/app_router.dart';
import '../../../cores/themes/text_styles.dart';

import '../../../data/models/product_model.dart';

import '../../providers/product_provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/status_dialog.dart';
import 'widgets/product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

    // Add listener to search controller
    controller.addListener(() {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).filterProducts(controller.text);
    });

    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Produk", style: AppTextStyles.titlePage),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(RouteConstants.addProduct);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Produk',
          ),
        ],
      ),
      backgroundColor: AppColors.body,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            CustomTextField(
              controller: controller,
              label: "Cari Produk...",
              showLabel: false,
              suffixIcon: const Icon(Icons.search),
            ),
            const SizedBox(height: 6),

            // Product count
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return Text(
                  'Menampilkan ${provider.filteredProducts.length} produk',
                  style: AppTextStyles.caption,
                );
              },
            ),
            const SizedBox(height: 8),

            // Product list
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  // State: Loading
                  if (provider.isLoading) {
                    return Center(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Lottie.asset(
                          'assets/animations/loading.json',
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }

                  // State: Error
                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Terjadi kesalahan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.error!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              provider.refresh();
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // State: Empty
                  if (provider.filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Lottie Animation
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Lottie.asset(
                              'assets/animations/empty.json',
                              repeat: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            provider.products.isEmpty
                                ? 'Belum ada produk'
                                : 'Tidak ada produk ditemukan',
                            style: AppTextStyles.caption,
                          ),
                          if (provider.products.isEmpty) ...[
                            const SizedBox(height: 16),
                            CustomButton.filled(
                              onPressed: () {
                                context.pushNamed(RouteConstants.addProduct);
                              },
                              width: 250,
                              label: "Tambah Produk",
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  // State: Success
                  return ListView.builder(
                    itemCount: provider.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final ProductModel product =
                          provider.filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onEdit: () {
                          context.pushNamed(
                            RouteConstants.editProduct,
                            pathParameters: {'id': product.id.toString()},
                          );
                        },
                        onDelete: () {
                          _showDeleteConfirmation(context, product);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProductModel product) {
    final parentContext = context;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: Text(
            'Apakah Anda yakin ingin menghapus produk "${product.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Batal'),
            ),
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return TextButton(
                  onPressed: provider.isDeletingProduct
                      ? null
                      : () async {
                          Navigator.of(dialogContext).pop();

                          // Call delete function from provider
                          final success = await provider.deleteProduct(
                            product.id,
                          );

                          if (success && parentContext.mounted) {
                            StatusDialogs.showSuccess(
                              parentContext,
                              title: 'Berhasil!',
                              message: 'Produk berhasil dihapus',
                              onOkPressed: () {
                                provider.getAllProducts();
                              },
                            );
                          } else if (!success && parentContext.mounted) {
                            StatusDialogs.showFailed(
                              parentContext,
                              title: 'Gagal!',
                              message:
                                  provider.deleteProductError ??
                                  'Gagal menghapus produk',
                            );
                          }
                        },
                  child: provider.isDeletingProduct
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      : const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.red),
                        ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
