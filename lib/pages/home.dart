import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fireshare/config.dart';
import 'package:fireshare/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        print(account);
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    }, onError: (err) {
      print('error signing in: $err');
    });
  }

  bool isAuth = false;

  Widget buildAuthScreen() {
    return Text('Authorized');
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor,
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'FireShare',
                style: GoogleFonts.pacifico(
                    fontSize: SizeConfig.blockSizeVertical * 10.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w200),
              ),
              GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height / 11,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/google_signin_button.png'),
                          fit: BoxFit.cover)),
                ),
                onTap: () => login(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}

void login() {
  googleSignIn.signIn();
}
