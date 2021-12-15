import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 5,
        valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
      ),
    );
  }
}

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: LinearProgressIndicator(
        minHeight: 5,
        valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
      ),
    );
  }
}
