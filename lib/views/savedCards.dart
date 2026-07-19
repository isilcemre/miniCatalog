import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minicatalog/models/creditCardModel.dart';
import 'package:minicatalog/services/localStorageService.dart';

class savedCards extends StatefulWidget {
  const savedCards({super.key});

  @override
  State<savedCards> createState() => _savedCardsState();
}

class _savedCardsState extends State<savedCards> {
  final LocalStorageService localStorageService = LocalStorageService();

  // Başta kayıtlı kart yok, initState içinde hafızadan yüklenecek
  List<creditCardModel> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final loadedCards = await localStorageService.getCards();
    setState(() {
      cards = loadedCards;
      isLoading = false;
    });
  }

  // Yeni kart eklemek için form controller
  final formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController(); //16 haneli kart numarası girmek için
  final holderController = TextEditingController();
  final expiryController = TextEditingController(); //
  String selectedBrand = "Visa";

  void _showAddCardSheet() {
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
                const Text(
                  "Yeni kart ekle",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B4226),
                  ),
                ),
                const SizedBox(height: 16),

                // Kart markası seçimi
                DropdownButtonFormField<String>(
                  initialValue: selectedBrand,
                  decoration: InputDecoration(
                    labelText: "Kart markası",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Visa", child: Text("Visa")),
                    DropdownMenuItem(value: "Mastercard", child: Text("Mastercard")),
                    DropdownMenuItem(value: "Troy", child: Text("Troy")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value ?? "Visa";
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Kart numarası (tam 16 hane)
                TextFormField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                    labelText: "Kart numarası",
                    hintText: "1234567812345678",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length != 16) {
                      return 'Lütfen 16 haneli kart numarasını gir';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Kart sahibi
                TextFormField(
                  controller: holderController,
                  decoration: InputDecoration(
                    labelText: "Kart sahibinin adı",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen kart sahibinin adını gir';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Son kullanma tarihi
                TextFormField(
                  controller: expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ExpiryDateFormatter()],
                  decoration: InputDecoration(
                    labelText: "Son kullanma tarihi (AA/YY)",
                    hintText: "09/28",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen son kullanma tarihini gir';
                    }

                    // Format kontrolü: tam olarak AA/YY (örn: 09/28)
                    final regex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');
                    final match = regex.firstMatch(value.trim());
                    if (match == null) {
                      return 'AA/YY formatında gir (örn: 09/28)';
                    }

                    // Tarih geçmiş mi kontrolü
                    final enteredMonth = int.parse(match.group(1)!);
                    final enteredYear = 2000 + int.parse(match.group(2)!);
                    final now = DateTime.now();
                    // Kartın son geçerli günü, o ayın son günü olarak kabul edilir
                    final expiryDate = DateTime(enteredYear, enteredMonth + 1, 0);

                    if (expiryDate.isBefore(now)) {
                      return 'Bu kartın süresi dolmuş';
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
                      setState(() {
                        cards.add(
                          creditCardModel(
                            brand: selectedBrand,
                            cardNumber: cardNumberController.text.trim(),
                            holder: holderController.text.trim(),
                            expiry: expiryController.text.trim(),
                            // Yeni eklenen kartlara renkleri sırayla veriyoruz
                            color: cards.length % 2 == 0
                                ? const Color(0xFF6B4226)
                                : const Color(0xFFC77B4F),
                          ),
                        );
                      });

                      // Güncel listeyi SharedPreferences'a yazıyoruz
                      localStorageService.saveCards(cards);

                      // Formu temizle ve kapat
                      cardNumberController.clear();
                      holderController.clear();
                      expiryController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Kartı kaydet"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteCard(int index) {
    setState(() {
      cards.removeAt(index);
    });
    localStorageService.saveCards(cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA),
      appBar: AppBar(
        title: const Text("Kayıtlı Kartlarım"),
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
                "${cards.length} kart kayıtlı",
                style: const TextStyle(fontSize: 13, color: Color(0xFF9C6B4F)),
              ),
              const SizedBox(height: 16),

              // Kart listesi
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6B4226)))
                    : cards.isEmpty
                    ? const Center(
                        child: Text(
                          "Henüz kayıtlı kartın yok",
                          style: TextStyle(color: Color(0xFF9C6B4F)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: cards.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return Dismissible(
                            key: ValueKey(card.cardNumber + index.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _deleteCard(index),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete_outline, color: Colors.red),
                            ),
                            child: buildCreditCard(card),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // Yeni kart ekleme butonu
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6B4226),
        onPressed: _showAddCardSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Tek bir kartın görsel tasarımı
  Widget buildCreditCard(creditCardModel card) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: card.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.credit_card, color: Colors.white70, size: 24),
              Text(
                card.brand,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            card.maskedNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "KART SAHİBİ",
                    style: TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                  Text(
                    card.holder,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SON KUL.",
                    style: TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                  Text(
                    card.expiry,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
            ],
          )
        ],
      ),
      ],),
    );
  }
}

// Kullanıcı sadece rakam yazsın, "/" karakterini biz otomatik ekleyelim
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Kullanıcının yazdığı metinden sadece rakamları alıyoruz (kullanıcı "/" yazsa bile temizleniyor)
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // En fazla 4 rakam olsun (AA + YY)
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    String formatted = digitsOnly;
    if (digitsOnly.length >= 3) {
      // İlk 2 rakamdan sonra otomatik "/" ekliyoruz
      formatted = "${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}";
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}