import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';

import 'entry.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/db/ManageUserData.dart';

List<int> defaultIds = [1, 5, 10, 15]; //Default Entry IDs given to user

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

//Pull entries from Firebase and create List<Entry> entryList
Future<List<Entry>> loadEntry() async {
  List<Entry> entryList = [];

  await FirebaseFirestore.instance
      .collection('entries')
      .doc('entries')
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> entryData = snapshot.data() as Map<String, dynamic>;
      entryList = List<Entry>.from(
          entryData["entryList"].map((x) => Entry.fromJson(x)));
      ;
      return entryList;
    }
  });

  return entryList;
}

//Create default discovered locations (used for newly created accounts)
void initializeDiscovered(Map<int, dynamic> discoveredEntries) {
  for (int i = 0; i < defaultIds.length; i++) {
    Entry e = Entry.fromUserJson({'ID': defaultIds[i], 'dateDiscovered': setDiscoveredDate()});
    discoveredEntries[defaultIds[i]] = e.toUserJson();
  }
}

//Add the discovered locations to entryList
void populateDiscovered(Map<int, dynamic> discoveredEntries) {
  //print("in populateDiscovered");
  //Future.forEach(entryList, (element) => print('${element.toString()}'));

  //Get all discovered entries in a list
  for (int i = 0; i < entryList.length; i++) {
    if (discoveredEntries.keys.contains(i + 1)) {
      entryList[i].discovered = 1;
      entryList[i].dateDiscovered = discoveredEntries[i + 1]['dateDiscovered'];
    } //end if
  } //end for
}

//Update the entryList to have discovered
void updateEntryListDiscovered(index) {
  entryList[index].discovered = 1;
  entryList[index].dateDiscovered = setDiscoveredDate();
}

//Marks entries as discovered, updating discovery date
//Updates user data file with new discovered locations
void markDiscovered(/*Map<int, dynamic> discoveredEntries,*/ int index) async {
  //Set discovery
  Entry entry = Entry.fromUserJson({'ID': index + 1, 'dateDiscovered': setDiscoveredDate()});
  discoveredEntries[index + 1] = entry.toUserJson();
  updateEntryListDiscovered(index);

  //Load items into into user entry in firebase
  updateUserData(discoveredEntries);
}

Future<String> getUserDataFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path.substring(1);
  String filePath = '$appDocumentsPath/UserData.json';

  return filePath;
}
