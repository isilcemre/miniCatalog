import 'dart:convert';

import 'package:minicatalog/models/productModel.dart';
import 'package:http/http.dart' as http; //tüm kütüphaneyi değil sadece belirli bir kısmını kullanmak için as http 


class ApiService {
  Future<productModel> fetchProducts() async {
    final response = await http.get(Uri.parse("https://wantapi.com/products.php"));

    if (response.statusCode == 200) { //başarılı bir yanıt alındığında
      final data = jsonDecode(response.body);
    
      return productModel.fromJson(data) ; 

    } else {
      throw Exception('Failed to load products');
    }
  }
}
