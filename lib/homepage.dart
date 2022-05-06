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
      /// menu burger
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
      body: RefreshIndicator(
        /// function to refresh the page
          onRefresh: () {
            return Future.delayed(
                const Duration(seconds: 3),
                    () {
                  setState(() {
                    files.add(getFiles());
                  });
                }
            );
          },
        child: Stack(
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
              /// files is not empty so display files information
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
                          /// dress page
                          leading: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.blue.shade800,
                            size: 30,
                          ),
                          /// remove button
                          trailing: IconButton(
                            icon: Icon(Icons.delete_forever, size: 30, color: Colors.pink.shade800,),
                            onPressed: () {
                              _onDelete(File(files[index].path));
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                            },
                          ),
                          /// tap to access of pdf document
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
      ),
      /// bottom navigation bar
      bottomNavigationBar: Row(
        children: <Widget>[
          /// adaptive button to access at page scanning
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanDocument())
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.center_focus_strong,
                      size: 29,
                    ),
                    Text(
                      "Scan you doc",
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
            titleColor: Colors.redAccent,
            message: error.toString(),
            duration: const Duration(seconds: 3),
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
            titleColor: Colors.redAccent,
            message: error.toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
        }
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

  /// function who delete file
  Future<void> _onDelete(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        setState(() {

        });
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
}
