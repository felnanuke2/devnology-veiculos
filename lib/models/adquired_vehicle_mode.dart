import 'dart:convert';

import 'package:devnology_cars_register/models/sale_model.dart';
import 'package:devnology_cars_register/repository/fipe_repository.dart';

class AdquiredVehicleModel {
  String? id;
  VehicleType type;
  final String marca;
  final String vehicleName;
  final String year;
  final String placa;
  final String chassis;
  final num buyPrice;
  final DateTime buyDate;
  final String color;
  SaleModel? saleModel;

  AdquiredVehicleModel(
      {required this.type,
      required this.marca,
      required this.vehicleName,
      required this.year,
      required this.placa,
      required this.chassis,
      required this.buyPrice,
      required this.buyDate,
      required this.color,
      this.saleModel,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'marca': marca,
      'vehicleName': vehicleName,
      'year': year,
      'placa': placa,
      'chassis': chassis,
      'buyPrice': buyPrice,
      'buyDate': buyDate.millisecondsSinceEpoch,
      'color': color,
      'salemodel': saleModel?.toMap()
    };
  }

  factory AdquiredVehicleModel.fromMap(Map<String, dynamic> map, String id) {
    return AdquiredVehicleModel(
        type: _getTypeFromString(map['type']),
        marca: map['marca'],
        vehicleName: map['vehicleName'],
        year: map['year'],
        placa: map['placa'],
        chassis: map['chassis'],
        buyPrice: map['buyPrice'],
        buyDate: DateTime.fromMillisecondsSinceEpoch(map['buyDate']),
        color: map['color'],
        id: id,
        saleModel: map['salemodel'] == null ? null : SaleModel.fromMap(map['salemodel']));
  }

  static VehicleType _getTypeFromString(String value) {
    switch (value) {
      case 'VehicleType.Carros':
        return VehicleType.Carros;
      case 'VehicleType.Caminhoes':
        return VehicleType.Caminhoes;
    }
    return VehicleType.Motos;
  }
}
