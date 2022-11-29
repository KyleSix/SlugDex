import 'package:intl/intl.dart';

enum Rarity { MYTHICAL, LEGENDARY, RARE, UNCOMMON, COMMON }

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
  Rarity? rarity;
  int? discoveredCount = 0;

  //USER DEPENDENT DATA
  int? discovered = 0;
  String? dateDiscovered;

  //============================================================================
  //CONSTRUCTORS
  //============================================================================
  Entry(
      {this.iD,
      this.name,
      this.latitude,
      this.longitude,
      this.description,
      this.rarity,
      this.dateDiscovered,
      this.discoveredCount});

  //Will pull all entry data from Json and create entries
  factory Entry.fromJson(Map<String, dynamic> parsedJson) {
    return Entry(
        iD: parsedJson['ID'].toInt(),
        name: parsedJson['name'],
        latitude: parsedJson['latitude'].toDouble(),
        longitude: parsedJson['longitude'].toDouble(),
        description: parsedJson['description'],
        rarity: Rarity.values[parsedJson['rarity']],
        discoveredCount: parsedJson['discoveredCount'].toInt());
  }

  //Convert entry to json
  Map<String, dynamic> toJson() {
    return {
      "ID": iD,
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
      "description": description,
      "rarity": rarity?.index.toInt(),
      "discoveredCount": discoveredCount?.toInt(),
    };
  }

  //Will pull user data from User data Json
  factory Entry.fromUserJson(Map<String, dynamic> parsedJson) {
    return Entry(
        iD: parsedJson['ID'].toInt(),
        dateDiscovered: parsedJson['dateDiscovered']);
  }

  //Convert Entry data to Json for User Data
  Map<String, dynamic> toUserJson() {
    return {"ID": iD, "dateDiscovered": dateDiscovered};
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
    entryString.write("disc: $discoveredCount\n\n");

    return entryString.toString();
  }

  String getFileName() {
    StringBuffer fileName = StringBuffer();
    fileName.write("$iD.png");
    return fileName.toString();
  }
}

//Set the date discovered of an entry to current day
String setDiscoveredDate() {
  DateTime now = DateTime.now();
  DateFormat format = DateFormat('MM/dd/yyyy');

  return format.format(now).toString();
}
