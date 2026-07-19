// lib/views/savedAddresses.dart
import 'package:flutter/material.dart';
import 'package:minicatalog/models/addressModel.dart';
import 'package:minicatalog/services/localStorageService.dart';

class savedAddresses extends StatefulWidget {
  const savedAddresses({super.key});

  @override
  State<savedAddresses> createState() => _savedAddressesState();
}

class _savedAddressesState extends State<savedAddresses> {
  final LocalStorageService localStorageService = LocalStorageService();

  List<addressModel> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final loaded = await localStorageService.getAddresses();
    setState(() {
      addresses = loaded;
      isLoading = false;
    });
  }

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final provinceController = TextEditingController();
  final districtController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final openAddressController = TextEditingController();

  int? editingIndex; // null ise yeni ekleme, dolu ise düzenleme

  void _showAddAddressSheet({int? index}) {
    editingIndex = index;

    if (index != null) {
      // Mevcut adresin bilgilerini forma doldur
      final existing = addresses[index];
      titleController.text = existing.title;
      provinceController.text = existing.province;
      districtController.text = existing.district;
      neighborhoodController.text = existing.neighborhood;
      openAddressController.text = existing.openAddress;
    } else {
      // Yeni ekleme, formu temizle
      titleController.clear();
      provinceController.clear();
      districtController.clear();
      neighborhoodController.clear();
      openAddressController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAF3EA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  editingIndex != null ? "Adresi düzenle" : "Yeni adres ekle",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B4226),
                  ),
                ),
                const SizedBox(height: 16),

                // Adres başlığı
                TextFormField(
                  controller: titleController,
                  decoration: _inputDecoration("Adres başlığı (Ev, İş vb.)"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen adres başlığı gir';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // İl / İlçe yan yana
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: provinceController,
                        decoration: _inputDecoration("İl"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'İl gir';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: districtController,
                        decoration: _inputDecoration("İlçe"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'İlçe gir';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Mahalle
                TextFormField(
                  controller: neighborhoodController,
                  decoration: _inputDecoration("Mahalle"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mahalle gir';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Açık adres
                TextFormField(
                  controller: openAddressController,
                  maxLines: 3,
                  decoration: _inputDecoration("Açık adres (sokak, no, daire vb.)"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Açık adres gir';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4226),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newAddress = addressModel(
                        title: titleController.text.trim(),
                        province: provinceController.text.trim(),
                        district: districtController.text.trim(),
                        neighborhood: neighborhoodController.text.trim(),
                        openAddress: openAddressController.text.trim(),
                      );

                      setState(() {
                        if (editingIndex != null) {
                          addresses[editingIndex!] = newAddress;
                        } else {
                          addresses.add(newAddress);
                        }
                      });

                      localStorageService.saveAddresses(addresses);

                      titleController.clear();
                      provinceController.clear();
                      districtController.clear();
                      neighborhoodController.clear();
                      openAddressController.clear();
                      editingIndex = null;
                      Navigator.pop(context);
                    }
                  },
                  child: Text(editingIndex != null ? "Güncelle" : "Adresi kaydet"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _deleteAddress(int index) {
    setState(() {
      addresses.removeAt(index);
    });
    localStorageService.saveAddresses(addresses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA),
      appBar: AppBar(
        title: const Text("Kayıtlı Adreslerim"),
        backgroundColor: const Color(0xFFFAF3EA),
        foregroundColor: const Color(0xFF6B4226),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${addresses.length} adres kayıtlı",
                style: const TextStyle(fontSize: 13, color: Color(0xFF9C6B4F)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6B4226)))
                    : addresses.isEmpty
                        ? const Center(
                            child: Text(
                              "Henüz kayıtlı adresin yok",
                              style: TextStyle(color: Color(0xFF9C6B4F)),
                            ),
                          )
                        : ListView.separated(
                            itemCount: addresses.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              return Dismissible(
                                key: ValueKey(address.title + index.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => _deleteAddress(index),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.delete_outline, color: Colors.red),
                                ),
                                child: GestureDetector(
                                  onTap: () => _showAddAddressSheet(index: index),
                                  child: _buildAddressCard(address),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6B4226),
        onPressed: () => _showAddAddressSheet(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAddressCard(addressModel address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8DCCB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Color(0xFF6B4226)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E2C20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.summary,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF9C6B4F)),
                ),
                const SizedBox(height: 2),
                Text(
                  address.openAddress,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9C6B4F)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFB08968)),
        ],
      ),
    );
  }
}