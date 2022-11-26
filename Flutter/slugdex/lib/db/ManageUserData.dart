import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'package:slugdex/main.dart';

//Create user data with:
// - default values
// - entries discovered (0)
// - time they have started playing
Future createUserData() async {
  List<dynamic> discovered = [];
  int entriesDiscovered = 0;
  int timeStartedPlaying = DateTime.now().millisecondsSinceEpoch;

  //Initialize entryList to store default values
  initializeDiscovered();

  //Load discovered entries before storing in firebase
  for (int i = 0; i < entryList.length; i++) {
    if (entryList[i].discovered == 1) {
      discovered.add(entryList[i].toUserJson());
    }
  } //end for

  //Get amount discovered
  entriesDiscovered = discovered.length;

  String? email = FirebaseAuth.instance.currentUser?.email;
  await FirebaseFirestore.instance.collection('userData').doc(email).set({
    'email': email,
    'discovered': discovered.toList(),
    'entriesDiscovered': entriesDiscovered.toInt(),
    'millisecondsPlayed': timeStartedPlaying
  });
}

//Update user data:
// - entries values
// - number of entries discovered (0)
// - time they have started playing
// - average time discovering entries
Future updateUserData() async {
  List<dynamic> discovered = [];
  int entriesDiscovered = 0;

  //Load discovered entries before storing in firebase
  for (int i = 0; i < entryList.length; i++) {
    if (entryList[i].discovered == 1) {
      discovered.add(entryList[i].toUserJson());
    }
  } //end for

  entriesDiscovered =
      discovered.length; //Get number of entries discovered by user

  print('entriesDiscovered = ${entriesDiscovered}');

  String? email =
      FirebaseAuth.instance.currentUser?.email; //Get user's email address

  //Update user data in firebase
  queryUpdateUserData(email, discovered, entriesDiscovered);
}

//Populate entryList to store all user discovered data
void loadUserDiscovered() {
  String? email =
      FirebaseAuth.instance.currentUser?.email; //Get the user's email address
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

//Queries data into 'userData' collection
Future queryUpdateUserData(
    String? email, List<dynamic> discovered, int entriesDiscovered) async {
  await FirebaseFirestore.instance.collection('userData').doc(email).update({
    'email': email,
    'discovered': discovered.toList(),
    'entriesDiscovered': entriesDiscovered
  });
}

//Queries data into 'mostDiscovered' collection
Future queryUpdateDiscovered(String? email, int entriesDiscovered) async {
  await FirebaseFirestore.instance
      .collection('userData')
      .doc(email)
      .update({'entriesDiscovered': entriesDiscovered});
}

/*******************************************************************************
 * GETTERS
 ******************************************************************************/
Future<int> queryGetUserPlayTimeInMillis(String? email) async {
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  int playTime = 0;

  await FirebaseFirestore.instance
      .collection('userData')
      .doc(email)
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      if (userData['millisecondsPlayed'] != null)
        playTime = userData['millisecondsPlayed'];
      else
        return 0;
    }
  });

  return await currentTime - playTime;
}