import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'homepage.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget colorizeText = SplashScreenView(
      navigateRoute: const HomePage(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "assets/images/images.jpg",
      text: "MobileScan",
      textType: TextType.ColorizeAnimationText,
      textStyle: const TextStyle(fontSize: 40),
      colors: [
        Colors.purple.shade700,
        Colors.blue.shade900,
        Colors.purple.shade700,
        Colors.blue.shade900,
      ],
      backgroundColor: Colors.black,
    );
    return AdaptiveTheme(
      ///Light theme mode
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade700,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.pink.shade900,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.pink.shade900,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.pink.shade900),
          ),
        ),
      ),
      ///Dark theme mode
      dark: ThemeData(
        brightness: Brightness.dark,
        toggleableActiveColor: Colors.pink,
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black54,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black26,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black26,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
          ),
        ),
        drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.black54
        ),

      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) =>
          MaterialApp(
            builder: (context, widget) => ResponsiveWrapper.builder(
                ClampingScrollWrapper.builder(context, widget!),
                breakpoints: []
            ),
            title: 'flutter theme dark',
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: darkTheme,
            home: colorizeText,
          ),
    );
  }
}