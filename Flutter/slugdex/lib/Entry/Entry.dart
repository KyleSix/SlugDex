import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';

enum Rarity { ULTRA_RARE, RARE, UNCOMMON, COMMON, POPULAR }

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

    entryString.write("ID:   ${this.iD}\n");
    entryString.write("name: ${this.name}\n");
    entryString.write("lat:  ${this.latitude}\n");
    entryString.write("long: ${this.longitude}\n");
    entryString.write("desc: ${this.description}\n");
    entryString.write("disc: ${this.discovered}\n");
    entryString.write("rare: ${this.rarity}\n\n");

    return entryString.toString();
  }
}
