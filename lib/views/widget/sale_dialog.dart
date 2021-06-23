import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/route_manager.dart';

class SaleDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final MoneyMaskedTextController salePrice;
  final TextEditingController saleDate;
  DateTime? date;

  final Future<DateTime?> Function(TextEditingController controller) pickSaleDate;
  SaleDialog({
    Key? key,
    required this.formKey,
    required this.salePrice,
    required this.saleDate,
    required this.pickSaleDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        insetPadding: EdgeInsets.all(6),
        title: Text('Dados Da Venda'),
        content: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                  width: 330,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      value = salePrice.text;
                      if (value.isEmpty) return 'Isira um Preço para essa Venda';
                      if (value == '0,00') return 'Preço Inválido';
                      return null;
                    },
                    controller: salePrice,
                    decoration: InputDecoration(labelText: 'Valor da Venda'),
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                  width: 330,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) return 'Insira a Data da Venda';
                      return null;
                    },
                    controller: saleDate,
                    onTap: () {
                      pickSaleDate(saleDate).then((value) => date = value);
                    },
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Data da Venda'),
                  ))
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancelar')),
          TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Get.back(result: date);
              },
              child: Text('Finalizar Venda'))
        ],
      ),
    );
  }
}
