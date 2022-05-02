import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share_plus/share_plus.dart';



class ViewPDF extends StatefulWidget {
  String pathPDF = "";
  ViewPDF({Key? key, required this.pathPDF}) : super(key: key);

  @override
  State<ViewPDF> createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.pathPDF.split('/').last),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                _onShare(context);
              },
            )
          ],
        ),
        //view PDF
        path: widget.pathPDF,
    );
  }

  ///function who share file withe shareFile and filePicker
  void _onShare(BuildContext context) async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareFiles([widget.pathPDF],
          text: 'Enter your message',
          subject: 'Enter your object',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
      );
    }
    catch (error) {
      Flushbar(
        title: 'Warning',
        message: error.toString(),
        duration: const Duration(seconds: 4),
      ).show(context);
    }
  }
}