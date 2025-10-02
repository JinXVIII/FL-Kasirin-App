import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../cores/themes/text_styles.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/image_picker_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceBuyController = TextEditingController();
  final _priceSellController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = ['Makanan', 'Minuman', 'Snack', 'Lainnya'];

  @override
  void dispose() {
    _nameController.dispose();
    _priceBuyController.dispose();
    _priceSellController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save product functionality
      // For now, just show a success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk", style: AppTextStyles.titlePage),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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

              // Save button
              CustomButton.filled(
                onPressed: _saveProduct,
                label: "Simpan Produk",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
