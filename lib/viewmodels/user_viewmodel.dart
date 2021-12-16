// ignore_for_file: unused_local_variable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fireshare/models/user.dart' as localUser;
import 'package:fireshare/pages/create_account.dart';
import 'package:fireshare/viewmodels/base_viewmodel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UserViewodel extends BaseViewModel {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final Reference storageRef = FirebaseStorage.instance.ref();
  final usersRef = FirebaseFirestore.instance.collection('users');
  final postsRef = FirebaseFirestore.instance.collection('posts');
  final DateTime timeStamp = DateTime.now();
  late localUser.User currentUser;
  late GoogleSignInAccount currentGoogleUser;
  bool isAuth = false;
  String postId = Uuid().v4();
  late String username;
  late File file;
  handleSignIn() {
    googleSignIn.onCurrentUserChanged.listen((account) async {
      await signIn(account: account);

      await usersRef.doc(currentGoogleUser.id).get().then((value) {
        username = value.data()!['username'];
      });
    }, onError: (err) {
      print('Error signing in: $err');
    });
    signInSilently();
  }

  signInSilently() async {
    await googleSignIn
        .signInSilently(suppressErrors: false)
        .then((account) => signIn(account: account))
        .catchError((err) {
      print('Error signing in: $err');
    });
  }

  createUserInFireStore() async {
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();
    Map<String, dynamic> _docdata = Map();

    if (!doc.exists) {
      final username = await navigationHandler.pushNamed(CreateAccount.id);
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
    currentUser = localUser.User.fromJson(_docdata);
    currentGoogleUser = googleSignIn.currentUser!;
    notifyListeners();
    print(currentGoogleUser);
    print(currentUser.username);
  }

  signIn({GoogleSignInAccount? account}) {
    if (account != null) {
      createUserInFireStore();
      print(account);
      isAuth = true;
      notifyListeners();
    } else {
      isAuth = false;
      notifyListeners();
    }
  }

  logout() {
    googleSignIn.signOut();
  }

  logIn() {
    googleSignIn.signIn();
  }

  compressImage(XFile xFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(await xFile.readAsBytes());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(imageFile!, quality: 85),
      );
    file = compressedImageFile;
    notifyListeners();
  }

  Future<String> uploadImage() async {
    UploadTask uploadTask = storageRef.child('post_$postId.jpg').putFile(file);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  createPost(
      {required String mediaUrl,
      required String caption,
      required String location}) {
    postsRef.doc(currentGoogleUser.id).collection('userPosts').doc(postId).set({
      'postId': postId,
      'ownerId': currentGoogleUser.id,
      'username': username,
      'mediaUrl': mediaUrl,
      'caption': caption,
      'location': location,
      'timestamp': timeStamp,
      'likes': {},
    });
  }

  handlePostUpload(
      {required XFile xFile, String? caption, String? location}) async {
    toggleisUpLoading(true);
    await compressImage(xFile);
    String mediaUrl = await uploadImage();
    createPost(
        mediaUrl: mediaUrl, caption: caption ?? "", location: location ?? "");
    caption = '';
    location = '';
    file = File('');
    notifyListeners();
    toggleisUpLoading(false);
    navigationHandler.goBack();
    print('Success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }
}
