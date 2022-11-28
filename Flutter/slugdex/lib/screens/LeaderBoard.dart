import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'package:slugdex/db/ManageUserData.dart';

final int TAB_COUNT = 3; //Number of tabs in Leaderboard
final int MAX_PER_LEADERBOARD =
    20; //Max number of players allowed to display on leaderboard

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: TAB_COUNT,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Leaderboards'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              TabBar(tabs: [
                EntriesDiscoveredTab(),
                AverageDiscoveryTimeTab(),
                RarityTab()
              ]),
              Expanded(
                child: TabBarView(children: [
                  EntriesDiscoveredBoard(),
                  AverageDiscoveryTimeBoard(),
                  RarityBoard()
                ]),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'ReloadLeaderBoardsButton',
            backgroundColor: Colors.orange,
            child: const Icon(Icons.refresh),
            onPressed: (() {}),
          ),
        ));
  }
}

//*****************************************
//Used to display the tabs of each Leader board
//*****************************************/
Tab EntriesDiscoveredTab() {
  return Tab(
    icon: Icon(
      Icons.location_city_rounded,
      color: Colors.deepPurple,
    ),
  );
}

Tab AverageDiscoveryTimeTab() {
  return Tab(
    icon: Icon(
      Icons.timer_sharp,
      color: Colors.deepPurple,
    ),
  );
}

Tab RarityTab() {
  return Tab(
    icon: Icon(
      Icons.diamond,
      color: Colors.deepPurple,
    ),
  );
}

//**********************************
//This is where the displays in the tabs are created
//**********************************/
Scaffold EntriesDiscoveredBoard() {
  //Query for userData > entriesDiscovered.
  //Data is only grabbed if entriesDiscovered > # Default locations given.
  //Max number of items grabbed defined at top of file.
  Query collectionReference = FirebaseFirestore.instance
      .collection("userData")
      .where('entriesDiscovered', isGreaterThan: DEFAULT_COUNT)
      .orderBy('entriesDiscovered', descending: true)
      .limit(MAX_PER_LEADERBOARD);

  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Most Entries Discovered",
        style: TextStyle(fontSize: 20),
      ),
      centerTitle: true,
      elevation: 0.0,
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxHeight: 550, maxWidth: double.infinity),
                child: StreamBuilder<QuerySnapshot>(
                  stream: collectionReference.snapshots(),
                  builder: (context, snapshot) {
                    //Check if the snapshot has been received
                    //If the connection is waiting then load,
                    //Else return a list view
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.separated(
                            itemCount: snapshot.data!.docs
                                .length, //Length of Items grabbed from DB
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              //Grab data as a Map
                              var data = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                              return ListTile(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/logo.png')),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(data['email'])
                                  ],
                                ),
                                //Print leaderboard placement
                                leading: Text(
                                  "#${index + 1}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                //Print number of entries discovered
                                trailing: Text(
                                    "${data['entriesDiscovered'].toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              thickness: 1,
                              color: Colors.purple,
                              indent: 10,
                              endIndent: 10,
                            ),
                          );
                  },
                )),
          )
        ],
      ),
    ),
  );
}

Scaffold AverageDiscoveryTimeBoard() {
  //Query for userData > entriesDiscovered.
  //Data is only grabbed if entriesDiscovered > # Default locations given.
  //Max number of items grabbed defined at top of file.
  Query collectionReference = FirebaseFirestore.instance
      .collection("userData")
      .where('entriesDiscovered', isGreaterThan: DEFAULT_COUNT)
      .orderBy('entriesDiscovered', descending: true)
      .limit(MAX_PER_LEADERBOARD);

  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Average Discovery Time",
        style: TextStyle(fontSize: 20),
      ),
      centerTitle: true,
      elevation: 0.0,
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxHeight: 550, maxWidth: double.infinity),
                child: StreamBuilder<QuerySnapshot>(
                  stream: collectionReference.snapshots(),
                  builder: (context, snapshot) {
                    //Check if the snapshot has been received
                    //If the connection is waiting then load,
                    //Else return a list view
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.separated(
                            itemCount: snapshot.data!.docs
                                .length, //Length of Items grabbed from DB
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              //Grab data as a Map
                              var data = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                              return ListTile(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/logo.png')),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(data['email'])
                                  ],
                                ),
                                //Print leaderboard placement
                                leading: Text(
                                  "#${index + 1}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                //Print number of entries discovered
                                trailing: Text(
                                    "${data['entriesDiscovered'].toString()}\t${data['averageDiscoveryTime'].toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              thickness: 1,
                              color: Colors.purple,
                              indent: 10,
                              endIndent: 10,
                            ),
                          );
                  },
                )),
          )
        ],
      ),
    ),
  );
}

//List the discovery percentages of all users
Scaffold RarityBoard() {
  //Query for userData > entriesDiscovered.
  //Data is only grabbed if entriesDiscovered > # Default locations given.
  //Max number of items grabbed defined at top of file.
  Query collectionReference = FirebaseFirestore.instance
      .collection("userData")
      .where('entriesDiscovered', isGreaterThan: DEFAULT_COUNT)
      .orderBy('entriesDiscovered', descending: true)
      .limit(MAX_PER_LEADERBOARD);

  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Average Discovery Time",
        style: TextStyle(fontSize: 20),
      ),
      centerTitle: true,
      elevation: 0.0,
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxHeight: 550, maxWidth: double.infinity),
                child: StreamBuilder<QuerySnapshot>(
                  stream: collectionReference.snapshots(),
                  builder: (context, snapshot) {
                    //Check if the snapshot has been received
                    //If the connection is waiting then load,
                    //Else return a list view
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.separated(
                            itemCount: snapshot.data!.docs
                                .length, //Length of Items grabbed from DB
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              //Grab data as a Map
                              var data = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                              return ListTile(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/logo.png')),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(data['email'])
                                  ],
                                ),
                                //Print leaderboard placement
                                leading: Text(
                                  "#${index + 1}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                //Print number of entries discovered
                                trailing: Text(
                                    "${data['entriesDiscovered'].toString()}\t${data['averageDiscoveryTime'].toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              thickness: 1,
                              color: Colors.purple,
                              indent: 10,
                              endIndent: 10,
                            ),
                          );
                  },
                )),
          )
        ],
      ),
    ),
  );
}
