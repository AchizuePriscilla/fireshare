import 'package:fireshare/viewmodels/user_viewmodel.dart';
import 'package:fireshare/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var userVM = context.read<UserViewodel>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        isProfile: true,
      ),
      body: Center(
        child: TextButton(
          onPressed: () => userVM.logout(),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            )),
            fixedSize: MaterialStateProperty.all(Size(140, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
          ),
          child: Text(
            'Log Out',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
