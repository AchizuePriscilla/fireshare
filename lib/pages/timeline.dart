import 'package:fireshare/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: new CircularProgressIndicator());
              }

              return Container(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Text(
                      data['username'],
                      style: TextStyle(color: Colors.white),
                    );
                  }).toList(),
                ),
              );

              // return new Text(document.["username"]);
            }),
      ),
    );
  }
}
