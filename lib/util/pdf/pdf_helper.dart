import 'package:date_format/date_format.dart';
import 'package:devnology_cars_register/models/adquired_vehicle_mode.dart';
import 'package:devnology_cars_register/views/widget/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfHelper {
  ///Generate a PDF file from the past list
  static generateRelatry(List<AdquiredVehicleModel> listVehicles) async {
    var context = Get.context;
    var dateRange = await showDateRangePicker(
        context: context!, firstDate: DateTime(2020), lastDate: DateTime.now());
    if (dateRange == null) return;
    _generatePdf(dateRange, listVehicles);
  }

  ///creates pdf file structure
  static _generatePdf(DateTimeRange dateTimeRange, List<AdquiredVehicleModel> listVehicles) async {
    var startAt = dateTimeRange.start;
    var endAt = DateTime.fromMillisecondsSinceEpoch(
        (dateTimeRange.end.millisecondsSinceEpoch + Duration(days: 1).inMilliseconds));
    var days = dateTimeRange.duration.inDays;
    var pdf = pw.Document();
    var listBuy = listVehicles.where((element) {
      return element.buyDate.compareTo(startAt) >= 0 && element.buyDate.compareTo(endAt) <= 0;
    }).toList();
    var listSalle = listVehicles.where((element) {
      if (element.saleModel == null) return false;
      return element.saleModel!.saleDate.compareTo(startAt) >= 0 &&
          element.saleModel!.saleDate.compareTo(endAt) <= 0;
    }).toList();
    var totalBuy = _getTotalBuy(listBuy);
    var totalSale = _getTotalSale(listSalle);
    var totalLucro = totalSale - totalBuy;
    var totalComission = _getSallerComission(listSalle);
    var stringDateStart = _formatDate(startAt);
    var stringDateEnd = _formatDate(endAt);

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return [
          pw.Column(children: [
            pw.Text('Relatório Vendas',
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.Text('De ' + stringDateStart + ' a ' + stringDateEnd + ' ($days dias)',
                style: pw.TextStyle(fontSize: 16)),
            pw.Divider(thickness: 2, height: 14),
            pw.Wrap(
                alignment: pw.WrapAlignment.spaceBetween,
                spacing: 10,
                runSpacing: 10,
                children: [
                  pw.Container(
                      child: pw.Column(children: [
                        pw.Text('Total em Aquisições', style: pw.TextStyle(fontSize: 17)),
                        pw.Text('R\$ ' + totalBuy.toStringAsFixed(2),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17)),
                        pw.Divider(),
                      ]),
                      width: 180),
                  pw.Container(
                      child: pw.Column(children: [
                        pw.Text('Total em Vendas', style: pw.TextStyle(fontSize: 17)),
                        pw.Text('R\$ ' + totalSale.toStringAsFixed(2),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17)),
                        pw.Divider(),
                      ]),
                      width: 180),
                  pw.Container(
                      child: pw.Column(children: [
                        pw.Text('Total em Comissão', style: pw.TextStyle(fontSize: 17)),
                        pw.Text('R\$ ' + totalComission.toStringAsFixed(2),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17)),
                        pw.Divider(),
                      ]),
                      width: 180),
                  pw.Container(
                      child: pw.Column(children: [
                        pw.Text('${totalLucro >= 0 ? 'Lucro' : 'Prejuízo'}',
                            style: pw.TextStyle(fontSize: 17)),
                        pw.Text('R\$ ' + totalLucro.toStringAsFixed(2),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17)),
                        pw.Divider(),
                      ]),
                      width: 180),
                ]),
            pw.SizedBox(height: 15),
            pw.Text('Veículos Adquiridos',
                style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold)),
            pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Column(children: [
                  pw.Row(children: [
                    pw.Expanded(
                      flex: 6,
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text('Nome', maxLines: 1),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text('Ano/Modelo', maxLines: 1),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text('Aquisição', maxLines: 1),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text('Valor', maxLines: 1),
                      ),
                    ),
                  ])
                ])),
            pw.ListView(children: listBuy.map((e) => _buildvehicleRowBuy(e)).toList()),
            pw.SizedBox(height: 15),
            pw.Text('Veículos Vendidos',
                style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold)),
            pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Column(children: [
                  pw.Row(children: [
                    pw.Expanded(
                      flex: 6,
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text('Nome', maxLines: 1),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text('Ano/Modelo', maxLines: 1),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text('Venda', maxLines: 1),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4),
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Text('Valor', maxLines: 1),
                      ),
                    ),
                  ])
                ])),
          ]),
          pw.ListView(children: listSalle.map((e) => _buildVehicleRowSale(e)).toList())
        ];
      },
    ));
    var byte = await pdf.save();
    Get.to(PdfViewrScreen(pdfByte: byte));
  }

  static pw.Container _buildVehicleRowSale(AdquiredVehicleModel item) {
    return pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        child: pw.Column(children: [
          pw.Row(children: [
            pw.Expanded(
              flex: 6,
              child: pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(item.vehicleName, maxLines: 1),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(item.year, maxLines: 1),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(_formatDate(item.saleModel!.saleDate), maxLines: 1),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(item.saleModel!.salePrice.toStringAsFixed(2), maxLines: 1),
              ),
            ),
          ])
        ]));
  }

  static pw.Container _buildvehicleRowBuy(AdquiredVehicleModel item) {
    return pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        child: pw.Column(children: [
          pw.Row(children: [
            pw.Expanded(
              flex: 6,
              child: pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(item.vehicleName, maxLines: 1),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(item.year, maxLines: 1),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(_formatDate(item.buyDate), maxLines: 1),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(item.buyPrice.toStringAsFixed(2), maxLines: 1),
              ),
            ),
          ])
        ]));
  }

  static num _getTotalBuy(List<AdquiredVehicleModel> list) {
    num value = 0;
    list.forEach((element) {
      value += element.buyPrice;
    });
    return value;
  }

  static num _getSallerComission(List<AdquiredVehicleModel> list) {
    num value = 0;
    list.forEach((element) {
      value += element.saleModel!.sellerCommission;
    });
    return value;
  }

  static num _getTotalSale(List<AdquiredVehicleModel> list) {
    num value = 0;
    list.forEach((element) {
      value += element.saleModel!.salePrice;
    });
    return value;
  }

  static String _formatDate(DateTime time) {
    return formatDate(time, [
      dd,
      '/',
      mm,
      '/',
      yyyy,
    ]);
  }
}
