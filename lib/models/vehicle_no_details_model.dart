import 'dart:convert';

class VehicleNoDetailModel {
  final String? fipeMarca;
  final String name;
  final String? marca;
  final String key;
  final String id;
  final String fipeName;

  VehicleNoDetailModel({
    required this.fipeMarca,
    required this.name,
    required this.marca,
    required this.key,
    required this.id,
    required this.fipeName,
  });

  Map<String, dynamic> toMap() {
    return {
      'fipe_marca': fipeMarca,
      'name': name,
      'marca': marca,
      'key': key,
      'id': id,
      'fipe_name': fipeName,
    };
  }

  factory VehicleNoDetailModel.fromMap(Map<String, dynamic> map) {
    return VehicleNoDetailModel(
      fipeMarca: map['fipe_marca'],
      name: map['name'],
      marca: map['marca'],
      key: map['key'],
      id: map['id'],
      fipeName: map['fipe_name'],
    );
  }
}
