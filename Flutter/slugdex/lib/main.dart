import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'package:slugdex/auth/authPage.dart';
import 'package:slugdex/db/ManageUserData.dart';
import 'Entry/entry.dart';
import 'package:slugdex/provider/LocationProvider.dart';
import 'dart:core';
//Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

List<Entry> entryList = []; //Global ist of all entries
var db = FirebaseFirestore.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  entryList = await loadEntry();

  String? email = FirebaseAuth.instance.currentUser?.email; //Get user email
  getUserData(email.toString());

  runApp(MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LocationProvider(),
            child: checkLogin(),
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SlugDex',
            home: checkLogin()));
  }
}
