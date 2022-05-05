import 'dart:io';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:appscan/settingspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';

/// import scan document page
import 'scandocument.dart';

/// import view pdf page
import 'viewpdf.dart';

///apply this class on home: attribute at MaterialApp()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState(); //create state
  }
}

class _HomePageState extends State<HomePage> {
  List<File> files = [];
  final dir = getExternalStorageDirectory();
  // directory for ios
  final dirIOS = getApplicationSupportDirectory();

  ///async function to get list of files
  getFiles() async {
    try {
      if (Platform.isAndroid) {
        try {
          var pathRoot = await dir;
          var filesManager = FileManager(root: pathRoot);
          files = await filesManager.filesTree(
            // filter list only pdf files
              extensions: ["pdf"]);
          // update the ui
          setState(() {});
        } catch (error) {
          Flushbar(
            title: 'Warning',
            message: error.toString(),
            duration: const Duration(seconds: 4),
          ).show(context);
        }
      } else {
        try {
          var pathRoot = await dirIOS;
          var filesManager = FileManager(root: pathRoot);
          files = await filesManager.filesTree(
            // filter list only pdf files
              extensions: ["pdf"]);
          //update the ui
          setState(() {});
        } catch (error) {
          Flushbar(
            title: 'Warning',
            message: error.toString(),
            duration: const Duration(seconds: 4),
          ).show(context);
        }
      }
    } catch (error) {
      Flushbar(
        title: 'Warning',
        message: error.toString(),
        duration: const Duration(seconds: 4),
      ).show(context);
    }
  }

  @override
  void initState() {
    ///call getFiles() function on initial state.
    getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Page"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                "Menu",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
                title: const Text(" -  Settings",
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                })
          ],
        ),
      ),

      /// if files is empty display informative message
      body: Stack(
          children: [
            // if file is empty display text
            (files.isEmpty)
                ? Center(
              child: Text(
                "No file available",
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
                : (files.isEmpty)
                ? const Center(
              child: Text(
                "No folder available",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
            /// if files is not empty, display listView of document scanned
            /// pull down to refresh page
                : ListView.builder(
              ///if file/folder list is grabbed, then show here
              itemCount: files.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                    title: Text(
                      ///display only the file name
                      files[index].path.split('/').last,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    leading: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.blue.shade900,
                      size: 30,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      size: 30,
                      color: Colors.pink.shade900,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            ///open viewPDF page on click
                            return ViewPDF(pathPDF: files[index].path);
                          }));
                    },
                  ),
                );
              },
            ),
          ]
      ),
      /// bottom navigation bar
      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ScanDocument()));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.center_focus_strong,
                size: 29,
              ),
              Text(
                "Scan doc Page",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
