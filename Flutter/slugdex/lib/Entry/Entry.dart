enum Rarity { MYTHICAL, LEGENDARY, RARE, UNCOMMON, COMMON, POPULAR }

/**************************************************************
 * Class to store each location entry
 * ------------------------------------------------------------
 * Notes: 
 * - iD - UNIQUE number assocated with location
 * - discovered - 0 if the entry is undiscovered
 *              - 1 if the entry is discovered
 * - rarity - Uses enum Rarity 
 *************************************************************/
class Entry {
  int? iD;
  String? name;
  double? latitude;
  double? longitude;
  String? description;
  int? discovered;
  Rarity? rarity;

  Entry(
      {this.iD,
      this.name,
      this.latitude,
      this.longitude,
      this.description,
      this.discovered,
      this.rarity});

  factory Entry.fromJson(Map<String, dynamic> parsedJson) {
    return Entry(
        iD: parsedJson['ID'],
        name: parsedJson['name'],
        latitude: parsedJson['latitude'],
        longitude: parsedJson['longitude'],
        description: parsedJson['description'],
        discovered: parsedJson['discovered'],
        rarity: Rarity.values[parsedJson['rarity']]);
  }

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
}
