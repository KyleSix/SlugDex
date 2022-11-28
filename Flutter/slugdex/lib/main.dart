import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/auth/authPage.dart';
import 'Entry/entry.dart';
import 'package:slugdex/provider/LocationProvider.dart';
import 'dart:core';
import 'package:slugdex/db/ManageUserData.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';

//Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Settings Imports
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as fss; //Naming conflict arose, so use prefix fss

List<Entry> entryList = []; //Global List of all entries
bool Debug = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? email = FirebaseAuth.instance.currentUser?.email;
  if (email != null) {
    entryList = await loadEntry();

    loadUserDiscovered();
  } //end if

  print("milliseconds = ${await queryGetUserPlayTimeInMillis(FirebaseAuth.instance.currentUser?.email)}");

  // Initialize the settings plugin
  await fss.Settings.init();

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
            home: checkLogin(),
            theme: ThemeData(primarySwatch: Colors.deepPurple)));
  }
}
