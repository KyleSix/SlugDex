import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';

Future updateUserData() async {
  List<dynamic> discovered = [];

  //Load discovered entries before storing in firebase
  for (int i = 0; i < entryList.length; i++) {
    if (entryList[i].discovered == 1) {
      discovered.add(entryList[i].toUserJson());
    }
  }//end for
  
  String? email = FirebaseAuth.instance.currentUser?.email;
  await FirebaseFirestore.instance.collection('userData').doc(email).set({
    'email': email,
    'discovered': discovered.toList(),
  });
}

Future<List<String>> getDocIds() async {
  List<String> docIDs = [];
  await FirebaseFirestore.instance
      .collection('userData')
      .get()
      .then((snapshot) => snapshot.docs.forEach((document) {
            print("element = ${document.reference}");
            docIDs.add(document.reference.id);
          }));
  return docIDs;
}

void loadUserDiscovered() {
  User? user = FirebaseAuth.instance.currentUser;
  String? email = user?.email; //Get the user's email address
  String? uid = user?.uid;
  Map<String, dynamic> userData = {};

  FirebaseFirestore.instance
      .collection('userData')
      .doc(email)
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      userData = snapshot.data() as Map<String, dynamic>;

      for (Map<String, dynamic> element in userData['discovered']) {
        print("element = ${element['ID'].toString()}");
        print("element = ${element['dateDiscovered'].toString()}");
        int id = element['ID'];
        String dateDiscovered = element['dateDiscovered'].toString();
        entryList[id - 1].discovered = 1;
        entryList[id - 1].dateDiscovered = dateDiscovered;
      }
    }
  });
}
