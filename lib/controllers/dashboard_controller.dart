import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:devnology_cars_register/models/adquired_vehicle_mode.dart';
import 'package:devnology_cars_register/models/sale_model.dart';
import 'package:devnology_cars_register/repository/firebase_repository.dart';
import 'package:devnology_cars_register/views/widget/sale_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/route_manager.dart';

class DashboardController {
  DashboardController({
    required this.firebaseRepository,
  });

  final FirebaseRepository firebaseRepository;
  static List<AdquiredVehicleModel> vehicles = [];
  List<AdquiredVehicleModel> filtredVehicles = [];
  int filter = 0;
  int order = 0;
  bool direction = false;

  var _vehiclesController = StreamController<List<AdquiredVehicleModel>>.broadcast();
  var _vehiclesRawController = StreamController<List<AdquiredVehicleModel>>.broadcast();
  var _filterController = StreamController<int>.broadcast();

  ///Defines what type of Vehicle the user wants to see.
  ///0 indicates all;
  ///1 indicates unsold;
  ///2 indicates sold;
  set filterInput(int index) {
    filter = index;
    order = 0;
    _filterController.add(filter);
    _updateList();
  }

  ///defines in which order the list results should appear.
  ///the direction is defined by the var [direction] that every time it is reordered, it changes its value to the inverse
  ///use  0 is vehicleName, 1 is buyDate, 2 is buyPrice, 3 is saleDate, 4 is salePrice
  set orderInput(int index) {
    order = index;
    _updateList();
  }

  Stream<int> get filteroutOutput => _filterController.stream;
  Stream<List<AdquiredVehicleModel>> get vehiclesOutput => _vehiclesController.stream;
  Stream<List<AdquiredVehicleModel>> get vehiclesRawOutput => _vehiclesRawController.stream;

  ///invokes the FirebaseRepository snapshot and keeps listening for changes that are made to the database.
  void getVehicleList() async {
    firebaseRepository.getVehiclesList().listen((event) {
      vehicles = event;
      _vehiclesRawController.add(vehicles);
      _updateList();
    });
  }

  ///Makes the sale of a vehicle.
  ///It is necessary to pass the vehicle to which you want to make the sale
  Future<AdquiredVehicleModel?> saleVehicle(AdquiredVehicleModel vehicle) async {
    var result = await _showSaleDialog();
    if (result == null) return null;

    DateTime saleDate = result['saledate'];
    num salePrice =
        num.parse(result['saleprice'].toString().replaceFirst('.', '').replaceAll(',', '.'));

    var lucro = salePrice - vehicle.buyPrice;
    //seller lucro = 10% (0.1)
    var sellerComission = lucro * 0.1;
    var sale =
        SaleModel(saleDate: saleDate, salePrice: salePrice, sellerCommission: sellerComission);

    var saleResult = await firebaseRepository.saleVehicle(vehicle, sale);
    return saleResult;
  }

  ///invokes a dialog so the user can choose the sale amount and date
  Future<Map?> _showSaleDialog() async {
    var salePrice = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
    var saleDate = TextEditingController();
    var formKey = GlobalKey<FormState>();
    var result = await Get.dialog(SaleDialog(
      formKey: formKey,
      salePrice: salePrice,
      saleDate: saleDate,
      pickSaleDate: _pickSaleDate,
    ));
    if (result != null) {
      return {'saleprice': salePrice.text, 'saledate': result};
    }
  }

  ///shows a dialog for the user to choose on which date the vehicle was sold
  Future<DateTime?> _pickSaleDate(TextEditingController textController) async {
    var context = Get.context!;
    var result = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        locale: Locale('pt', 'BR'),
        initialEntryMode: DatePickerEntryMode.input,
        lastDate: DateTime.now());
    if (result != null) {
      var dateString = formatDate(result, [dd, '/', mm, '/', yyyy]);
      textController.text = dateString;

      return result;
    }
    return null;
  }

  ///delete a vehicle from the database
  deletVehicle(String id) async {
    Get.snackbar('Deletando Veículo', 'Seu veículo esta sendo removido.',
        backgroundColor: Colors.white,
        showProgressIndicator: true,
        duration: Duration(seconds: 15),
        progressIndicatorValueColor: AlwaysStoppedAnimation(Get.theme.primaryColor));
    var result = await firebaseRepository.deletVeiculo(id);
    if (result == true) {
      Get.back();
      Get.back();
      Get.snackbar('Veículo Removido', 'Seu veículo foi removido com sucesso',
          backgroundColor: Colors.white,
          icon: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ));
    } else {
      Get.snackbar('Erro!', 'Não foi possível deletar esse Veículo',
          backgroundColor: Colors.white,
          icon: CircleAvatar(
              backgroundColor: Colors.red, child: Icon(Icons.close, color: Colors.white)));
    }
  }

  ///filters which result the user wants to see and then updates the view through the streamController
  _updateList() {
    switch (filter) {
      case 0:
        filtredVehicles = vehicles;
        break;
      case 1:
        filtredVehicles = vehicles.where((element) => element.saleModel == null).toList();
        break;

      case 2:
        filtredVehicles = vehicles.where((element) => element.saleModel != null).toList();

        break;
      default:
    }

    _orderBy();
    _vehiclesController.add(filtredVehicles);
  }

  ///define in which order the list results will appear to the user
  _orderBy() {
    switch (order) {
      case 0:
        if (direction) {
          filtredVehicles.sort((a, b) => a.vehicleName.compareTo(b.vehicleName));
        } else {
          filtredVehicles.sort((b, a) => a.vehicleName.compareTo(b.vehicleName));
        }
        direction = !direction;
        break;
      case 1:
        if (direction) {
          filtredVehicles.sort((a, b) => a.buyDate.compareTo(b.buyDate));
        } else {
          filtredVehicles.sort((b, a) => a.buyDate.compareTo(b.buyDate));
        }
        direction = !direction;
        break;
      case 2:
        if (direction) {
          filtredVehicles.sort((a, b) => a.buyPrice.compareTo(b.buyPrice));
        } else {
          filtredVehicles.sort((b, a) => a.buyPrice.compareTo(b.buyPrice));
        }
        direction = !direction;
        break;
      case 3:
        if (direction) {
          filtredVehicles.sort((a, b) => a.saleModel!.saleDate.compareTo(b.saleModel!.saleDate));
        } else {
          filtredVehicles.sort((b, a) => a.saleModel!.saleDate.compareTo(b.saleModel!.saleDate));
        }
        direction = !direction;
        break;
      case 4:
        if (direction) {
          filtredVehicles.sort((a, b) => a.saleModel!.salePrice.compareTo(b.saleModel!.salePrice));
        } else {
          filtredVehicles.sort((b, a) => a.saleModel!.salePrice.compareTo(b.saleModel!.salePrice));
        }
        direction = !direction;
        break;
      default:
    }
  }
}
