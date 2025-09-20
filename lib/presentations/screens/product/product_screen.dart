import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/routes/app_router.dart';
import '../../widgets/custom_text_field.dart';
import 'widgets/product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late TextEditingController controller;
  List<Map<String, dynamic>> filteredProducts = [];
  String searchQuery = '';

  // Sample product data
  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'Kopi Hitam',
      'price': 15000,
      'stock': 50,
      'category': 'Minuman',
      'imageUrl':
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    },
    {
      'id': 2,
      'name': 'Teh Manis',
      'price': 10000,
      'stock': 30,
      'category': 'Minuman',
    },
    {
      'id': 3,
      'name': 'Nasi Goreng',
      'price': 25000,
      'stock': 20,
      'category': 'Makanan',
      // No imageUrl - will show food icon
    },
    {
      'id': 4,
      'name': 'Mie Ayam',
      'price': 20000,
      'stock': 15,
      'category': 'Makanan',
      'imageUrl':
          'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    },
    {
      'id': 5,
      'name': 'Es Jeruk',
      'price': 12000,
      'stock': 25,
      'category': 'Minuman',
      // No imageUrl - will show food icon
    },
    {
      'id': 6,
      'name': 'Ayam Goreng',
      'price': 22000,
      'stock': 18,
      'category': 'Makanan',
      'imageUrl':
          'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    filteredProducts = List.from(products);

    // Add listener to search controller
    controller.addListener(() {
      setState(() {
        searchQuery = controller.text.toLowerCase();
        _filterProducts();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _filterProducts() {
    if (searchQuery.isEmpty) {
      setState(() {
        filteredProducts = List.from(products);
      });
    } else {
      setState(() {
        filteredProducts = products.where((product) {
          return product['name'].toLowerCase().contains(searchQuery) ||
              product['category'].toLowerCase().contains(searchQuery);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Produk",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
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
            const SizedBox(height: 16),

            // Product count
            Text(
              'Menampilkan ${filteredProducts.length} produk',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Product list
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
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
                            'Tidak ada produk ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onEdit: () {
                            // TODO: Implement edit product functionality
                          },
                          onDelete: () {
                            // TODO: Implement delete product functionality
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
}
