import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';

Future updateUserData(List<dynamic> discoveredEntries) async {
  String? email = FirebaseAuth.instance.currentUser?.email;
  await FirebaseFirestore.instance.collection('userData').doc(email).set({
    'email': email,
    'discovered': discoveredEntries.toList(),
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

Map<String, dynamic> getUserData() {
  User? user = FirebaseAuth.instance.currentUser;
  String? email = user?.email; //Get the user's email address
  String? uid = user?.uid;
  
  FirebaseFirestore.instance
      .collection('userData')
      .doc(email)
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      print('User email $email, uid = $uid found in database');
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      print("UserData = ${userData.toString()}");
    } else {
      print("User email $email, uid = $uid NOT found in database");
    } //end if else
  });

  return userData;
}
