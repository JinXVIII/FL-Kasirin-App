import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

import '../../../data/models/product_model.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/themes/text_styles.dart';
import '../../../cores/routes/app_router.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'widgets/product_card.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Add listener to search controller
    _searchController.addListener(() {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).filterProducts(_searchController.text);
    });

    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kasir", style: AppTextStyles.titlePage),
        centerTitle: true,
      ),
      backgroundColor: AppColors.body,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomTextField(
              controller: _searchController,
              label: "Cari Produk...",
              showLabel: false,
              suffixIcon: const Icon(Icons.search),
            ),
          ),

          // Product count
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Menampilkan ${provider.filteredProducts.length} produk',
                    textAlign: TextAlign.left,
                    style: AppTextStyles.caption,
                  ),
                ),
              );
            },
          ),

          // Products grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer2<ProductProvider, CartProvider>(
                builder: (context, productProvider, cartProvider, child) {
                  // State: Loading
                  if (productProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // State: Error
                  if (productProvider.error != null) {
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
                            productProvider.error!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              productProvider.refresh();
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // State: Empty
                  if (productProvider.filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            productProvider.products.isEmpty
                                ? 'Belum ada produk'
                                : 'Tidak ada produk ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // State: Success
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: productProvider.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final ProductModel product =
                          productProvider.filteredProducts[index];

                      return ProductCard(
                        product: product,
                        quantity: cartProvider.getProductQuantity(product.id),
                        onAddToCart: () {
                          cartProvider.addToCart(product);
                        },
                        onIncreaseQuantity: () {
                          cartProvider.increaseQuantity(product.id);
                        },
                        onDecreaseQuantity: () {
                          cartProvider.decreaseQuantity(product.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Cart section
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total', style: AppTextStyles.caption),
                        Text(
                          'Rp ${cartProvider.totalPrice.toString()}',
                          style: AppTextStyles.heading4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Checkout button
                    CustomButton.filled(
                      height: 40,
                      width: 150,
                      borderRadius: 6,
                      onPressed: () {
                        if (cartProvider.cartItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Keranjang belanja masih kosong'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        context.pushNamed(RouteConstants.checkout);
                      },
                      label: "Checkout (${cartProvider.totalItems})",
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
