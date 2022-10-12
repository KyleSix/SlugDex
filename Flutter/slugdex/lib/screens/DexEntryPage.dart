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

  const dexEntry(this.name, this.description, this.image,this.latitude, this.longitude, this.discovered, this.discoveredDate);
}

isDiscovered(number) {
  if(number % 2 == 0) {
    return true;
  } else {
    return false;
  }
}
// TEMP CODE ===========================================================================================

class dexEntryPage extends StatelessWidget {
  // TEMP CODE ===========================================================================================
  final dexEntries = List.generate(
  30,
  (i) => dexEntry(
    'Entry $i', 
    'Decription for entry $i',
    'https://i.imgur.com/YFoAUPD.jpg', 
    20.2342342, 
    -32.3222332,
    isDiscovered(i),
    "10/11/2022"
  )
  );
  // TEMP CODE ===========================================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SlugDex'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
              Color col;
              String img;
              String entryname;
              if(dexEntries[index].discovered){
                col = Colors.yellow.shade700;
                img = dexEntries[index].image;
                entryname = dexEntries[index].name;
              } else {
                col = Colors.grey;
                img = "https://i.imgur.com/9eaDFaP.png";
                entryname = "Undiscovered";
              }
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade800, width: 3.0),
                      color: col,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 125.0,
                          height: 125.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3.0),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(img),
                              )
                          )
                        ),
                        //Image.asset(subjects[index].subjectImage, fit: BoxFit.cover, height: 50, width: 50,),
                        const SizedBox(height: 15,),
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