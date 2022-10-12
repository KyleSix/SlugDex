import 'package:flutter/material.dart';
import 'package:slugdex/screens/DexEntryPage.dart';

class dexEntryView extends StatelessWidget {
  const dexEntryView({required this.entry});
  final dexEntry entry;
  @override
  Widget build(BuildContext context) {
    String date = entry.discoveredDate;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SlugDex'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                color: Colors.yellow.shade700,
              ),
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height /2.5,
              child: Column(
                children: [
                  Text(entry.name, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w500, color: Colors.white),),
                  Container(
                    width: 225.0,
                    height: 225.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3.0),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(entry.image),
                        )
                    ),
                  ),
                ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Rarity:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),),
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
              child: Text("Discovered: " + date, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),),
            ),
          ),
      ],
    ),
    );
  }
}