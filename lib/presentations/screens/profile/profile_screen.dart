import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/themes/text_styles.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedBusinessCategory;
  String? _selectedBusinessType;
  bool _isLoading = false;

  // Business categories and their types
  final Map<String, List<String>> _businessCategories = {
    'Makanan & Minuman': [
      'Restoran',
      'Kafe',
      'Warung Makan',
      'Kedai Kopi',
      'Jus & Smoothie',
      'Bakery & Kue',
      'Catering',
      'Food Truck',
    ],
    'Retail': [
      'Minimarket',
      'Toko Kelontong',
      'Fashion & Aksesoris',
      'Elektronik',
      'Toko Buku',
      'Toko Mainan',
      'Toko Olahraga',
      'Toko Kosmetik',
    ],
    'Jasa': [
      'Salon & Kecantikan',
      'Bengkel',
      'Laundry',
      'Kursus & Bimbingan',
      'Fotografi',
      'Event Organizer',
      'Tour & Travel',
      'Jasa Konsultasi',
    ],
    'Kesehatan': [
      'Apotek',
      'Klinik',
      'Toko Alat Kesehatan',
      'Herbal & Suplemen',
      'Praktik Dokter',
      'Fisioterapi',
      'Klinik Gigi',
      'Optik',
    ],
    'Lainnya': [
      'Toko By-By',
      'Toko Pertanian',
      'Toko Peternakan',
      'Distributor',
      'Pabrik',
      'Lainnya',
    ],
  };

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    // Manual validation since CustomTextField doesn't have validator
    if (_businessNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama usaha harus diisi'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_selectedBusinessCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori usaha harus dipilih'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_selectedBusinessType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jenis usaha harus dipilih'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alamat usaha harus diisi'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    _saveProfile();
  }

  void _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate saving profile
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil toko berhasil disimpan!'),
          backgroundColor: AppColors.green,
        ),
      );

      // Mark profile as completed
      // This would typically save to a database or local storage
      // For now, we'll just navigate back to dashboard
      context.pushReplacement('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,
      appBar: AppBar(
        backgroundColor: AppColors.body,
        elevation: 0,
        title: Text('Lengkapi Profil Toko', style: AppTextStyles.titlePage),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Business name field
                CustomTextField(
                  controller: _businessNameController,
                  label: 'Nama Usaha',
                ),
                const SizedBox(height: 20),

                // Business category dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kategori Usaha', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(
                            'Pilih Kategori Usaha',
                            style: AppTextStyles.caption.copyWith(fontSize: 14),
                          ),
                          value: _selectedBusinessCategory,
                          isExpanded: true,
                          items: _businessCategories.keys.map((
                            String category,
                          ) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category,
                                style: AppTextStyles.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedBusinessCategory = newValue;
                              _selectedBusinessType =
                                  null; // Reset business type when category changes
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Business type dropdown (always visible, but disabled when no category selected)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jenis Usaha', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedBusinessCategory == null
                              ? AppColors.disabled
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedBusinessCategory == null
                            ? AppColors.disabled.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(
                            'Pilih Jenis Usaha',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 14,
                              color: _selectedBusinessCategory == null
                                  ? AppColors.disabled
                                  : Colors.grey,
                            ),
                          ),
                          value: _selectedBusinessType,
                          isExpanded: true,
                          items: _selectedBusinessCategory != null
                              ? _businessCategories[_selectedBusinessCategory]!
                                    .map((String type) {
                                      return DropdownMenuItem<String>(
                                        value: type,
                                        child: Text(
                                          type,
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      );
                                    })
                                    .toList()
                              : [],
                          onChanged: _selectedBusinessCategory != null
                              ? (String? newValue) {
                                  setState(() {
                                    _selectedBusinessType = newValue;
                                  });
                                }
                              : null, // Disable dropdown when no category is selected
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Address field with multiline support
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alamat Usaha', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Masukkan alamat usaha',
                        hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Phone field (optional)
                CustomTextField(
                  controller: _phoneController,
                  label: 'No Handphone (Opsional)',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 40),

                // Save button
                CustomButton.filled(
                  onPressed: _isLoading ? () {} : _validateAndSave,
                  label: _isLoading ? 'Menyimpan...' : 'Simpan Profil',
                  disabled: _isLoading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
