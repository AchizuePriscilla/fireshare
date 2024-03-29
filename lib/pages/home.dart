import 'package:fireshare/pages/activity_feed.dart';
import 'package:fireshare/pages/profile.dart';
import 'package:fireshare/pages/search.dart';
import 'package:fireshare/pages/timeline.dart';
import 'package:fireshare/pages/upload.dart';
import 'package:fireshare/viewmodels/user_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fireshare/config.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String id = 'home-page';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<UserViewodel>().handleSignIn();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  late PageController pageController;
  int pageIndex = 0;

  onPageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  Widget buildAuthScreen() {
  
    return Scaffold(
      body: PageView(
        children: [
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: CupertinoTabBar(
          border: Border.all(width: 0, color: Colors.black),
          backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 38,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
            ),
          ],
          currentIndex: pageIndex,
          onTap: (index) {
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget buildUnAuthScreen() {
    var userVM = context.read<UserViewodel>();
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
                    fontSize: SizeConfig.blockSizeVertical! * 10.0,
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
                          fit: BoxFit.fill)),
                ),
                onTap: () => userVM.logIn(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userVM = context.watch<UserViewodel>();
    SizeConfig().init(context);
    return userVM.isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
