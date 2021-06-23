import 'package:devnology_cars_register/controllers/dashboard_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:devnology_cars_register/models/adquired_vehicle_mode.dart';
import 'package:devnology_cars_register/util/pdf/pdf_helper.dart';
import 'package:devnology_cars_register/views/login_screen.dart';
import 'package:devnology_cars_register/views/vehicle_purchase%20.dart';

class DashBoarDrawer extends StatefulWidget {
  @override
  _DashBoarDrawerState createState() => _DashBoarDrawerState();
}

class _DashBoarDrawerState extends State<DashBoarDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            'Menu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Divider(
            height: 20,
            thickness: 4,
          ),
          ListTile(
              onTap: () {
                Get.back();
                Get.to(() => VehiclePurchaseScreen());
              },
              leading: Icon(
                Icons.add,
              ),
              title: Text(
                'Nova Aquisição',
              )),
          ListTile(
            onTap: () => PdfHelper.generateRelatry(DashboardController.vehicles),
            leading: Icon(Icons.document_scanner_outlined),
            title: Text('Obter Relatório'),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginScreen());
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
          )
        ],
      ),
    );
  }
}
