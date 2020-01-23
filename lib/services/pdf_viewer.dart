import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

String path = '';
List<int> bytes;

class PDFViewerOfOurs extends StatefulWidget {
  PDFViewerOfOurs(patho, byteso) {
    print(patho);
    print(byteso);
    path = patho;
    bytes = byteso;
  }

  @override
  _PDFViewerOfOursState createState() => _PDFViewerOfOursState();
}

class _PDFViewerOfOursState extends State<PDFViewerOfOurs> {
  @override
  void initState() {
    super.initState();
  }

  void sharePDF() async {
    await Printing.sharePdf(bytes: bytes, filename: "report.pdf");
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text("Report"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              try {
                sharePDF();
              } catch (err) {
                print('err : ${err.message}');
              }
            },
          ),
        ],
      ),
      path: path,
    );
  }
}
