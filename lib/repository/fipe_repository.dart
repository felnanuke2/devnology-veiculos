import 'dart:convert';

import 'package:devnology_cars_register/models/vehicle_detail_model.dart';
import 'package:devnology_cars_register/models/year_model.dart';
import 'package:devnology_cars_register/models/marca_model.dart';
import 'package:devnology_cars_register/models/vehicle_no_details_model.dart';
import 'package:http/http.dart' as http;

class FipeRepository {
  final BASE_API_URL = 'http://fipeapi.appspot.com/api/1/';

  ///responsible for making the request for the list of brands
  Future<List<MarcaModel>?> getMarcas(VehicleType vehicleType) async {
    final marcaUrl = '$BASE_API_URL${_getVehicleType(vehicleType)}/marcas.json';
    var response = await http.get(Uri.parse(marcaUrl));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var listMarcas =
          List<Map<String, dynamic>>.from(json).map((e) => MarcaModel.fromMap(e)).toList();
      return listMarcas;
    } else
      return null;
  }

  ///responsible for making the request to obtain the vehicle list
  Future<List<VehicleNoDetailModel>?> getVehicles(VehicleType type, int marcaID) async {
    final vehiclesApiUrl = '$BASE_API_URL${_getVehicleType(type)}/veiculos/$marcaID.json';
    var response = await http.get(Uri.parse(vehiclesApiUrl));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var vehiclesList = List<Map<String, dynamic>>.from(json)
          .map((e) => VehicleNoDetailModel.fromMap(e))
          .toList();
      return vehiclesList;
    } else {
      return null;
    }
  }

  ///responsible for making the request to obtain the list of years of the vehicles
  Future<List<YearModel>?> getVehicleYearModel(
      VehicleType type, int marcaId, String vehicleId) async {
    final vehicleModelApiUrl =
        '$BASE_API_URL${_getVehicleType(type)}/veiculo/$marcaId/$vehicleId.json';
    var response = await http.get(Uri.parse(vehicleModelApiUrl));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var list = List<Map<String, dynamic>>.from(json).map((e) => YearModel.fromMap(e)).toList();
      return list;
    } else {
      return null;
    }
  }

  ///responsible for making the request to obtain the detailed result of a particular vehicle
  Future<VehicleWithDetaillModel?> getVehicleDetail(
      VehicleType type, int marcaId, String vehicleId, String modelId) async {
    final vehicleDetailApiUrl =
        '$BASE_API_URL${_getVehicleType(type)}/veiculo/$marcaId/$vehicleId/$modelId.json';
    var response = await http.get(Uri.parse(vehicleDetailApiUrl));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return VehicleWithDetaillModel.fromMap(json);
    } else {
      return null;
    }
  }

  ///turns an enum of [VehicleType] into a string to query the api
  String _getVehicleType(VehicleType type) {
    switch (type) {
      case VehicleType.Carros:
        return 'carros';
      case VehicleType.Motos:
        return 'motos';
      case VehicleType.Caminhoes:
        return 'caminhoes';
    }
  }
}

enum VehicleType {
  Carros,
  Motos,
  Caminhoes,
}
