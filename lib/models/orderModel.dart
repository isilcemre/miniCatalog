class orderItem {
  final String name;
  final String price;
  final String imageUrl;

  orderItem({required this.name, required this.price, required this.imageUrl});

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
      };

  factory orderItem.fromJson(Map<String, dynamic> json) => orderItem(
        name: json['name'],
        price: json['price'],
        imageUrl: json['imageUrl'],
      );
}

class orderModel {
  final String id;
  final DateTime date;
  final List<orderItem> items;
  final double total;
  final String addressTitle;
  final String addressSummary;
  final String cardBrand;
  final String cardMaskedNumber;

  orderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.addressTitle,
    required this.addressSummary,
    required this.cardBrand,
    required this.cardMaskedNumber,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'addressTitle': addressTitle,
        'addressSummary': addressSummary,
        'cardBrand': cardBrand,
        'cardMaskedNumber': cardMaskedNumber,
      };

  factory orderModel.fromJson(Map<String, dynamic> json) => orderModel(
        id: json['id'],
        date: DateTime.parse(json['date']),
        items: (json['items'] as List).map((e) => orderItem.fromJson(e)).toList(),
        total: (json['total'] as num).toDouble(),
        addressTitle: json['addressTitle'],
        addressSummary: json['addressSummary'],
        cardBrand: json['cardBrand'],
        cardMaskedNumber: json['cardMaskedNumber'],
      );
}