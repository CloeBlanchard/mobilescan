import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:appscan/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyAppearancePage extends StatefulWidget {
  const MyAppearancePage({Key? key}) : super(key: key);

  @override
  _MyAppaerancePageState createState() => _MyAppaerancePageState();
}

class _MyAppaerancePageState extends State<MyAppearancePage>{
  bool darkmode = false;
  dynamic savedThemeMode;
  late String iconAddress;

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Appearance Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              child: iconAddress != null ? Image.asset(iconAddress) : Container(),
            ),
            const Text(
              "Dark Mode",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
                title: const Text("Theme Dark"),
                value: darkmode,
                onChanged: (bool value) {
                  if (value == true) {
                    AdaptiveTheme.of(context).setDark();
                    iconAddress = "assets/images/darkVador.jpg";
                  } else {
                    AdaptiveTheme.of(context).setLight();
                    iconAddress = "assets/images/babyyoda.jpg";
                  }
                  setState(() {
                    darkmode = value;
                  });
                }
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage())
                );
              },
              child: const Icon(Icons.home, color: Colors.white,),
            )
          ],
        ),
      ),
    );
  }

  /// control if theme dark or light
  Future getCurrentTheme() async {
    try {
      savedThemeMode = await AdaptiveTheme.getThemeMode();
      if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
        debugPrint('Theme dark');
        setState(() {
          darkmode = true;
          iconAddress = "assets/images/darkVador.jpg";
        });
        Flushbar(
          title: 'This is $savedThemeMode',
          titleColor: Colors.green,
          message: 'Is your theme',
          duration: const Duration(seconds: 3),
        ).show(context);
      } else {
        debugPrint('Theme light');
        setState(() {
          darkmode = false;
          iconAddress = "assets/images/babyyoda.jpg";
        });
        Flushbar(
          title: 'This is $savedThemeMode',
          titleColor: Colors.green,
          message: 'Is your theme',
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
}