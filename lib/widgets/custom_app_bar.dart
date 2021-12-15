import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends AppBar {
  final bool isProfile;
  CustomAppBar({Key? key, this.isProfile = false})
      : super(
            key: key,
            title: Text(
              isProfile ? 'Profile' : 'FireShare',
              style: GoogleFonts.pacifico(
                  color: Colors.white, fontSize: isProfile ? 30 : 50),
            ),
            toolbarHeight: isProfile ? 60 : 80,
            backgroundColor: Colors.black,
            centerTitle: true);
}
