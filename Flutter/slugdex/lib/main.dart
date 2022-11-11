import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'Entry/entry.dart';
import 'package:slugdex/provider/LocationProvider.dart';
import 'dart:core';
//Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';//Firebabse Authentication


List<Entry> entryList = []; //Global List of all entries
bool Debug = true;
var db = FirebaseFirestore.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  entryList = await loadEntry();
  runApp(MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => LocationProvider(),
        child: LiveMapScreen(),
      )
    ], child: MaterialApp(title: 'SlugDex', debugShowCheckedModeBanner: false, home: LiveMapScreen()));
  }
}
