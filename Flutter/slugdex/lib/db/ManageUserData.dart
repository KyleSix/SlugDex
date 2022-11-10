import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? user = FirebaseAuth.instance.currentUser;
String? email = user?.email; //Get the user's email address
String? uid = user?.uid;

Future updateUserData(List<dynamic> discoveredEntries) async {
  print("EMAIL IS $email");
  print("discoveredEntries = ${discoveredEntries.toList()}");

  await FirebaseFirestore.instance.collection('userData').add({
    'email': email,
    'discovered': discoveredEntries.toList(),
  });
}

Future getUserData(String email) async {
  
  print(
      "--------------------------------------------------\n\n\n\n\n\n\n\n\n\n\ninside get userdata");
  await FirebaseFirestore.instance
      .collection('userData')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('User email $email, uid = $uid found in database');
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;
      print("UserData = ${userData.toString()}");
    } else {
      print("User email $email, uid = $uid NOT found in database");
    } //end if else
  });
}
