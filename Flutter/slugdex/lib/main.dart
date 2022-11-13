import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/auth/authPage.dart';
import 'Entry/entry.dart';
import 'package:slugdex/provider/LocationProvider.dart';
import 'dart:core';
//Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Settings Imports
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as fss; //Naming conflict arose, so use prefix fss

List<Entry> entryList = []; //Global ist of all entries

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
            home: checkLogin()));
  }
}
