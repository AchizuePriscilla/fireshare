import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireshare/models/user.dart';
import 'package:fireshare/pages/activity_feed.dart';
import 'package:fireshare/pages/create_account.dart';
import 'package:fireshare/pages/profile.dart';
import 'package:fireshare/pages/search.dart';
import 'package:fireshare/pages/timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fireshare/config.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users')
// .withConverter(
//       fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!),
//       toFirestore: (user, _) => user.toJson(),
//     )
    ;
final DateTime timeStamp = DateTime.now();
User? currentUser;

class Home extends StatefulWidget {
  static const String id = 'home-page';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account: account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    googleSignIn
        .signInSilently(suppressErrors: false)
        .then((account) => handleSignIn(account: account))
        .catchError((err) {
      print('Error signing in: $err');
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  createUserInFireStore() async {
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();
    Map<String, dynamic> _docdata = Map();

    if (!doc.exists) {
      final username = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return CreateAccount();
        }),
      );
      usersRef.doc(user.id).set({
        'id': user.id,
        'username': username,
        'photoUrl': user.photoUrl,
        'displayName': user.displayName,
        'email': user.email,
        'bio': '',
        'timeStamp': timeStamp
      });
      print('User created');
      doc = await usersRef.doc(user.id).get();
      _docdata = doc.data() as Map<String, dynamic>;
    }
    currentUser = User.fromJson(_docdata);
    print(currentUser);
    print(currentUser!.username);
  }

  handleSignIn({GoogleSignInAccount? account}) {
    if (account != null) {
      createUserInFireStore();
      print(account);
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;
  logout() {
    googleSignIn.signOut();
  }

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
          Center(
            child: TextButton(
              onPressed: () => googleSignIn.signOut(),
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
