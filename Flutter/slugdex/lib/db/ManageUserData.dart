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

  String? email =
      FirebaseAuth.instance.currentUser?.email; //Get user's email address

  //Update user data in firebase
  queryUpdateUserData(email, discovered);
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
//NOTE: this can not be called after the user has discovered all entries since
//If the user has discovered all entries, then their average discovery time does
//Not need to be updated.
Future queryUpdateUserData(String? email, List<dynamic> discovered) async {
  int entriesDiscovered = discovered.length;
  String time = await getAverageDiscoveryTime(email, entriesDiscovered);

  await FirebaseFirestore.instance.collection('userData').doc(email).update({
    'email': email,
    'discovered': discovered.toList(),
    'entriesDiscovered': entriesDiscovered,
    'averageDiscoveryTime': time
  });
}

//Queries data into 'mostDiscovered' collection
Future queryUpdateDiscovered(String? email, int entriesDiscovered) async {
  await FirebaseFirestore.instance
      .collection('userData')
      .doc(email)
      .update({'entriesDiscovered': entriesDiscovered});
}

//Get the discoveredCOunt of an entry and increment it (when a user discovers it)
Future queryUpdateDiscoveredCount(int index) async {
  int discoveredCount = await queryGetDiscoveredCount(index);
  entryList[index].discoveredCount = discoveredCount + 1;

  print('entryList discoverdCount ${entryList[index].discoveredCount}');

  //Create list to overwrite current entryList
  var tempList = [];
  for (int i = 0; i < entryList.length; i++) {
    tempList.add(entryList[i].toJson());
  } //end for

  await FirebaseFirestore.instance
      .collection('entries')
      .doc('entries')
      .update({'entryList': tempList.toList()});
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

//Update the average play time as a string formatted as h:mm:ss
Future<String> getAverageDiscoveryTime(
    String? email, int entriesDiscovered) async {
  int start = 0;
  int end = 7;
  int currentPlayTime = await queryGetUserPlayTimeInMillis(email);

  String time = Duration(milliseconds: (currentPlayTime ~/ entriesDiscovered))
      .toString()
      .substring(start, end);

  return time;
}

//Get the number of people that have discovered an entry
//Used to in displaying the rarity of an entry
Future<int> queryGetDiscoveredCount(int index) async {
  int discoveredCount = 0;

  //Get the discoveredCount of an entry
  //If the discoveredCount is NULL then set it to zero
  await FirebaseFirestore.instance
      .collection('entries')
      .doc('entries')
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> entry = snapshot.data() as Map<String, dynamic>;
      //If NULL, then set to zero

      if (entry['entryList'][index]['discoveredCount'] == null) {
        FirebaseFirestore.instance
            .collection('entries')
            .doc('entries')
            .update({'discoveredCount': 0.toString()});
      } else {
        //Get the discoveredCount
        discoveredCount =
            int.parse(entry['entryList'][index]['discoveredCount'].toString());
      } //end else
    }
  });

  return discoveredCount;
}
