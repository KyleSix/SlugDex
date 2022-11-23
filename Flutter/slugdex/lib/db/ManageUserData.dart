import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slugdex/main.dart';

void createDatabaseForUser() async {
  String? email = FirebaseAuth.instance.currentUser?.email;
  await FirebaseFirestore.instance.collection('userData').doc(email).set({});
}

Future updateUserData() async {
  List<dynamic> discovered = [];

  //Load discovered entries before storing in firebase
  for (int i = 0; i < entryList.length; i++) {
    if (entryList[i].discovered == 1) {
      discovered.add(entryList[i].toUserJson());
    }
  }//end for

  String? email = FirebaseAuth.instance.currentUser?.email;
  await FirebaseFirestore.instance.collection('userData').doc(email).update({
    'email': email,
    'discovered': discovered.toList(),
  });
}

//Populate entryList to store all user discovered data
void loadUserDiscovered() {
  String? email = FirebaseAuth.instance.currentUser?.email; //Get the user's email address
  Map<String, dynamic> userData = {};

  FirebaseFirestore.instance
      .collection('userData')
      .doc(email)
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      userData = snapshot.data() as Map<String, dynamic>;

      for (Map<String, dynamic> element in userData['discovered']) {
        int id = element['ID'];
        String dateDiscovered = element['dateDiscovered'].toString();
        entryList[id - 1].discovered = 1;
        entryList[id - 1].dateDiscovered = dateDiscovered;
      }
    }
  });
}

setDisplayName(newName) async {
  String? email = FirebaseAuth.instance.currentUser?.email; //Get the user's email address
  await FirebaseFirestore.instance.collection('userData').doc(email).update({
    'displayName': newName
  });
  displayName = newName;
}

Future<String> getDisplayName() async {
  String? email = FirebaseAuth.instance.currentUser?.email; //Get the user's email address
  Map<String, dynamic> userData = {};
  String name = 'No Display Name';

  await FirebaseFirestore.instance
      .collection('userData')
      .doc(email)
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      userData = snapshot.data() as Map<String, dynamic>;
      if(userData['displayName'] != null) {
        name = userData['displayName'];
      }
    }
  });
  return name;
}
