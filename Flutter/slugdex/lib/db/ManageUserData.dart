import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final user = FirebaseAuth.instance.currentUser;
final email = user?.email; //Get the user's email address

Future updateUserData(List<dynamic> discoveredEntries) async {
  print("EMAIL IS $email");
  print("discoveredEntries = ${discoveredEntries.toList()}");

  await FirebaseFirestore.instance.collection('userData').add({
    'email': email,
    'discovered': discoveredEntries.toList(),
  });
}
