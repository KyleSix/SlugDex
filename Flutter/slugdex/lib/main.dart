import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';
import 'package:slugdex/provider/location_provider.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'Entry/entry.dart';
import 'dart:core';

List<Entry> entryList = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  entryList = await loadEntry();

  //DEBUGGING - Print entry values
  //for (int i = 0; i < entryList.length; i++) {
  //  print(entryList[i].toString());
  //}
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
    ], child: MaterialApp(title: 'SlugDex', home: LiveMapScreen()));
  }
}
