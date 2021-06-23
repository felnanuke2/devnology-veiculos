import 'dart:convert';

class SaleModel {
  final DateTime saleDate;
  final num salePrice;
  final num sellerCommission;
  SaleModel({
    required this.saleDate,
    required this.salePrice,
    required this.sellerCommission,
  });

  Map<String, dynamic> toMap() {
    return {
      'saleDate': saleDate.millisecondsSinceEpoch,
      'salePrice': salePrice,
      'sellerCommission': sellerCommission,
    };
  }

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      saleDate: DateTime.fromMillisecondsSinceEpoch(map['saleDate']),
      salePrice: map['salePrice'],
      sellerCommission: map['sellerCommission'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SaleModel.fromJson(String source) => SaleModel.fromMap(json.decode(source));
}
