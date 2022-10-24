import 'package:intl/intl.dart';

enum Rarity { MYTHICAL, LEGENDARY, RARE, UNCOMMON, COMMON}

/**************************************************************
 * Class to store each location entry
 * ------------------------------------------------------------
 * Notes: 
 * - iD - UNIQUE number assocated with location
 * - discovered - 0 if the entry is undiscovered
 *              - 1 if the entry is discovered
 * - rarity - Uses enum Rarity 
 *************************************************************/

//Read discovered and dateDiscovered attribute from separate file since
//it contains independent user data
class Entry {
  int? iD;
  String? name;
  double? latitude;
  double? longitude;
  String? description;
  int? discovered;
  Rarity? rarity;
  String? dateDiscovered;

  //CONSTRUCTORS
  Entry(
      {this.iD,
      this.name,
      this.latitude,
      this.longitude,
      this.description,
      this.discovered,
      this.rarity,
      this.dateDiscovered});

  factory Entry.fromJson(Map<String, dynamic> parsedJson) {
    return Entry(
        iD: parsedJson['ID'],
        name: parsedJson['name'],
        latitude: parsedJson['latitude'],
        longitude: parsedJson['longitude'],
        description: parsedJson['description'],
        discovered: parsedJson['discovered'],
        rarity: Rarity.values[parsedJson['rarity']],
        dateDiscovered: parsedJson['dateDiscovered']);
  }

  //Print the values of the entry object
  @override
  String toString() {
    StringBuffer entryString = StringBuffer();

    entryString.write("ID:   $iD\n");
    entryString.write("name: $name\n");
    entryString.write("lat:  $latitude\n");
    entryString.write("long: $longitude\n");
    entryString.write("desc: $description\n");
    entryString.write("disc: $discovered\n");
    entryString.write("rare: $rarity\n\n");

    return entryString.toString();
  }

  //Set the date discovered of an entry to current day
  void setDiscoveredDate() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('MM/dd/yyyy');

    dateDiscovered = format.format(now);
  }
}
