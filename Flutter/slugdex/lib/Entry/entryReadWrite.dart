import 'entry.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/db/ManageUserData.dart';

//Load Entry List as a string from Json
Future<String> _loadEntryAsset() async {
  return await rootBundle.loadString('assets/json/EntryInput.json');
}

//Load User Data if it exist, if not create a save file with default entries
// Future<String> _loadUserAsset() async {
//   File file = File(await getUserDataFilePath());
//   String fileContents;

//   //Create user data file if it does not exist
//   //If an exception is thrown, catch and create user data file
//   try {
//     fileContents = await file.readAsString();
//   } catch (_) {
//     File(await getUserDataFilePath()).create();
//     file = File(await getUserDataFilePath());
//     file.writeAsString(
//         await rootBundle.loadString('assets/json/UserDataDefault.json'));
//     fileContents = await file.readAsString();
//   }
//   return fileContents;
// }

//Create default list of

//Create List of entries from the Json string
Future<List<Entry>> loadEntry() async {
  List<Entry> entryList = [];

  return entryList;
}

List<dynamic> populateDiscovered() {
  List<dynamic> discoveredEntries = [];
  //Get all discovered entries in a list
  for (int i = 0; i < entryList.length; i++) {
    if (entryList[i].discovered == 1) {
      discoveredEntries.add(entryList[i].toUserJson());
    } //end if
  } //end for
  return discoveredEntries;
}

//Update the entryList to have discovered
void updateEntryListDiscovered(index) {
  entryList[index].discovered = 1;
  entryList[index].setDiscoveredDate();
}

//Marks entries as discovered, updating discovery date
//Updates user data file with new discovered locations
void markDiscovered(index) async {
  //Set discovery
  updateEntryListDiscovered(index);

  List<dynamic> discoveredEntries = populateDiscovered();
  //Load items into into user entry in firebase
  updateUserData(discoveredEntries);
}

Future<String> getUserDataFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path.substring(1);
  String filePath = '$appDocumentsPath/UserData.json';

  return filePath;
}
