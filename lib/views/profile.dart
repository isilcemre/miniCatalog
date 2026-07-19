import 'package:flutter/material.dart';
import 'package:minicatalog/models/productModel.dart';
import 'package:minicatalog/views/favorites.dart';
import 'package:minicatalog/views/orders.dart';
import 'package:minicatalog/views/savedCards.dart';
import 'package:minicatalog/views/savedAdresses.dart';

class profile extends StatefulWidget {
  final List<Data> products;
  final Set<int> favIds;

  const profile({super.key, required this.products, required this.favIds});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFFFAF3EA),
        foregroundColor: const Color(0xFF6B4226),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => favorites(
                      products: widget.products,
                      favIds: widget.favIds,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.favorite_border, color: Color(0xFF6B4226)),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Favorilerim",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E2C20),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8DCCB)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => orders(),
                  ),
                );
              },
              icon: const Icon(Icons.credit_card, color: Color(0xFF6B4226)),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Siparişlerim",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E2C20),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8DCCB)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),


          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => savedCards(),
                  ),
                );
              },
              icon: const Icon(Icons.credit_card, color: Color(0xFF6B4226)),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kayıtlı Kartlarım",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E2C20),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8DCCB)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => savedAddresses(),
                  ),
                );
              },
              icon: const Icon(Icons.location_on_outlined, color: Color(0xFF6B4226)),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kayıtlı Adreslerim",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E2C20),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8DCCB)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}