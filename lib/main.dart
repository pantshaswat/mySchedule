import 'package:flutter/material.dart';
import 'package:myschedule/interfaces/event.dart';
import 'package:myschedule/interfaces/homePage.dart';
import 'package:myschedule/interfaces/loginPage.dart';
import 'package:myschedule/interfaces/registerPage.dart';
import 'package:myschedule/interfaces/welcomePage.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));

  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loginpage(),
    );
  }
}
