import 'package:flutter/material.dart';
import 'package:slugdex/Entry/Entry.dart';

class dexEntryView extends StatelessWidget {
  const dexEntryView({required this.entry});
  final Entry entry;
  @override
  Widget build(BuildContext context) {
    String name = '??????';
    String description = '??????';
    String rarity = '??????';
    String img = 'https://i.imgur.com/9eaDFaP.png';
    String date = '??????';
    double trayHeight = MediaQuery.of(context).size.height / 2.90;
    Color backColor = Colors.grey.shade700;
    if(entry.discovered == 1) {
      img = 'https://i.imgur.com/MbanEeE.png';
      name = entry.name.toString();
      description = entry.description.toString();
      date = "10/22/2022";
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
                            //border: Border.all(color: Colors.black, width: 3.0),
                            //shape: BoxShape.circle,
                            image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(img),
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
      floatingActionButton: _getHintButton(entry, backColor),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Widget _getHintButton(Entry entry, Color backColor) {
  if(entry.discovered == 1) {
    return Container();
  } else {
    return FloatingActionButton(
              backgroundColor: backColor,
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => dexEntryPage()));
              },
              child: const Icon(Icons.question_mark, color: Colors.white)
      );
  }
}