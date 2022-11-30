import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slugdex/Entry/entry.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'package:slugdex/db/ManageUserData.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/settings/settingsTools.dart';

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
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(-16.0),
            child: AppBar(
              title: Text('\nLeaderboard'),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              centerTitle: true,
              automaticallyImplyLeading: false,
              primary: false,
              elevation: 0,
              flexibleSpace: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .25,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              TabBar(
                  indicator: BoxDecoration(
                      color: slugdex_yellow,
                      borderRadius: BorderRadius.circular(20)),
                  indicatorColor: slugdex_yellow,
                  tabs: [
                    EntriesDiscoveredTab(),
                    AverageDiscoveryTimeTab(),
                    RarityTab()
                  ]),
              Expanded(
                child: TabBarView(children: [
                  EntriesDiscoveredBoard(),
                  AverageDiscoveryTimeBoard(context),
                  RarityBoard()
                ]),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            heroTag: 'ReloadLeaderBoardsButton',
            backgroundColor: slugdex_yellow,
            child: const Icon(Icons.refresh),
            onPressed: (() {
              queryRefreshDiscoveredCountAll();
            }),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
        ));
  }

  //**********************************
  //This is where the displays in the tabs are created
  //**********************************/
  Widget EntriesDiscoveredBoard() {
    //Query for userData > entriesDiscovered.
    //Data is only grabbed if entriesDiscovered > # Default locations given.
    //Max number of items grabbed defined at top of file.
    Query collectionReference = FirebaseFirestore.instance
        .collection("userData")
        .where('entriesDiscovered', isGreaterThan: DEFAULT_COUNT)
        .orderBy('entriesDiscovered', descending: true)
        .limit(MAX_PER_LEADERBOARD);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Text("Most Entries Discovered",
              textScaleFactor: 2.0,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(24)),
            margin: EdgeInsets.all(20),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .40,
                    maxWidth: double.infinity),
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
                              late final Future myFuture =
                                  getOtherProfileImage(data['email']);
                              return FutureBuilder(
                                  future: myFuture,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    return ListTile(
                                      minLeadingWidth: 16,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 6.0, horizontal: 24.0),
                                      title: Row(
                                        children: [
                                          CircleAvatar(
                                          foregroundImage: snapshot.data,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Text(
                                            data['displayName'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                        ],
                                      ),
                                      //Print leaderboard placement
                                      leading: Text(
                                        "${index + 1}",
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      //Print number of entries discovered
                                      trailing: Text(
                                          "${data['entriesDiscovered'].toString().padLeft(3, '0')}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    );
                                  });
                            },
                            separatorBuilder: (context, index) => Divider(
                              height: 8,
                              thickness: 1,
                              color: Colors.black,
                              endIndent: 10,
                              indent: 10,
                            ),
                          );
                  },
                )),
          )
        ],
      ),
    );
  }

  Widget AverageDiscoveryTimeBoard(BuildContext context) {
    //Query for userData > entriesDiscovered.
    //Data is only grabbed if entriesDiscovered > # Default locations given.
    //Max number of items grabbed defined at top of file.
    Query collectionReference = FirebaseFirestore.instance
        .collection("userData")
        .where('entriesDiscovered', isGreaterThan: DEFAULT_COUNT)
        .orderBy('entriesDiscovered', descending: true)
        .limit(MAX_PER_LEADERBOARD);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Text("Average Discovery Time",
              textScaleFactor: 2.0,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(24)),
            margin: EdgeInsets.all(20),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .40,
                    maxWidth: double.infinity),
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
                              late final Future myFuture =
                                  getOtherProfileImage(data['email']);
                              return FutureBuilder(
                                future: myFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  return ListTile(
                                    minLeadingWidth: 16,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 24.0),
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          foregroundImage: snapshot.data,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                            child: Text(
                                          data['displayName'].toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    ),
                                    //Print leaderboard placement
                                    leading: Text(
                                      "${index + 1}",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                    //Print number of entries discovered
                                    trailing: Text(
                                        "${data['entriesDiscovered'].toString()}\t${data['averageDiscoveryTime'].toString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  );
                                },
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              height: 8,
                              thickness: 1,
                              color: Colors.black,
                              endIndent: 10,
                              indent: 10,
                            ),
                          );
                  },
                )),
          )
        ],
      ),
    );
  }

  //List the discovery percentages of all users
  Widget RarityBoard() {
    //Get the list data
    List<Entry> list = entryList.toList();

    list.sort(((a, b) => a.discoveredCount!.compareTo(b.discoveredCount!)));

    int playerCount = 1;

    //Get the number of players
    FirebaseFirestore.instance
        .collection('entries')
        .doc('playerCount')
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> playerCountMap =
            snapshot.data() as Map<String, dynamic>;
        playerCount = int.parse(playerCountMap['playerCount'].toString());
      }
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Text("Entry Rarity",
              textScaleFactor: 2.0,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(24)),
            margin: EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .40,
                  maxWidth: double.infinity),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String title = list[index].discovered == 1
                        ? list[index].name.toString()
                        : '???';
                    num percentage = playerCount == 0
                        ? 0.0
                        : (list[index].discoveredCount! / playerCount * 100);

                    
                    return 
                    (playerCount == 1) 
                    ? Center(child: CircularProgressIndicator(),)
                    : ListTile(
                      minLeadingWidth: 16,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
                      title: Row(
                        children: [
                          CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/${list[index].iD}.png')),
                          SizedBox(
                            width: 12,
                          ),
                          Text(title)
                        ],
                      ),
                      leading: Text(
                        "${index + 1}",
                        textScaleFactor: 1.5,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      trailing: Text("${percentage.toStringAsFixed(1)}%",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        height: 8,
                        thickness: 1,
                        color: Colors.black,
                        endIndent: 10,
                        indent: 10,
                      ),
                  itemCount: list.length),
            ),
          )
        ],
      ),
    );
  }
}

//*****************************************
//Used to display the tabs of each Leader board
//*****************************************/
Tab EntriesDiscoveredTab() {
  return Tab(
    icon: Icon(
      Icons.location_city_rounded,
      color: Colors.black,
    ),
  );
}

Tab AverageDiscoveryTimeTab() {
  return Tab(
    icon: Icon(
      Icons.timer_sharp,
      color: Colors.black,
    ),
  );
}

Tab RarityTab() {
  return Tab(
    icon: Icon(
      Icons.diamond,
      color: Colors.black,
    ),
  );
}
