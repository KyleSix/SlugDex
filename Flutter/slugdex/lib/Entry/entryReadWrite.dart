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

//Load User Data if it exist, if not create a save file with default entries
Future<String> _loadUserAsset() async {
  File file = File(await getUserDataFilePath());
  String fileContents;

  //Create user data file if it does not exist
  //If an exception is thrown, catch and create user data file
  try {
    fileContents = await file.readAsString();
  } catch (_) {
    File(await getUserDataFilePath()).create();
    file = File(await getUserDataFilePath());
    file.writeAsString(
        await rootBundle.loadString('assets/json/UserDataDefault.json'));
    fileContents = await file.readAsString();
  }
  return fileContents;
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

void markDiscovered(entryList, i) async {
  entryList[i].discovered = 1;
  entryList[i].setDiscoveredDate();

  List<dynamic> discovered = [];

  //Store in JSON
  for (int index = 0; index < entryList.length; index++) {
    if (entryList[index].discovered == 1) {
      discovered.add(entryList[index].toUserJson());
    } //end for
  } //end for

  Map<String, dynamic> toEncode = {'entries': discovered};
  String entryJson = jsonEncode(toEncode);

  print(entryJson);

  File file = File(await getUserDataFilePath());
  file.writeAsString(entryJson);
}

Future<String> getUserDataFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path.substring(1);
  String filePath = '$appDocumentsPath/UserData.json';

  return filePath;
}
