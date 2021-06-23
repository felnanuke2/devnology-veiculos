import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devnology_cars_register/constants/vars/constan_vars.dart';
import 'package:devnology_cars_register/models/adquired_vehicle_mode.dart';
import 'package:devnology_cars_register/models/sale_model.dart';
import 'package:devnology_cars_register/repository/fipe_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  Future<bool> createVehicle(
      {required VehicleType type,
      required String marca,
      required String vehicleName,
      required String year,
      required String placa,
      required String chassis,
      required String buyPrice,
      required DateTime buyDate,
      required String color}) async {
    var price = num.parse(buyPrice.replaceFirst('.', '').replaceAll(',', '.'));
    var vehicle = AdquiredVehicleModel(
        type: type,
        marca: marca,
        vehicleName: vehicleName,
        year: year,
        placa: placa,
        chassis: chassis,
        buyPrice: price,
        buyDate: buyDate,
        color: color);
    await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(VEHICLES_COLLECTION)
        .doc()
        .set(Map<String, dynamic>.from(vehicle.toMap()));
    return true;
  }

  Stream<List<AdquiredVehicleModel>> getVehiclesList() {
    return FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(VEHICLES_COLLECTION)
        .snapshots()
        .asyncMap((event) {
      return event.docs.map((e) => AdquiredVehicleModel.fromMap(e.data(), e.id)).toList();
    });
  }

  Future<AdquiredVehicleModel?> saleVehicle(
      AdquiredVehicleModel vehicleModel, SaleModel sale) async {
    try {
      await FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(VEHICLES_COLLECTION)
          .doc(vehicleModel.id)
          .update({'salemodel': sale.toMap()});
      var model = vehicleModel;
      model.saleModel = sale;

      return model;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deletVeiculo(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(VEHICLES_COLLECTION)
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
