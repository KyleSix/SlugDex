import 'package:flutter/material.dart';
import 'package:slugdex/screens/DexEntryPage.dart';

class dexEntryView extends StatelessWidget {
  const dexEntryView({required this.entry});
  final dexEntry entry;
  @override
  Widget build(BuildContext context) {
    String date = entry.discoveredDate;
    Color backColor;
    if(entry.rarity == 0) {
      backColor = Colors.purple;
    } else {
      backColor = Colors.amber.shade400;
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
            top: MediaQuery.of(context).size.height / 2.90,
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
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 35, 0, 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Rarity: Legendary", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),),
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
                        child: Text(entry.description, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),),
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
          Positioned(
            top: 10,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Text(entry.name, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w500, color: Colors.white),),
                      ),
                      Container(
                        width: 225.0,
                        height: 225.0,
                        decoration: BoxDecoration(
                            //border: Border.all(color: Colors.black, width: 3.0),
                            //shape: BoxShape.circle,
                            image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(entry.image),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
      ],
    ),
    );
  }
}