import 'package:flutter/material.dart';
import 'DevEntryView.dart';

class dexEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SlugDex'),),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1/1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            ),
            // Sub 10 for: dexEntrys.length or such
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 3.0),
                      color: Colors.yellow.shade700,
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
                              image: const DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                    "https://i.imgur.com/YFoAUPD.jpg")
                                    )
                          )
                        ),
                        //Image.asset(subjects[index].subjectImage, fit: BoxFit.cover, height: 50, width: 50,),
                        const SizedBox(height: 15,),
                        //Sub "Entry name for: dexEntrys[index].entryName or similar"
                        Text("Entry $index", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => dexEntryView()));
                  },
                ),
              );
            }
          ),
        ),
    );
  }
}