import 'package:flutter/material.dart';
import 'package:slugdex/db/ManageUserData.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:slugdex/main.dart';

class changeProfileImagePage extends StatefulWidget {
  @override
  State<changeProfileImagePage> createState() => _changeProfileImagePageState();
}

class _changeProfileImagePageState extends State<changeProfileImagePage> {
  bool backButtonVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Change Appearance"),
          automaticallyImplyLeading: backButtonVisible,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
            child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Choose Image From Gallery",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    )),
                  ),
                ),
                onTap: () async {
                  pickImageFromGallery();
                }
            ),
            InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Choose Image From Camera",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    )),
                  ),
                ),
                onTap: () async {
                  pickImageFromCamera();
                }
            ),
            getLoadingMessage(),
          ],
        ),
      ),
    )));
  }

  void pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera, imageQuality: 10);

    if(pickedImage != null){
      setState(() {
        backButtonVisible = false;
      });
      final pickedImageFile = File(pickedImage.path);
      profileImageURL = await updateProfileImage(pickedImageFile);
    }

    Navigator.pop(context);
    Navigator.pop(context);
  }

  void pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(pickedImage != null){
      setState(() {
        backButtonVisible = false;
      });
      final pickedImageFile = File(pickedImage.path);
      profileImageURL = await updateProfileImage(pickedImageFile);
    }
    
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget getLoadingMessage() {
    if(backButtonVisible) {
      return Container();
    } else {
      return Text(
        "Uploading Image ...",
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
      );
    }
  }
}