import 'package:flutter/material.dart';
import 'package:slugdex/Entry/entry.dart';
import 'DexEntryView.dart';
import 'package:slugdex/main.dart';

class dexEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SlugDex'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1/1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            ),
            itemCount: entryList.length,
            itemBuilder: (BuildContext context, int index) {
              Color boxColor = Colors.grey.shade700;
              String img = "assets/images/undiscovered.png";
              int entryID = entryList[index].iD!;
              String entryname = "Entry $entryID";
              if(entryList[index].discovered == 1){
                if(entryList[index].rarity == Rarity.MYTHICAL) {
                  boxColor = Colors.amber.shade400;
                } else if(entryList[index].rarity == Rarity.LEGENDARY){
                  boxColor = Colors.purple;
                } else if(entryList[index].rarity == Rarity.RARE){
                  boxColor = Colors.blue;
                } else if(entryList[index].rarity == Rarity.UNCOMMON){
                  boxColor = Colors.green;
                } else if(entryList[index].rarity == Rarity.COMMON){
                  boxColor = Colors.grey.shade400;
                }
                //Replace with entry image
                String filename = entryList[index].getFileName();
                img = 'assets/images/$filename';
                entryname = entryList[index].name.toString();
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
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 125.0,
                              height: 125.0,
                              decoration: BoxDecoration(
                                border: getBorderForImagePage(entryList[index]),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(img),
                                )
                              )
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
                            child: Text(entryname, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => dexEntryView(entry: entryList[index])));
                  },
                ),
              );
            }
          ),
        ),
    );
  }
}

Border getBorderForImagePage(Entry entry) {
  if(entry.discovered == 1) {
    return Border.all(color: Colors.white, width: 3.0);
  } else {
    return Border.all(color: Colors.transparent, width: 0.0);
  }
}
