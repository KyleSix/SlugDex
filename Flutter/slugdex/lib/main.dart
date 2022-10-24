import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';
import 'package:slugdex/provider/location_provider.dart';
import 'Entry/Entry.dart';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart' show rootBundle;

//Load Entry List as a string from Json
Future<String> _loadEntryAsset() async {
  return await rootBundle.loadString('assets/json/EntryInput.json');
}

Future<String> _loadUserAsset() async {
  return await rootBundle.loadString('assets/json/UserData.json');
}

//Create List of entries from the Json string
Future<List<Entry>> loadEntry() async {
  String jsonString = await _loadEntryAsset();
  String userString = await _loadUserAsset();
  final json = jsonDecode(jsonString);
  final userJson = jsonDecode(userString);

  List<Entry> entryList =
      List<Entry>.from(json["entries"].map((x) => Entry.fromJson(x)));

  List<Entry> userList =
      List<Entry>.from(userJson["entries"].map((x) => Entry.fromUserJson(x)));

  for (int i = 0; i < userList.length; i++) {
    entryList[userList[i].iD! - 1].discovered = 1;
    entryList[userList[i].iD! - 1].dateDiscovered = userList[i].dateDiscovered;
  } //end for

  return entryList;
}

List<Entry> entryList = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  entryList = await loadEntry();

  //DEBUGGING - Print entry values
  for (int i = 0; i < entryList.length; i++) {
    print(entryList[i].toString());
  }
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
