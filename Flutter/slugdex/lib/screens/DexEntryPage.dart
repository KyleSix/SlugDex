import 'dart:ffi';
import 'package:flutter/material.dart';
import 'DevEntryView.dart';

// TEMP CODE ===========================================================================================
class dexEntry {
  final String name;
  final String description;
  final String image;
  final double latitude;
  final double longitude;
  final bool discovered;
  final String discoveredDate;
  final int rarity;

  const dexEntry(this.name, this.description, this.image,this.latitude, this.longitude, this.discovered, this.discoveredDate, this.rarity);
}

isDiscovered(number) {
  if(number % 2 == 0) {
    return true;
  } else {
    return false;
  }
}
imagecheck(number) {
  if(number % 3 == 0) {
    return 'https://i.imgur.com/qB48Y6V.png';
  } else {
    return 'https://i.imgur.com/MbanEeE.png';
  }
}
getRarity(number) {
  if(number % 3 == 0) {
    return 0;
  } else {
    return 1;
  }
}
// TEMP CODE ===========================================================================================

class dexEntryPage extends StatelessWidget {
  // TEMP CODE ===========================================================================================
  final dexEntries = List.generate(
  30,
  (i) => dexEntry(
    'Entry $i', 
    'Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i Decription for entry $i ',
    imagecheck(i), 
    20.2342342, 
    -32.3222332,
    isDiscovered(i),
    "10/11/2022",
    getRarity(i)
  )
  );
  // TEMP CODE ===========================================================================================
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
            itemCount: dexEntries.length,
            itemBuilder: (BuildContext context, int index) {
              Color boxColor;
              String img;
              String entryname;
              if(dexEntries[index].discovered){
                if(dexEntries[index].rarity == 0) {
                  boxColor = Colors.purple;
                } else {
                  boxColor = Colors.amber.shade400;
                }
                img = dexEntries[index].image;
                entryname = dexEntries[index].name;
              } else {
                boxColor = Colors.grey;
                img = "https://i.imgur.com/9eaDFaP.png";
                entryname = "Undiscovered";
              }
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: boxColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 125.0,
                          height: 125.0,
                          decoration: BoxDecoration(
                              //border: Border.all(color: Colors.white, width: 3.0),
                              //shape: BoxShape.circle,
                              image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(img),
                              )
                          )
                        ),
                        //Image.asset(subjects[index].subjectImage, fit: BoxFit.cover, height: 50, width: 50,),
                        //Sub "Entry name for: dexEntrys[index].entryName or similar"
                        Text(entryname, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
                      ],
                    ),
                  ),
                  onTap: () {
                    if(dexEntries[index].discovered) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => dexEntryView(entry: dexEntries[index])));
                    } 
                  },
                ),
              );
            }
          ),
        ),
    );
  }
}