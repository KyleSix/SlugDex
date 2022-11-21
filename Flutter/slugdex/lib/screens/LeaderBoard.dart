import 'package:flutter/material.dart';

final TAB_COUNT = 4; //Number of tabs in Leaderboard

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
            title: Text('Leader Board'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              TabBar(tabs: [
                EntriesDiscoveredBoard(),
                AverageDiscoveryTimeBoard(),
                DistanceTraveledBoard(),
                RarityBoard()
              ]),
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

Tab EntriesDiscoveredBoard() {
  return Tab(
          icon: Icon(
            Icons.location_city_rounded,
            color: Colors.deepPurple,
          ),
        );
}

Tab AverageDiscoveryTimeBoard() {
  return Tab(
          icon: Icon(
            Icons.timer_sharp,
            color: Colors.deepPurple,
          ),
        );
}

Tab DistanceTraveledBoard() {
  return Tab(
          icon: Icon(
            Icons.nordic_walking,
            color: Colors.deepPurple,
          ),
        );
}

Tab RarityBoard() {
  return Tab(
    icon: Icon(
      Icons.diamond,
      color: Colors.deepPurple,
    ),
  );
}
