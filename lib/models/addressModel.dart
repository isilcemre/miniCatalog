// lib/models/addressModel.dart
class addressModel {
  String title;      // "Ev", "İş" vb.
  String province;   // İl
  String district;   // İlçe
  String neighborhood; // Mahalle
  String openAddress;  // Açık adres (sokak, no, daire vb.)

  addressModel({
    required this.title,
    required this.province,
    required this.district,
    required this.neighborhood,
    required this.openAddress,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'province': province,
        'district': district,
        'neighborhood': neighborhood,
        'openAddress': openAddress,
      };

  factory addressModel.fromJson(Map<String, dynamic> json) => addressModel(
        title: json['title'],
        province: json['province'],
        district: json['district'],
        neighborhood: json['neighborhood'],
        openAddress: json['openAddress'],
      );

  String get summary => "$neighborhood Mah. $district / $province";
}