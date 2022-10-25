import 'entry.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

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

void markDiscovered(entryList, i) {
  entryList[i].discovered = 1;
  //Write to JSON
}