import 'package:cloud_firestore/cloud_firestore.dart';
import 'entry.dart';
import 'dart:core';
import 'package:slugdex/main.dart';
import 'package:slugdex/db/ManageUserData.dart';

List<int> defaultIds = [1, 5, 10, 15]; //Default Entry IDs given to user
final int DEFAULT_COUNT = defaultIds.length; //Get amount of default IDs

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
void initializeDiscovered() {
  for (int i = 0; i < defaultIds.length; i++) {
    entryList[defaultIds[i] - 1].discovered = 1;
    entryList[defaultIds[i] - 1].dateDiscovered = setDiscoveredDate();
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
void markDiscovered(int index) async {
  //Set discovery
  updateEntryListDiscovered(index);

  //Load items into into user entry in firebase
  updateUserData();

  //Update discovery statistics
  queryUpdateDiscoveredCount(index);
}
