import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'entry.dart';

class UserList {
  List<Entry>? userLists = []; //List of user entries
  String? listName = "";

  //Used for color
  var a = 45;
  var r = 233;
  var g = 14;
  var b = 222;

  //============================================================================
  //CONSTRUCTORS
  //============================================================================
  UserList(
      {this.userLists,
      this.listName,
      this.a: 45,
      this.r: 233,
      this.g: 14,
      this.b: 222});

  factory UserList.fromJson(Map<String, dynamic> parsedJson) {
    return UserList(
        listName: parsedJson['listName'],
        a: parsedJson['a'],
        r: parsedJson['r'],
        g: parsedJson['g'],
        b: parsedJson['b']);
  }

  getColor() {
    return new Color.fromARGB(a, r, g, b);
  }

  @override
  String toString() {
    StringBuffer listString = StringBuffer();

    for (int i = 0; i < userLists!.length; i++) {
      listString.write(userLists![i].toString());
    }
    listString.write("listName: $listName\n");
    listString.write(
        "listColor: ${getColor().toString()} == Color($a, $r, $g, $b)\n");

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
Future<UserList> loadUserEntries() async {
  String userString = await _loadUserListAsset();
  final userListJson = jsonDecode(userString);

  print("userString: $userString");
  print("userListJson: $userListJson");

  UserList userList = UserList.fromJson(userListJson);

  userList.userLists =
      List<Entry>.from(userListJson["entries"].map((x) => Entry.fromJson(x)));

  return userList;
}

Future<String> getUserDataFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path.substring(1);
  String filePath = '$appDocumentsPath/UserListDataDefault.json';

  return filePath;
}
