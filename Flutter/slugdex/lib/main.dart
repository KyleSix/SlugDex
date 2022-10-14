import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';
import 'package:slugdex/provider/location_provider.dart';
import 'Entry/Entry.dart';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart' show rootBundle;

Future<String> _loadAEntryAsset() async {
  return await rootBundle.loadString('assets\\json\\EntryInput.json');
}

Future<List<Entry>> loadEntry() async {
  String jsonString = await _loadAEntryAsset();
  final json = jsonDecode(jsonString);

  List<Entry> entryList =
      List<Entry>.from(json["entries"].map((x) => Entry.fromJson(x)));

  return entryList;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Entry> entryList = await loadEntry();
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
