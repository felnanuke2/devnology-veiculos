import 'package:date_format/date_format.dart';
import 'package:devnology_cars_register/controllers/dashboard_controller.dart';
import 'package:devnology_cars_register/models/sale_model.dart';
import 'package:devnology_cars_register/repository/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'package:devnology_cars_register/models/adquired_vehicle_mode.dart';
import 'package:get/route_manager.dart';

class VehicleDetailScreen extends StatefulWidget {
  final AdquiredVehicleModel vehicleModel;
  VehicleDetailScreen({
    Key? key,
    required this.vehicleModel,
  }) : super(key: key);

  @override
  _VehicleDetailScreenState createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  var money = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
  );

  var salemoney = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
  );

  var sellerComission = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
  );

  var _controller = DashboardController(firebaseRepository: FirebaseRepository());

  SaleModel? saleModel;

  @override
  Widget build(BuildContext context) {
    money.text = widget.vehicleModel.buyPrice.toStringAsFixed(2);
    saleModel = widget.vehicleModel.saleModel;
    if (saleModel != null) {
      salemoney.text = saleModel!.salePrice.toStringAsFixed(2);
      sellerComission.text = saleModel!.sellerCommission.toStringAsFixed(2);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        actions: [
          if (saleModel == null)
            TextButton.icon(
                onPressed: () async {
                  var result = await _controller.saleVehicle(widget.vehicleModel);
                  if (result != null) {
                    widget.vehicleModel.saleModel = result.saleModel;
                    setState(() {});
                  }
                },
                icon: Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                ),
                label: Text(
                  'Vender',
                  style: TextStyle(color: Colors.white),
                )),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: _deletProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Form(
            child: Column(
              children: [
                ListTile(
                  tileColor: widget.vehicleModel.saleModel == null
                      ? Colors.red.withOpacity(0.6)
                      : Colors.green,
                  title: Text(
                    'Status de Venda: ' +
                        (widget.vehicleModel.saleModel == null ? 'Aguardando Venda' : 'Vendido'),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                if (saleModel != null)
                  Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Data da Venda: ' + _formatDate(saleModel!.saleDate),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Valor da Venda: ' + salemoney.text,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Comissão do Vendedor: ' + sellerComission.text,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ListTile(
                  leading: Icon(Icons.car_rental),
                  title: Text(
                    widget.vehicleModel.vehicleName,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Tipo de Veículo: ' +
                        widget.vehicleModel.type.toString().replaceAll('VehicleType.', ''),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Data de Aquisição: ' + _formatDate(widget.vehicleModel.buyDate),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Marca: ' + widget.vehicleModel.marca,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Ano/Modelo: ' + widget.vehicleModel.year,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Preço de Aquisição: R\$ ' + money.text,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Cor: ' + widget.vehicleModel.color,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Placa: ' + widget.vehicleModel.placa,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Chassis: ' + widget.vehicleModel.chassis,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return formatDate(date, [dd, '/', mm, '/', yy]);
  }

  void _deletProduct() async {
    var result = await Get.dialog(SingleChildScrollView(
      child: AlertDialog(
        insetPadding: EdgeInsets.all(6),
        title: Text('Exluir Veículo'),
        content: Text('Você Deseja Excluir esse Veículo?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Não')),
          TextButton(onPressed: () => Get.back(result: true), child: Text('Sim')),
        ],
      ),
    ));
    if (result == true) {
      _controller.deletVehicle(widget.vehicleModel.id!);
    }
  }
}
