import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

import 'homepage.dart';

class ViewPDF extends StatefulWidget {
  String pathPDF = "";
  ViewPDF({Key? key, required this.pathPDF, }) : super(key: key);

  @override
  State<ViewPDF> createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.pathPDF.split('/').last),
      ),
      body: PdfView(
        path: widget.pathPDF,
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              onPressed: () => _onShare(context),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.share_outlined,
                      size: 29,
                    ),
                    Text(
                      "Share your doc",
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      style: const TextStyle(fontSize: 15),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _onDelete(File(widget.pathPDF));
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage())
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.delete_forever,
                      size: 29,
                    ),
                    Text(
                      "delete your doc",
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      style: const TextStyle(fontSize: 15),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  ///function who share file withe shareFile and filePicker
  void _onShare(BuildContext context) async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareFiles([widget.pathPDF],
          text: 'Enter your message',
          subject: 'Enter your object',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } catch (error) {
      Flushbar(
        title: 'Warning',
        message: error.toString(),
        duration: const Duration(seconds: 4),
      ).show(context);
    }
  }

  Future<void> _onDelete(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      return;
    }
  }
}
