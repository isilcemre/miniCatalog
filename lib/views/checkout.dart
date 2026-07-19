import 'package:flutter/material.dart';
import 'package:minicatalog/models/orderModel.dart';
import 'package:minicatalog/models/productModel.dart';
import 'package:minicatalog/models/addressModel.dart';
import 'package:minicatalog/models/creditCardModel.dart';
import 'package:minicatalog/services/localStorageService.dart';
import 'package:minicatalog/views/orderConfirmation.dart';

class checkout extends StatefulWidget {
  final List<Data> cartProducts;

  const checkout({super.key, required this.cartProducts});

  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  final LocalStorageService localStorageService = LocalStorageService();

  List<addressModel> addresses = [];
  List<creditCardModel> cards = [];
  bool isLoading = true;

  int? selectedAddressIndex;
  int? selectedCardIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedAddresses = await localStorageService.getAddresses();
    final loadedCards = await localStorageService.getCards();
    setState(() {
      addresses = loadedAddresses;
      cards = loadedCards;
      isLoading = false;
    });
  }

  // Fiyatları toplarken "₺" gibi sembolleri temizleyip sayıya çeviriyoruz
  double get totalPrice {
    double total = 0;
    for (final product in widget.cartProducts) {
      final raw = product.price ?? "";
      final cleaned = raw.replaceAll(RegExp(r'[^0-9.,]'), '').replaceAll(',', '.');
      total += double.tryParse(cleaned) ?? 0;
    }
    return total;
  }

  Future<void> _confirmOrder() async {
  if (selectedAddressIndex == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lütfen bir teslimat adresi seç")),
    );
    return;
  }
  if (selectedCardIndex == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lütfen bir kart seç")),
    );
    return;
  }

  final address = addresses[selectedAddressIndex!];
  final card = cards[selectedCardIndex!];

  final newOrder = orderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: widget.cartProducts
          .map((product) => orderItem(
                name: product.name ?? "",
                price: product.price ?? "",
                imageUrl: product.image ?? "",
              ))
          .toList(),
      total: totalPrice,
      addressTitle: address.title,
      addressSummary: address.summary,
      cardBrand: card.brand,
      cardMaskedNumber: card.maskedNumber,
    );

    final existingOrders = await localStorageService.getOrders();
    existingOrders.add(newOrder);
    await localStorageService.saveOrders(existingOrders);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const orderConfirmation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA),
      appBar: AppBar(
        title: const Text("Satın Alma"),
        backgroundColor: const Color(0xFFFAF3EA),
        foregroundColor: const Color(0xFF6B4226),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6B4226)))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const Text(
                            "Sipariş Özeti",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4226),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...widget.cartProducts.map(
                            (product) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name ?? "",
                                      style: const TextStyle(color: Color(0xFF3E2C20)),
                                    ),
                                  ),
                                  Text(
                                    product.price ?? "",
                                    style: const TextStyle(color: Color(0xFF9C6B4F)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Color(0xFFE8DCCB), height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Toplam",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6B4226),
                                ),
                              ),
                              Text(
                                "₺${totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6B4226),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Adres seçimi
                          const Text(
                            "Teslimat Adresi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4226),
                            ),
                          ),
                          const SizedBox(height: 12),
                          addresses.isEmpty
                              ? const Text(
                                  "Kayıtlı adresin yok. Profilinden adres ekleyebilirsin.",
                                  style: TextStyle(color: Color(0xFF9C6B4F)),
                                )
                              : Column(
                                  children: List.generate(addresses.length, (index) {
                                    final address = addresses[index];
                                    final isSelected = selectedAddressIndex == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedAddressIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF6B4226)
                                                : const Color(0xFFE8DCCB),
                                            width: isSelected ? 2 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isSelected
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_off,
                                              color: const Color(0xFF6B4226),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    address.title,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF3E2C20),
                                                    ),
                                                  ),
                                                  Text(
                                                    address.summary,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF9C6B4F),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                          const SizedBox(height: 28),

                          // Kart seçimi
                          const Text(
                            "Ödeme Kartı",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4226),
                            ),
                          ),
                          const SizedBox(height: 12),
                          cards.isEmpty
                              ? const Text(
                                  "Kayıtlı kartın yok. Profilinden kart ekleyebilirsin.",
                                  style: TextStyle(color: Color(0xFF9C6B4F)),
                                )
                              : Column(
                                  children: List.generate(cards.length, (index) {
                                    final card = cards[index];
                                    final isSelected = selectedCardIndex == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCardIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF6B4226)
                                                : const Color(0xFFE8DCCB),
                                            width: isSelected ? 2 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isSelected
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_off,
                                              color: const Color(0xFF6B4226),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    card.brand,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF3E2C20),
                                                    ),
                                                  ),
                                                  Text(
                                                    card.maskedNumber,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF9C6B4F),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _confirmOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B4226),
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Siparişi Onayla",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}