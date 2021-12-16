import 'package:fireshare/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Set up your profile',
          style: GoogleFonts.pacifico(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 200,
              width: 400,
              child: SvgPicture.asset('assets/images/create_username.svg'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Create a Username',
              style: GoogleFonts.signika(color: Colors.white, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  validator: (val) {
                    if (val!.trim().length < 3) {
                      return 'Nah, too short. Get creative';
                    } else if (val.trim().length > 12) {
                      return "Woah, that's too long";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => username = val,
                  cursorHeight: 25,
                  style: TextStyle(color: Colors.black, fontSize: 22),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 30),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      fillColor: Colors.white,
                      hintText: 'Must be at least 3 characters',
                      hintStyle: TextStyle(fontSize: 16),
                      filled: true),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(milliseconds: 300),
                      backgroundColor: Theme.of(context).accentColor,
                      content: SizedBox(
                        height: 50,
                        child: Text(
                          "Welcome aboard, $username\nThis will be fun!",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  );
                  Navigator.of(context)
                      .popAndPushNamed(Home.id, result: username);
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )),
                fixedSize: MaterialStateProperty.all(Size(140, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
