import 'package:flutter/material.dart';

// Kayıtlı kartları tutan model
class creditCardModel {
  String brand;
  String cardNumber; // tam 16 haneli kart numarası
  String holder;
  String expiry;
  Color color;

  creditCardModel({
    required this.brand,
    required this.cardNumber,
    required this.holder,
    required this.expiry,
    required this.color,
  });

  // Ekranda göstermek için sadece son 4 haneyi alan yardımcı metod
  String get maskedNumber {
    final last4 = cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;
    return "•••• •••• •••• $last4";
  }

  
  Map<String, dynamic> toJson() {
    return {
      "brand": brand,
      "cardNumber": cardNumber,
      "holder": holder,
      "expiry": expiry,
      "color": color.value, // Color nesnesini int koda çeviriyoruz
    };
  }

  
  factory creditCardModel.fromJson(Map<String, dynamic> json) {
    return creditCardModel(
      brand: json["brand"],
      cardNumber: json["cardNumber"],
      holder: json["holder"],
      expiry: json["expiry"],
      color: Color(json["color"]),
    );
  }
}