import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireshare/viewmodels/user_viewmodel.dart';
import 'package:fireshare/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Widget buildNoContent() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SvgPicture.asset('assets/images/search.svg'),
          ),
        ),
        Text(
          'Find Users',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Stream<QuerySnapshot>? searchResultsStream;

  buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
        stream: searchResultsStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          // List<Text> searchResults = [];

          // snapshot.data!.docs.forEach((doc) {
          //   User user = User.fromDocument(doc);
          //   setState(() {
          //     searchResults.add(Text(
          //       user.username,
          //       style: TextStyle(color: Colors.white, fontSize: 20),
          //     ));
          //   });
          //   print('Username: ${user.username}');
          // });

          return Expanded(
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
                  height: 90,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color(0xff262939),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(data['photoUrl']),
                        radius: 30,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['displayName'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            data['username'],
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var userVM = context.watch<UserViewodel>();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBar(),
        body: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    searchResultsStream = userVM.usersRef
                        .where('displayName', isGreaterThanOrEqualTo: val)
                        .snapshots();
                  });
                },
                controller: searchController,
                cursorHeight: 25,
                style: TextStyle(color: Colors.black, fontSize: 19),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.deepPurple, width: 30),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    hintText: 'Explore; search for a User',
                    hintStyle: TextStyle(fontSize: 16),
                    prefixIcon: Icon(
                      Icons.account_circle,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
                    filled: true),
              ),
            ),
            searchResultsStream == null
                ? Expanded(child: buildNoContent())
                : buildSearchResults()
          ],
        ));
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}
