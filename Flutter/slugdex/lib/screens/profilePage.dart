import 'package:flutter/material.dart';
import 'package:slugdex/settings/settingsTools.dart';
import 'package:slugdex/screens/settingsPage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slugdex/Entry/entry.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/screens/LeaderBoard.dart';

const double icon_size = 24.0;

Color textColor = Colors.black;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int totalDiscovered = 0;
  int totalEntries = entryList.length;
  double headerSpace = 220;
  double pokeballSpace = 460;

  double panelHeightOpen = 0, panelHeightClosed = 0;
  double max_pokeballScale = 800, min_pokeballScale = 1;
  double pokeballScale = 800;
  double max_pokeballOffset = -60, min_pokeballOffset = 0;
  double pokeballOffset = -60;
  double max_pokeFontSize = 18, min_pokeFontSize = 1;
  double pokeFontSize = 18.0;
  
  String displayNameState = displayName;
  Widget profilePicState = profilePic();
  String userEmail = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    totalDiscovered = 0;
    for (Entry entry in entryList) {
      if (entry.discovered == 1) {
        totalDiscovered += 1;
      }
    }
    panelHeightClosed = MediaQuery.of(context).size.height - pokeballSpace;
    panelHeightOpen = MediaQuery.of(context).size.height - headerSpace;
    min_pokeballOffset = MediaQuery.of(context).size.height / 2;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
      ),
      backgroundColor: slugdex_yellow,
      ////////// Sliding Panel //////////
      body: SlidingUpPanel(
        body: buildBody(), // the widget behind the sliding panel
        panel: LeaderBoard(), // the widget that the sliding panel holds
        backdropColor: Colors.black,
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpen,
        defaultPanelState: PanelState.CLOSED,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
        onPanelSlide: (double pos) => setState(() {
          double heightRange = 1 - 0;
          double pokeScaleRange = min_pokeballScale - max_pokeballScale;
          pokeballScale =
              (pos * pokeScaleRange) / heightRange + max_pokeballScale;
          double pokeOffsetRange = min_pokeballOffset - max_pokeballOffset;
          pokeballOffset =
              (pos * pokeOffsetRange) / heightRange + max_pokeballOffset;
          double pokeFontRange = min_pokeFontSize - max_pokeFontSize;
          pokeFontSize = (pos * pokeFontRange) / heightRange + max_pokeFontSize;
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.settings,
          color: textColor,
        ),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SettingsPage()));
          setState(() {
            displayNameState = displayName;
            profilePicState = new profilePic();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget buildBody() => Container(
          child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: pokeballOffset,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.catching_pokemon,
                    color: Colors.white,
                    size: pokeballScale,
                  ),
                  Text("$totalDiscovered / $totalEntries",
                      textScaleFactor: 2.0,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: pokeFontSize,
                      )),
                ],
              )),
          Positioned(
            top: 80.0,
            left: 16.0,
            child: Hero(
                tag: 'ProfileBtn',
                child: Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(120)),
                    child: profilePicState)),
          ),
          Positioned(
              top: 110.0,
              left: 160.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayNameState,
                          textScaleFactor: 2.0,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor)),
                    Text(userEmail,
                        textScaleFactor: 1.0,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: textColor)),
                  ])),
          Align(
            alignment: Alignment.bottomCenter,
          )
        ],
      ));

  Widget buildPanel() => Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Column(children: [Text("Leaderboards")]));
}
