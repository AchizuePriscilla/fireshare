import 'package:flutter/material.dart';
import 'package:fireshare/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.teal,
              backgroundColor: Colors.black)
          .copyWith(),
      home: Home(),
    );
  }
}
