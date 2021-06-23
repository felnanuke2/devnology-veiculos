import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:devnology_cars_register/models/vehicle_detail_model.dart';
import 'package:devnology_cars_register/models/year_model.dart';
import 'package:devnology_cars_register/models/marca_model.dart';
import 'package:devnology_cars_register/models/vehicle_no_details_model.dart';
import 'package:devnology_cars_register/repository/firebase_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:devnology_cars_register/repository/fipe_repository.dart';
import 'package:get/route_manager.dart';

class VehiclePurchaseController {
  final FipeRepository repository;
  final FirebaseRepository firebaseRepository;
  final GlobalKey<ScaffoldState> scaffoldKey;
  //list vars

  //listsStrams
  var _listVehiclesNoDetailsStreamController =
      StreamController<List<VehicleNoDetailModel>>.broadcast();
  var _listMarcaStreamController = StreamController<List<MarcaModel>>.broadcast();
  //listSelectedStreams
  var _selectedMarcaStreamController = StreamController<MarcaModel?>.broadcast();
  var _selectedVehicleTypeStreamController = StreamController<VehicleType?>.broadcast();
  var _selectedAnoModeloStreamController = StreamController<YearModel?>.broadcast();
  var _selectedVehicleWithDetailStreamController =
      StreamController<VehicleWithDetaillModel?>.broadcast();
  var _loadingController = StreamController<bool>.broadcast();
  var _selectedVehicleNoDetailsStreamController =
      StreamController<VehicleNoDetailModel?>.broadcast();

  //listSelectedVars
  VehicleType? type;
  MarcaModel? selectedMarcaModel;
  VehicleNoDetailModel? selectedVehicleNoDetailModel;
  YearModel? anoModel;
  VehicleWithDetaillModel? vehicleWithDetail;
  DateTime? buyDate;

  set selectedAnoModeloInput(YearModel anoModeloModelInput) {
    anoModel = anoModeloModelInput;
    _selectedAnoModeloStreamController.add(anoModel);
  }

  set selectedVehicleNoDetailInput(VehicleNoDetailModel vehicleNoDetailModel) {
    anoModel = null;
    _selectedAnoModeloStreamController.add(anoModel);
    selectedVehicleNoDetailModel = vehicleNoDetailModel;
    _selectedVehicleNoDetailsStreamController.add(selectedVehicleNoDetailModel);
  }

  set selectedMarcaInput(MarcaModel marcaModel) {
    //when select a new marcaModel all vars under type will be null
    anoModel = null;
    _selectedAnoModeloStreamController.add(anoModel);
    selectedVehicleNoDetailModel = null;
    _selectedVehicleNoDetailsStreamController.add(selectedVehicleNoDetailModel);
    selectedVehicleNoDetailModel = null;
    _selectedVehicleNoDetailsStreamController.add(selectedVehicleNoDetailModel);
    anoModel = null;
    _selectedAnoModeloStreamController.add(anoModel);

    //this set a new value to selectedmarcaModel
    selectedMarcaModel = marcaModel;
    _selectedMarcaStreamController.add(selectedMarcaModel!);
  }

  set selectedVehicleTypeInput(VehicleType type) {
    //when select a new type all var under type will be null
    selectedMarcaModel = null;
    _selectedMarcaStreamController.add(selectedMarcaModel);
    selectedVehicleNoDetailModel = null;
    _selectedVehicleNoDetailsStreamController.add(selectedVehicleNoDetailModel);
    anoModel = null;
    _selectedAnoModeloStreamController.add(anoModel);
    _selectedAnoModeloStreamController.add(anoModel);

    //this set a new value for type
    this.type = type;
    _selectedVehicleTypeStreamController.add(this.type!);
  }

//listgetters
  Stream<List<MarcaModel>> get listMarcaOutput => _listMarcaStreamController.stream;
  Stream<VehicleType?> get selectedTypeOutput => _selectedVehicleTypeStreamController.stream;
  Stream<MarcaModel?> get selectedMarcaModelOutput => _selectedMarcaStreamController.stream;
  Stream<YearModel?> get selectedAnoModeloOutput => _selectedAnoModeloStreamController.stream;
  Stream<VehicleNoDetailModel?> get selectedVehicleNoDetailOutput =>
      _selectedVehicleNoDetailsStreamController.stream;
  Stream<bool> get loadingOutput => _loadingController.stream;

  void dispose() {
    _listMarcaStreamController.close();
    _listVehiclesNoDetailsStreamController.close();
    _selectedMarcaStreamController.close();
    _selectedVehicleNoDetailsStreamController.close();
    _selectedVehicleTypeStreamController.close();
    _loadingController.close();
  }

  VehiclePurchaseController(
      {required this.repository, required this.scaffoldKey, required this.firebaseRepository});

  Future<List<MarcaModel>> getMarcas() async {
    this.type = type;
    var marcas = await repository.getMarcas(type!);
    if (marcas != null) {
      marcas.sort((b, a) => b.fipeName.compareTo(a.fipeName));
      return marcas;
    } else {
      return [];
    }
  }

  Future<List<VehicleNoDetailModel>> getVehiclesList() async {
    var vehicles = await repository.getVehicles(type!, selectedMarcaModel!.id);
    if (vehicles != null) {
      return vehicles;
    } else {
      return [];
    }
  }

  Future<List<YearModel>> getAnoModel() async {
    var anoModel = await repository.getVehicleYearModel(
        type!, selectedMarcaModel!.id, selectedVehicleNoDetailModel!.id);
    if (anoModel != null) return anoModel;
    return [];
  }

  Future<VehicleWithDetaillModel?> getVehicleWithDetail() async {
    var result = await repository.getVehicleDetail(
        type!, selectedMarcaModel!.id, selectedVehicleNoDetailModel!.id, anoModel!.id);
    vehicleWithDetail = result;
    return result;
  }

  Future<String?> pickBuyDate(BuildContext context) async {
    var result = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        locale: Locale('pt', 'BR'),
        initialEntryMode: DatePickerEntryMode.input,
        lastDate: DateTime.now());
    if (result != null) {
      buyDate = result;
      var dateString = formatDate(buyDate!, [dd, '/', mm, '/', yyyy]);
      return dateString;
    }
  }

  void createnewVehicle(String placa, String chassis, String buyPrice, String color) async {
    var verify = _veryfyField();
    if (verify != null) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            title: Text(verify),
          )));
      return;
    }
    _loadingController.add(true);
    await firebaseRepository.createVehicle(
        type: type!,
        marca: selectedMarcaModel!.fipeName,
        vehicleName: vehicleWithDetail!.name,
        year: anoModel!.key,
        placa: placa,
        chassis: chassis,
        buyPrice: buyPrice,
        buyDate: buyDate!,
        color: color);
    _loadingController.add(false);
    Get.back();
    Get.snackbar(
      'Veículo Criado Com Sucesso',
      '',
      icon: Container(
        padding: EdgeInsets.all(8),
        child: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(
              Icons.check,
              color: Colors.white,
            )),
      ),
      backgroundColor: Colors.white,
      barBlur: 0,
    );
  }

  String? _veryfyField() {
    if (type == null) return 'Escolha um Tipo de Veículo';
    if (selectedMarcaModel == null) return 'Escolha uma Marcar';
    if (selectedVehicleNoDetailModel == null) return 'Escolha um Veículo';
    if (anoModel == null) return 'Escolha o Ano do Model';
    if (buyDate == null) return 'Escolha uma data de Compra';
    return null;
  }
}
