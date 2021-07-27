import 'package:bloc/bloc.dart';
import 'package:electric_meter/shared/bloc_observer.dart';
import 'package:flutter/material.dart';

import 'modules/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Colors.indigo,

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        /*textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),*/
      ),
      debugShowCheckedModeBanner: false,
      home:HomeLayout(),
    );
  }
}
