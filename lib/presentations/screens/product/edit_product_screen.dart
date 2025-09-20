import 'package:fe_kasirin_app/presentations/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/image_picker_widget.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceBuyController = TextEditingController();
  final _priceSellController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedCategory = 'Makanan';
  final List<String> _categories = ['Makanan', 'Minuman', 'Snack', 'Lainnya'];

  bool _isLoading = true;
  Map<String, dynamic>? _product;

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceBuyController.dispose();
    _priceSellController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Simulate loading product data by ID
  void _loadProductData() {
    // TODO: Replace with actual API call to fetch product by ID
    // For now, using sample data based on the product ID
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        // Sample product data - in a real app, this would come from an API
        final sampleProducts = [
          {
            'id': '1',
            'name': 'Kopi Hitam',
            'priceBuy': '15000',
            'priceSell': '18000',
            'stock': '50',
            'category': 'Minuman',
            'imageUrl':
                'https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
          {
            'id': '2',
            'name': 'Teh Manis',
            'priceBuy': '10000',
            'priceSell': '12000',
            'stock': '30',
            'category': 'Minuman',
          },
          {
            'id': '3',
            'name': 'Nasi Goreng',
            'priceBuy': '25000',
            'priceSell': '30000',
            'stock': '20',
            'category': 'Makanan',
          },
          {
            'id': '4',
            'name': 'Mie Ayam',
            'priceBuy': '20000',
            'priceSell': '25000',
            'stock': '15',
            'category': 'Makanan',
            'imageUrl':
                'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
          {
            'id': '5',
            'name': 'Es Jeruk',
            'priceBuy': '12000',
            'priceSell': '15000',
            'stock': '25',
            'category': 'Minuman',
          },
          {
            'id': '6',
            'name': 'Ayam Goreng',
            'priceBuy': '22000',
            'priceSell': '25000',
            'stock': '18',
            'category': 'Makanan',
            'imageUrl':
                'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          },
        ];

        _product = sampleProducts.firstWhere(
          (product) => product['id'] == widget.productId,
          orElse: () => sampleProducts[0],
        );

        // Fill form fields with product data
        _nameController.text = _product!['name'];
        _priceBuyController.text = _product!['priceBuy'];
        _priceSellController.text = _product!['priceSell'];
        _stockController.text = _product!['stock'];
        _selectedCategory = _product!['category'];

        if (_product!['imageUrl'] != null) {
          _imageUrlController.text = _product!['imageUrl'];
        }

        _isLoading = false;
      });
    });
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement update product functionality
      // For now, just show a success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );

      // Go back to product screen by removing this screen from the navigation stack
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Produk",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    ImagePickerWidget(
                      label: "Gambar Produk",
                      onChanged: (XFile? value) {
                        if (value != null) {
                          _imageUrlController.text = value.path;
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Product name
                    CustomTextField(
                      controller: _nameController,
                      label: "Nama Produk",
                    ),
                    const SizedBox(height: 16.0),

                    // Product category
                    CustomDropdown(
                      value: _selectedCategory,
                      items: _categories,
                      label: "Kategori",
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Product price
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _priceBuyController,
                            label: "Harga Beli",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: CustomTextField(
                            controller: _priceSellController,
                            label: "Harga Jual",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Product stock
                    CustomTextField(
                      controller: _stockController,
                      label: "Stok",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24.0),

                    // Update button
                    CustomButton.filled(
                      onPressed: _updateProduct,
                      label: "Perbarui Produk",
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
