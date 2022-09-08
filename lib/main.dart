import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shut_down_flutter/pages/home_page.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
  doWhenWindowReady((){
    var initialSize = const Size(800, 650);
    appWindow.size = initialSize;
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData.dark().copyWith(
          backgroundColor: Color(0xFF121212),
          //colorScheme: ColorScheme.dark().copyWith(primary: darkGreyClr),
          brightness: Brightness.dark,
        primaryColor: kPrimaryColor,
        accentColor: kAccentDarkColor,
        scaffoldBackgroundColor: Color(0xFF0D0C0E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFb7b7b7),
          secondary: kSecondaryDarkColor,
          surface: kSurfaceDarkColor,
        ),
        iconTheme: const IconThemeData(color: kBodyTextColorDark),
        accentIconTheme: const IconThemeData(color: kAccentIconDarkColor),
        primaryIconTheme: const IconThemeData(color: kPrimaryIconDarkColor),
      ),

      home: HomePage(),
    );
  }
}
