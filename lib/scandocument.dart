import 'dart:io';
import 'package:appscan/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ScanDocument extends StatefulWidget {
  const ScanDocument({Key? key}) : super(key: key);

  @override
  State<ScanDocument> createState() => _ScanDocumentState();
}

class _ScanDocumentState extends State<ScanDocument> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  final List<File> _image = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scan doc Page'),
      ),
      body: Stack(
        children: [
          /// if _image is empty display text
          (_image.isEmpty)
              ? Center(
            child: Text(
              "No image or photo ready to scan",
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
          /// else _image is not empty, so display image in the body page
              : Container(
            /// scrolling effects
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                /// custom scroll effects
                SliverPadding(
                  padding: const EdgeInsets.all(3.0),
                  sliver: SliverGrid.count(
                      childAspectRatio: 10.0 / 9.0,
                      mainAxisSpacing: 20, ///horizontal space
                      crossAxisSpacing: 20, ///vertical space
                      crossAxisCount: 3, ///number of images for a row
                      children: _image
                      /// create _image array
                          .map((image) => Hero(
                        tag: image.path,
                        child: Stack(
                          children: [
                            /// get file _image
                            Image.file(
                              image,
                              height: 150,
                              width: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3,
                              fit: BoxFit.cover,
                            ),
                            /// displays an icon when an image appears
                            Positioned(
                                right: 5,
                                top: 5,
                                child: GestureDetector(
                                  onTap: () => _removeFile(_image
                                      .map((e) => e.path)
                                      .toList()
                                      .indexOf(image.path)),
                                  child: Container(
                                    padding:
                                    const EdgeInsets.all(3),
                                    child: const Icon(
                                      Icons.delete,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ))
                      /// add to a list
                          .toList()),
                ),
              ],
            ),
          ),
          Positioned(
            child: Container(
              alignment: Alignment.center,
              height: 90,
              margin: const EdgeInsets.only(top: 420),
              padding: const EdgeInsets.all(10.0),
              child:
              /// if _image is not empty display a button pdf converter
              (_image.isNotEmpty)
                  ? ElevatedButton(
                onPressed: () {
                  createPdf();
                  savePdf();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 31,
                    ),
                    Text(
                      'Convert to pdf',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
                  : Container(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              onPressed: () => getDocumentFromCamera(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.add_a_photo,
                      size: 29,
                    ),
                    Text(
                      "add photo camera",
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
              onPressed: () => getDocumentFromGallery(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.image,
                      size: 29,
                    ),
                    Text(
                      "add photo gallery",
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

  /// function take photo from camera
  getDocumentFromCamera() async {
    try {
      /// source of method here the source is camera
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        /// if source is not null
        if (pickedFile != null) {
          /// add photo
          _image.add(File(pickedFile.path));
        } else {
          /// else print a message
          Flushbar(
            title: 'Be careful',
            titleColor: Colors.pink,
            message: 'you have not selected a photo',
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    } catch (error) {
      Flushbar(
        title: 'Warning',
        titleColor: Colors.redAccent,
        message: error.toString(),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  /// function pick pictures from gallery
  getDocumentFromGallery() async {
    try {
      /// source of method here the source is gallery
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        /// if source is not null
        if (pickedFile != null) {
          /// add image
          _image.add(File(pickedFile.path));
        } else {
          /// else print message
          Flushbar(
            title: 'Be careful',
            titleColor: Colors.pink,
            message: 'you have not selected a image',
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    } catch (error) {
      Flushbar(
        title: 'Warning',
        titleColor: Colors.redAccent,
        message: error.toString(),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  /// function create pdf
  createPdf() async {
    try {
      for (var img in _image) {
        final image = pw.MemoryImage(img.readAsBytesSync());
        pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        }));
      }
    } catch (error) {
      Flushbar(
        title: 'Warning',
        titleColor: Colors.redAccent,
        message: error.toString(),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  /// function save pdf
  savePdf() async {
    try {
      if (Platform.isAndroid) {
        final dir = await getExternalStorageDirectory();
        final file = File('${dir?.path}/${DateTime.now()}.pdf');
        await file.writeAsBytes(await pdf.save());
        Flushbar(
          title: 'Good Job',
          titleColor: Colors.green,
          message: 'Save to $file',
          duration: const Duration(seconds: 3),
        ).show(context);
      } else {
        final dir = await getApplicationSupportDirectory();
        final file = File('${dir.path}/${DateTime.now()}.pdf');
        await file.writeAsBytes(await pdf.save());
        Flushbar(
          title: 'Good Job',
          titleColor: Colors.green,
          message: 'Save to $file',
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    } catch (error) {
      Flushbar(
        title: 'Warning',
        titleColor: Colors.redAccent,
        message: error.toString(),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  /// function delete a photo or image
  _removeFile(index) {
    try {
      if (index <= _image.length - 1) {
        setState(() {
          _image.removeAt(index);
        });
      }
      Flushbar(
        title: 'Good Job',
        titleColor: Colors.green,
        message: 'this photo or image was removed',
        duration: const Duration(seconds: 3),
      ).show(context);
    } catch (error) {
      Flushbar(
        title: 'Warning',
        titleColor: Colors.redAccent,
        message: error.toString(),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }
}
