import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:devnology_cars_register/models/sale_model.dart';
import 'package:devnology_cars_register/views/vehicle_detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:devnology_cars_register/models/adquired_vehicle_mode.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/route_manager.dart';

class VehicleTile extends StatefulWidget {
  final AdquiredVehicleModel vehicle;
  const VehicleTile({
    Key? key,
    required this.vehicle,
  }) : super(key: key);

  @override
  _VehicleTileState createState() => _VehicleTileState();
}

class _VehicleTileState extends State<VehicleTile> {
  var money = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
  );
  SaleModel? saleModel;
  @override
  void initState() {
    money.text = widget.vehicle.buyPrice.toStringAsFixed(2);
    if (widget.vehicle.saleModel != null) saleModel = widget.vehicle.saleModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => VehicleDetailScreen(
            vehicleModel: widget.vehicle,
          )),
      child: Container(
        padding: EdgeInsets.all(12),
        color: Colors.grey.withOpacity(0.4),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (saleModel != null)
              Column(
                children: [
                  Text(
                    'Vendido',
                    maxLines: 1,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            Text(
              'Nome: ' + widget.vehicle.vehicleName,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            Text(
              'Marca: ' + widget.vehicle.marca,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            Text(
              'Ano/Modelo: ' + widget.vehicle.year,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            Text(
              'Cor: ' + widget.vehicle.color,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            Text(
              'Data de aquisição: ' + _formatDate(),
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            Text(
              'Preço de Aquisição: R\$ ' + money.text,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate() {
    return formatDate(widget.vehicle.buyDate, [dd, '/', mm, '/', yy]);
  }
}
