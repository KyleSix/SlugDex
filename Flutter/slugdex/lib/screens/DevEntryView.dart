import 'package:flutter/material.dart';

class dexEntryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SlugDex'),),
      body: Center(
        child: Column(
          children: const <Widget> [
            Text(
              "Entry", 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 50),),
          ],
          ),
      ),
    );
  }
}