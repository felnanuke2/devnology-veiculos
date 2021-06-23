import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share/share.dart';

class PdfViewrScreen extends StatefulWidget {
  final Uint8List pdfByte;
  PdfViewrScreen({
    Key? key,
    required this.pdfByte,
  }) : super(key: key);

  @override
  _PdfViewrScreenState createState() => _PdfViewrScreenState();
}

class _PdfViewrScreenState extends State<PdfViewrScreen> {
  late PdfController pdfController;

  @override
  void initState() {
    pdfController = PdfController(document: PdfDocument.openData(widget.pdfByte));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Relatório'),
        actions: [
          IconButton(onPressed: _shareFile, icon: Icon(Icons.share)),
        ],
      ),
      body: PdfView(controller: pdfController),
    );
  }

  void _shareFile() async {
    var path = Directory.systemTemp.path + '/relatory${DateTime.now().toString()}.pdf';
    var file = File(path);
    await file.writeAsBytes(widget.pdfByte);

    Share.shareFiles([file.path]);
  }
}
