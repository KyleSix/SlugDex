import 'package:flutter/material.dart';
import 'package:slugdex/Entry/entry.dart';
import 'DevEntryView.dart';
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
              String img = "https://i.imgur.com/9eaDFaP.png";
              String entryname = "Undiscovered";
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
                img = 'https://i.imgur.com/MbanEeE.png';
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
                            padding: const EdgeInsets.all(2.0),
                            //Change to Image.asset for local
                            child: Image.network(img, width: 125.0, height: 125.0,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
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