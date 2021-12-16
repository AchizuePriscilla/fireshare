import 'dart:io';
import 'package:fireshare/viewmodels/user_viewmodel.dart';
import 'package:fireshare/widgets/custom_app_bar.dart';
import 'package:fireshare/widgets/custom_progress_indicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  ImagePicker picker = ImagePicker();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  XFile? file;

  Widget buildSplashScreen() {
    var userVM = context.watch<UserViewodel>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height * .4,
                child: SvgPicture.asset('assets/images/upload.svg')),
            TextButton(
              onPressed: () async {
                XFile? file = await picker.pickImage(
                    source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
                setState(() {
                  this.file = file;
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )),
                fixedSize: MaterialStateProperty.all(Size(150, 70)),
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              child: Text(
                'Upload a Photo',
                style: TextStyle(color: Colors.white, fontSize: 19),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUploadForm() {
    var userVM = context.read<UserViewodel>();
    var rxUserVM = context.watch<UserViewodel>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(
            "What's up? Make a post",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          actions: [
            InkWell(
              onTap: () async {
                await userVM.handlePostUpload(
                    xFile: file!,
                    caption: captionController.text,
                    location: locationController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Theme.of(context).accentColor,
                    content: SizedBox(
                      height: 50,
                      child: Text(
                        "Post Uploaded\nYou're a fun human!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                );
                setState(() {
                  file = null;
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    'Post',
                    style:
                        TextStyle(color: Colors.deepPurpleAccent, fontSize: 24),
                  ),
                ),
              ),
            )
          ],
          leading: BackButton(
              color: Colors.white,
              onPressed: () {
                setState(() {
                  file = null;
                });
              }),
          toolbarHeight: 80,
          backgroundColor: Colors.black,
          centerTitle: true),
      body: Column(
        children: [
          Visibility(
              visible: userVM.isUploading,
              child: CustomLinearProgressIndicator()),
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                                  File(file!.path),
                                ),
                                fit: BoxFit.cover),
                          ),
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userVM.currentGoogleUser.photoUrl!),
                          backgroundColor: Colors.white,
                          radius: 22,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 5),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 5),
                            ),
                            hintText: 'Write a caption...',
                            enabled: true,
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          controller: captionController,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 22,
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          maxLines: 2,
                          minLines: 1,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 5),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 5),
                            ),
                            hintText: 'Where was this photo taken?',
                            enabled: true,
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          controller: locationController,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                      fixedSize: MaterialStateProperty.all(Size(220, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.my_location, color: Colors.white),
                        Text(
                          'Use Current Location',
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    context.read<UserViewodel>().signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
