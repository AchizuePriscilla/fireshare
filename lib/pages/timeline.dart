import 'package:fireshare/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
    );
  }
}
