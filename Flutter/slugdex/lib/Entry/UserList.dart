import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'entry.dart';

class UserList {
  List<Entry>? userLists = []; //List of user entries
  String? listName = "";
  Color? listColor = Color(0);

  //============================================================================
  //CONSTRUCTORS
  //============================================================================
  UserList({this.userLists, this.listName, this.listColor});

  factory UserList.fromJson(Map<String, dynamic> parsedJson) {
    return UserList(
        userLists: parsedJson['userLists'],
        listName: parsedJson['listName'],
        listColor: parsedJson['listColor']);
  }

  @override
  String toString() {
    StringBuffer listString = StringBuffer();

    for (int i = 0; i < userLists!.length; i++) {
      listString.write(userLists![i].toString());
    }
    listString.write("listName: $listName\n");
    listString.write("listColor: $listColor\n");

    return listString.toString();
  }
}
  //Load User List Data if it exist, if not create a save file with default entries
  Future<String> _loadUserListAsset() async {
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
          await rootBundle.loadString('assets/json/UserListDataDefault.json'));
      fileContents = await file.readAsString();
    }
    return fileContents;
  }
  
  //Create List of entries from the Json string
  Future<List<Entry>> loadUserEntries() async {
    String userString = await _loadUserListAsset();
    final userListJson = jsonDecode(userString);

    return List<Entry>.from(userListJson["entries"].map((x) => Entry.fromJson(x))); 
  }

  Future<String> getUserDataFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path.substring(1);
    String filePath = '$appDocumentsPath/UserListData.json';

    return filePath;
  }