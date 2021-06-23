import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:devnology_cars_register/models/adquired_vehicle_mode.dart';
import 'package:devnology_cars_register/views/widget/vehicle_tile.dart';

class VehicleSearchDelegate extends SearchDelegate {
  final List<AdquiredVehicleModel> vehiclesList;
  List<AdquiredVehicleModel> filtredList = [];
  List<String> sugestionsList = [];
  VehicleSearchDelegate({
    required this.vehiclesList,
  });
  @override
  List<Widget> buildActions(BuildContext context) {
    return [Container()];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: Get.back,
        icon: RotationTransition(
          turns: this.transitionAnimation,
          child: Icon(Icons.arrow_back),
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    filtredList = vehiclesList
        .where((element) => element.vehicleName.toLowerCase().contains(this.query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filtredList.length,
      itemBuilder: (context, index) => VehicleTile(vehicle: filtredList[index]),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    sugestionsList = vehiclesList
        .where((element) => element.vehicleName.toLowerCase().contains(this.query.toLowerCase()))
        .toList()
        .map((e) => e.vehicleName)
        .toList();
    return ListView.builder(
      itemCount: sugestionsList.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          this.query = sugestionsList[index];
          this.showResults(context);
        },
        title: Text(sugestionsList[index]),
      ),
    );
  }
}
