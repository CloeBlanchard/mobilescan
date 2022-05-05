import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'apparence.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings Page"),
        ),
        /// button to modify appearance
        body: Stack(
          children: [
            Positioned(
              height: 80,
              top: 2 + MediaQuery.of(context).padding.top,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const MyAppearancePage()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                                Icons.edit,
                                size: 29
                            ),
                            Text(
                              "Modify Appearance",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        )
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
