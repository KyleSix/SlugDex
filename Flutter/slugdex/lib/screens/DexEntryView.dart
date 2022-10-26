import 'package:flutter/material.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';
import 'package:slugdex/Entry/entry.dart';

class dexEntryView extends StatelessWidget {
  const dexEntryView({required this.entry});
  final Entry entry;
  @override
  Widget build(BuildContext context) {
    int entryID =entry.iD!;
    String name = 'Entry $entryID';
    String description = '??????';
    String rarity = '??????';
    String img = 'assets/images/undiscovered.png';
    String date = '??????';
    double trayHeight = MediaQuery.of(context).size.height / 2.90;
    Color backColor = Colors.grey.shade700;
    if(entry.discovered == 1) {
      String filename = entry.getFileName();
      img = 'assets/images/$filename';
      name = entry.name.toString();
      description = entry.description.toString();
      date = entry.dateDiscovered.toString();
      if(entry.rarity == Rarity.MYTHICAL) {
        backColor = Colors.amber.shade400;
        rarity = "Mythical";
      } else if(entry.rarity == Rarity.LEGENDARY){
        backColor = Colors.purple;
        rarity = "Legendary";
      } else if(entry.rarity == Rarity.RARE){
        backColor = Colors.blue;
        rarity = "Rare";
      } else if(entry.rarity == Rarity.UNCOMMON){
        backColor = Colors.green;
        rarity = "Uncommon";
      } else if(entry.rarity == Rarity.COMMON){
        backColor = Colors.grey.shade400;
        rarity = "Common";
      }
    }
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: const Text('SlugDex'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: trayHeight,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: Colors.white,
              ),
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            top: trayHeight-260,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Text(name, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w500, color: Colors.white),),
                        ),
                        Container(
                          width: 225.0,
                          height: 225.0,
                          decoration: BoxDecoration(
                              border: getBorderForImageView(entry),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(img),
                            )
                        ),
                        ),
                      ],
                    ),
                  ),
                ],
            )
          ),
          Positioned(
            top: trayHeight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 35, 0, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Rarity: " + rarity, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Description:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(description, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Discovered: " + date, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _getHintButton(entry, backColor, context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Widget _getHintButton(Entry entry, Color backColor, BuildContext context) {
  if (entry.discovered == 1) {
    return Container();
  } else {
    return FloatingActionButton(
        backgroundColor: backColor,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              // Goes to the LiveMapScreen and removes all previous navigations
              context,
              MaterialPageRoute(
                  builder: (context) => LiveMapScreen(
                        // Pass in the entry ID to move to
                        entryID: entry.iD!,
                      )),
              (Route<dynamic> route) => false);
        },
              child: const Icon(Icons.question_mark, color: Colors.white)
      );
  }
}

Border getBorderForImageView(Entry entry) {
  if(entry.discovered == 1) {
    return Border.all(color: Colors.white, width: 3.0);
  } else {
    return Border.all(color: Colors.transparent, width: 0.0);
  }
}