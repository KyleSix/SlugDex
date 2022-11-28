import 'package:flutter/material.dart';
import 'package:slugdex/Entry/entry.dart';
import 'DexEntryView.dart';
import 'package:slugdex/main.dart';

class dexEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int totalDiscovered = 0;
    for (Entry entry in entryList){
      if(entry.discovered == 1) {
        totalDiscovered += 1;
      }
    }
    int totalEntries = entryList.length;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(preferredSize: Size.fromHeight(-16.0), child: AppBar(
        title: const Text('\nMy Discoveries', style: TextStyle(fontSize: 24.0),),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        primary: false,
        elevation: 0,
        flexibleSpace: Column(
              children: <Widget>[
                SizedBox(height: 12.0,),
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
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1/1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                ),
                itemCount: totalEntries,
                itemBuilder: (BuildContext context, int index) {
                  Color boxColor = Colors.grey.shade700;
                  String img = "assets/images/undiscovered.png";
                  int entryID = entryList[index].iD!;
                  String entryname = "$entryID";
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
                                child: Text(entryname, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
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
          Container(
            padding: const EdgeInsets.all(15.0),
            alignment: Alignment.bottomCenter,
            child: Text("Discovered: $totalDiscovered/$totalEntries", 
              style: const TextStyle(
                inherit: true,
                fontSize: 20, 
                fontWeight: FontWeight.w500, 
                color: Colors.white,
                shadows: [
                  Shadow( offset: Offset(-1.5, 1.5), color: Colors.black),
                  Shadow( offset: Offset(1.5, -1.5), color: Colors.black),
                  Shadow( offset: Offset(1.5, 1.5), color: Colors.black),
                  Shadow( offset: Offset(-1.5, -1.5), color: Colors.black),
                ]
              ),
            ),
          ),
        ]
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

Route openDexPage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => dexEntryPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
