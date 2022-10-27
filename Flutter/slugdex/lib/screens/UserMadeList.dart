import 'package:flutter/material.dart';
import 'package:slugdex/Entry/entry.dart';
import 'DexEntryView.dart';
import 'package:slugdex/main.dart';

List<Entry> userList = [
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 10.0,
      longitude: 22.2,
      description: "uuhhh idk",
      rarity: Rarity.COMMON,
      discovered: 1),
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 11.1,
      longitude: 55.5,
      description: "might know",
      rarity: Rarity.MYTHICAL,
      discovered: 1),
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 65.0,
      longitude: 5.2,
      description: "description",
      rarity: Rarity.LEGENDARY,
      discovered: 1),
];

List<Entry> userList2 = [
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 10.0,
      longitude: 22.2,
      description: "uuhhh idk",
      rarity: Rarity.COMMON,
      discovered: 1),
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 11.1,
      longitude: 55.5,
      description: "might know",
      rarity: Rarity.MYTHICAL,
      discovered: 1),
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 65.0,
      longitude: 5.2,
      description: "description",
      rarity: Rarity.LEGENDARY,
      discovered: 1),
];

List<Entry> userList3 = [
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 10.0,
      longitude: 22.2,
      description: "uuhhh idk",
      rarity: Rarity.COMMON,
      discovered: 1),
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 11.1,
      longitude: 55.5,
      description: "might know",
      rarity: Rarity.MYTHICAL,
      discovered: 1),
  Entry(
      iD: 1,
      name: "The Squiggle",
      latitude: 65.0,
      longitude: 5.2,
      description: "description",
      rarity: Rarity.LEGENDARY,
      discovered: 1),
];

List<List<Entry>> listOfLists = [userList, userList2, userList3];

class UserMadeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Lists'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              Color boxColor = Colors.grey.shade700;
              String img = "assets/images/undiscovered.png";
              int entryID = userList[index].iD!;

              String entryname = userList[index].name.toString();
              if (userList[index].discovered == 1) {
                if (userList[index].rarity == Rarity.MYTHICAL) {
                  boxColor = Colors.amber.shade400;
                } else if (userList[index].rarity == Rarity.LEGENDARY) {
                  boxColor = Colors.purple;
                } else if (userList[index].rarity == Rarity.RARE) {
                  boxColor = Colors.blue;
                } else if (userList[index].rarity == Rarity.UNCOMMON) {
                  boxColor = Colors.green;
                } else if (userList[index].rarity == Rarity.COMMON) {
                  boxColor = Colors.grey.shade400;
                }
                //Replace with entry image
                String filename = userList[index].getFileName();
                img = 'assets/images/$filename';
                entryname = userList[index].name.toString();
              }
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: boxColor,
                    ),
                    child: FittedBox(
                      //fit: BoxFit.fill,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                  width: 20.0,
                                  height: 1.0,
                                  decoration: BoxDecoration(
                                      border: getBorderForImagePage(
                                          userList[index]),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(img),
                                      )))),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 1.0),
                            child: Text(
                              entryname,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                dexEntryView(entry: userList[index])));
                  },
                ),
              );
            }),
      ),
    );
  }
}

Border getBorderForImagePage(Entry entry) {
  if (entry.discovered == 1) {
    return Border.all(color: Colors.white, width: 3.0);
  } else {
    return Border.all(color: Colors.transparent, width: 0.0);
  }
}
