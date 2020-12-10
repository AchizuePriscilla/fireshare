import 'package:flutter/material.dart';
import 'package:fireshare/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireShare',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.deepPurple, accentColor: Colors.teal)
              .copyWith(),
      home: Home(),
    );
  }
}
