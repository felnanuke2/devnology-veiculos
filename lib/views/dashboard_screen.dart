import 'package:devnology_cars_register/constants/colors/constant_colors.dart';
import 'package:devnology_cars_register/controllers/dashboard_controller.dart';
import 'package:devnology_cars_register/models/adquired_vehicle_mode.dart';
import 'package:devnology_cars_register/repository/firebase_repository.dart';
import 'package:devnology_cars_register/util/search/vehicles_search_delegate.dart';

import 'package:devnology_cars_register/views/widget/dashboard_drawer.dart';
import 'package:devnology_cars_register/views/widget/vehicle_tile.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late DashboardController _controller;
  void initState() {
    _controller = DashboardController(firebaseRepository: FirebaseRepository());
    _controller.getVehicleList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DashBoarDrawer(),
      bottomNavigationBar: StreamBuilder<int>(
          stream: _controller.filteroutOutput,
          initialData: _controller.filter,
          builder: (context, snapshotFilter) {
            return BottomNavigationBar(
                onTap: (value) => _controller.filterInput = value,
                currentIndex: snapshotFilter.data!,
                items: [
                  BottomNavigationBarItem(icon: Container(), label: 'Todos'),
                  BottomNavigationBarItem(icon: Container(), label: 'Não Vendidos'),
                  BottomNavigationBarItem(icon: Container(), label: 'Vendidos')
                ]);
          }),
      appBar: AppBar(
        title: Text('DashBoard'),
        actions: [
          IconButton(
              onPressed: () => showSearch(
                  context: context,
                  delegate: VehicleSearchDelegate(vehiclesList: _controller.filtredVehicles)),
              icon: Icon(Icons.search)),
          PopupMenuButton<int>(
            icon: Icon(Icons.filter_list_outlined),
            onSelected: (value) => _controller.orderInput = value,
            itemBuilder: (context) => _listPoups(),
          )
        ],
      ),
      body: StreamBuilder<List<AdquiredVehicleModel>>(
          stream: _controller.vehiclesOutput,
          initialData: _controller.filtredVehicles,
          builder: (context, snapshotVehicles) {
            return StreamBuilder<bool>(
                stream: _controller.loadingOutput,
                initialData: _controller.loading,
                builder: (context, snapshotLoading) {
                  bool isLoading = snapshotLoading.data == true;
                  return Column(
                    children: [
                      if (isLoading)
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshotVehicles.data!.length,
                          itemBuilder: (context, index) => VehicleTile(
                            key: UniqueKey(),
                            vehicle: snapshotVehicles.data![index],
                          ),
                        ),
                      )
                    ],
                  );
                });
          }),
    );
  }

  _listPoups() => [
        PopupMenuItem(
            value: -921,
            enabled: false,
            child: Container(
              width: 250,
              child: ListTile(
                title: Text(
                  '-- Ordernar Por --',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            )),
        PopupMenuItem(
            value: 0,
            child: Container(
              width: 250,
              child: ListTile(
                leading: _controller.order == 0
                    ? !_controller.direction
                        ? Icon(Icons.arrow_drop_up)
                        : Icon(Icons.arrow_drop_down)
                    : null,
                tileColor: _controller.order == 0 ? PRIMARY_COLOR.withOpacity(0.4) : null,
                title: Text('Nome do Veículo'),
              ),
            )),
        PopupMenuItem(
            value: 1,
            child: Container(
              width: 250,
              child: ListTile(
                leading: _controller.order == 1
                    ? !_controller.direction
                        ? Icon(Icons.arrow_drop_up)
                        : Icon(Icons.arrow_drop_down)
                    : null,
                tileColor: _controller.order == 1 ? PRIMARY_COLOR.withOpacity(0.4) : null,
                title: Text('Data de Aquisição'),
              ),
            )),
        PopupMenuItem(
            value: 2,
            child: Container(
              width: 250,
              child: ListTile(
                leading: _controller.order == 2
                    ? !_controller.direction
                        ? Icon(Icons.arrow_drop_up)
                        : Icon(Icons.arrow_drop_down)
                    : null,
                tileColor: _controller.order == 2 ? PRIMARY_COLOR.withOpacity(0.4) : null,
                title: Text('Preço de Aquisição'),
              ),
            )),
        if (_controller.filter == 2)
          PopupMenuItem(
              value: 3,
              child: Container(
                width: 250,
                child: ListTile(
                  leading: _controller.order == 3
                      ? !_controller.direction
                          ? Icon(Icons.arrow_drop_up)
                          : Icon(Icons.arrow_drop_down)
                      : null,
                  tileColor: _controller.order == 3 ? PRIMARY_COLOR.withOpacity(0.4) : null,
                  title: Text('Data de Venda'),
                ),
              )),
        if (_controller.filter == 2)
          PopupMenuItem(
              value: 4,
              child: Container(
                width: 250,
                child: ListTile(
                  leading: _controller.order == 4
                      ? !_controller.direction
                          ? Icon(Icons.arrow_drop_up)
                          : Icon(Icons.arrow_drop_down)
                      : null,
                  tileColor: _controller.order == 4 ? PRIMARY_COLOR.withOpacity(0.4) : null,
                  title: Text('Preço de Venda'),
                ),
              )),
      ];
}
