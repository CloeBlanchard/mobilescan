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
          // if _image is empty display text
          (_image.isEmpty)
              ? const Center(
            child: Text(
              "No image or photo ready to scan",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
          // else _image is not empty, so display image in the body page
              : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // scrolling effects
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                // custom scroll effects
                SliverPadding(
                  padding: const EdgeInsets.all(3.0),
                  sliver: SliverGrid.count(
                      childAspectRatio: 10.0 / 9.0,
                      mainAxisSpacing: 1, //horizontal space
                      crossAxisSpacing: 1, //vertical space
                      crossAxisCount: 3, //number of images for a row
                      children: _image
                      // create _image array
                          .map((image) => Hero(
                        tag: image.path,
                        child: Stack(
                          children: [
                            // get file _image
                            Image.file(
                              image,
                              height: 150,
                              width: MediaQuery.of(context).size.width / 3,
                              fit: BoxFit.cover,
                            ),
                            // displays an icon when an image appears
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
                                )
                            ),
                          ],
                        ),
                      ))
                      // add to a list
                          .toList()),
                ),
              ],
            ),
          ),
          Positioned(
            height: 80,
            bottom: 2 + MediaQuery.of(context).padding.bottom,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width - 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if _image is not empty display a button pdf converter
                  if (_image.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        createPdf();
                        savePdf();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()
                            )
                        );
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
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => getDocumentFromCamera(),
              child: SizedBox(
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.add_a_photo,
                      size: 29,
                    ),
                    Text(
                      "add photo camera",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => getDocumentFromGallery(),
              child: SizedBox(
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.image,
                      size: 29,
                    ),
                    Text(
                      "add photo gallery",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// function take photo from camera
  getDocumentFromCamera() async {
    try {
      // source of method here the source is camera
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        // if source is not null
        if (pickedFile != null) {
          // add photo
          _image.add(File(pickedFile.path));
        } else {
          // else print a message
          Flushbar(
            title: 'Be careful',
            message: 'you have not selected a photo',
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    }
    catch (error) {
      Flushbar(
        title: 'Warning',
        message: error.toString(),
        duration: const Duration(seconds: 4),
      ).show(context);
    }
  }

  /// function pick pictures from gallery
  getDocumentFromGallery() async {
    try {
      // source of method here the source is gallery
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        // if source is not null
        if (pickedFile != null) {
          // add image
          _image.add(File(pickedFile.path));
        } else {
          // else print message
          Flushbar(
            title: 'Be careful',
            message: 'you have not selected a image',
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    } catch (error) {
      Flushbar(
        title: 'Warning',
        message: error.toString(),
        duration: const Duration(seconds: 4),
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
        message: error.toString(),
        duration: const Duration(seconds: 4),
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
          message: 'Save to $file',
          duration: const Duration(seconds: 20),
        ).show(context);
      } else {
        final dir = await getApplicationSupportDirectory();
        final file = File('${dir.path}/${DateTime.now()}.pdf');
        await file.writeAsBytes(await pdf.save());
        print(dir);
        Flushbar(
          title: 'Good Job',
          message: 'Save to $file',
          duration: const Duration(seconds: 20),
        ).show(context);
      }
    } catch (error) {
      Flushbar(
        title: 'Warning',
        message: error.toString(),
        duration: const Duration(seconds: 4),
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
        message: 'this photo or image was removed',
        duration: const Duration(seconds: 4),
      ).show(context);
    } catch (error) {
      Flushbar(
        title: 'Warning',
        message: error.toString(),
        duration: const Duration(seconds: 4),
      ).show(context);
    }
  }

}