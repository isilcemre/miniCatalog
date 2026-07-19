import 'dart:convert';

import 'package:minicatalog/models/creditCardModel.dart';
import 'package:minicatalog/models/orderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minicatalog/models/addressModel.dart';


class LocalStorageService {
  Future<void> saveData(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("ls_username", username);
    //ismi lokal starage kaydeder ve uyg farklı yerlerinde kullanabiliriz
    print("Kayıt edildi: $username");
  }

  Future<String?> getData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("ls_username") ?? ""; //sağdaki değer default eğer boş ise döndürür
    //ismi lokal starage den okur ve uyg farklı yerlerinde kullanabiliriz
  }

  Future <void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("ls_username");
  }

// Kart listesini kaydetme: her kartı Map'e çevirip, hepsini tek bir JSON metnine dönüştürüyoruz
  Future<void> saveCards(List<creditCardModel> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        cards.map((card) => card.toJson()).toList();
    final String encoded = jsonEncode(jsonList);
    await prefs.setString("ls_saved_cards", encoded);
  }

  // Kart listesini okuma: JSON metnini geri çözüp CreditCardModel listesine çeviriyoruz
  Future<List<creditCardModel>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString("ls_saved_cards");

    if (encoded == null || encoded.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded
        .map((item) => creditCardModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

    Future<List<addressModel>> getAddresses() async {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('addresses');
      if (data == null) return [];
      final List decoded = jsonDecode(data);
      return decoded.map((e) => addressModel.fromJson(e)).toList();
    }

    Future<void> saveAddresses(List<addressModel> addresses) async {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(addresses.map((a) => a.toJson()).toList());
      await prefs.setString('addresses', encoded);
    }

    Future<List<orderModel>> getOrders() async {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('orders');
      if (data == null) return [];
      final List decoded = jsonDecode(data);
      return decoded.map((e) => orderModel.fromJson(e)).toList();
    }

    Future<void> saveOrders(List<orderModel> orders) async {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(orders.map((o) => o.toJson()).toList());
      await prefs.setString('orders', encoded);
    }
}