import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String photoUrl;
  final String email;
  final String displayname;
  final String bio;

  User(
      {required this.id,
      required this.username,
      required this.photoUrl,
      required this.email,
      required this.displayname,
      required this.bio});

  User.fromJson(Map<dynamic, dynamic> docdata)
      : this(
          id: docdata['id'] ?? '',
          username: docdata['username'] ?? '',
          photoUrl: docdata['photoUrl'] ?? '',
          email: docdata['email'] ?? '',
          displayname: docdata['displayname'] ?? '',
          bio: docdata['bio'] ?? '',
        );
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'username': username,
      'photoUrl': photoUrl,
      'email': email,
      'displayname': displayname,
      'bio': bio
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: 'id',
        username: 'username',
        photoUrl: 'photoUrl',
        email: 'email',
        displayname: 'displayname',
        bio: 'bio');
  }
}
