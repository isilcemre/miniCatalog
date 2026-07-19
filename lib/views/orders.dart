import 'package:flutter/material.dart';
import 'package:minicatalog/models/orderModel.dart';
import 'package:minicatalog/services/localStorageService.dart';

class orders extends StatefulWidget {
  const orders({super.key});

  @override
  State<orders> createState() => _ordersState();
}

class _ordersState extends State<orders> {
  final LocalStorageService localStorageService = LocalStorageService();

  List<orderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final loaded = await localStorageService.getOrders();
    setState(() {
      orders = loaded.reversed.toList(); // en yeni sipariş en üstte
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3EA),
      appBar: AppBar(
        title: const Text("Siparişlerim"),
        backgroundColor: const Color(0xFFFAF3EA),
        foregroundColor: const Color(0xFF6B4226),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6B4226)))
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Color(0xFFB08968),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Henüz siparişin yok.",
                        style: TextStyle(color: Color(0xFF6B4226)),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) => _buildOrderCard(orders[index]),
                ),
    );
  }

  Widget _buildOrderCard(orderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8DCCB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Text(
                "Toplam: ${order.total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B4226),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "${item.name}",
                style: const TextStyle(fontSize: 13, color: Color(0xFF3E2C20)),
              ),
            ),
          ),
          const Divider(color: Color(0xFFE8DCCB), height: 24),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFFB08968)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "${order.addressTitle}",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9C6B4F)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.credit_card, size: 16, color: Color(0xFFB08968)),
              const SizedBox(width: 6),
              Text(
                "${order.cardBrand} • ${order.cardMaskedNumber}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF9C6B4F)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}