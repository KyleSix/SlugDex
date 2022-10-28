import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/Entry/entry.dart';
import 'package:slugdex/provider/LocationProvider.dart';
import 'package:slugdex/screens/DexEntryPage.dart';
import 'package:slugdex/main.dart';
import "package:slugdex/screens/DexEntryView.dart";

final Set<Marker> _markers = new Set();
final Set<Circle> _circles = new Set(); // For the hint radii
double HINT_RADIUS = 25; // In Meters

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen(
      {this.entryID =
          -1}); // Sentinel value when loading screen not from a hint
  final int entryID;
  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  late GoogleMapController mapController;
  int? id;
  @override
  void initState() {
    id = widget.entryID; // set id member to class parameter
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  @override Widget build(BuildContext context) {
    return Scaffold( extendBodyBehindAppBar: true,
      appBar: AppBar( title: const Text("SlugDex",
          style: TextStyle( inherit: true,
              shadows: [
                Shadow( offset: Offset(-1.5, 1.5), color: Colors.black),
                Shadow( offset: Offset(1.5, -1.5), color: Colors.black),
                Shadow( offset: Offset(1.5, 1.5), color: Colors.black),
                Shadow( offset: Offset(-1.5, -1.5), color: Colors.black),
              ]
          )
      ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: googleMapUI(context),
    );
  }

  Widget googleMapUI(context) { return Consumer<LocationProvider>(
      builder: (consumerContext, model, child) {
        if(model.locationPosition != null){
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                          target: model.locationPosition!,
                          zoom: 18
                      ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                      minMaxZoomPreference: const MinMaxZoomPreference(16,19),
                    markers: populateClientMarkers(context),
                    circles: populateHintCircles(),
                      onMapCreated: (controller){
                      setState(() {
                        mapController = controller;
                      });
                      if (id != -1) {
                        // if we came from an entry hint, let's nav to it
                        navigateHint(id!);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed:() {Navigator.of(context).push(openDexPage());},
                child: const Icon(Icons.menu, color: Colors.black)
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        }
        return const Center(child: CircularProgressIndicator(color: Colors.black,),);
      }
  );
  }

  void navigateHint(int id) async {
    // is async so camera animation doesn't block
    // Animate camera to desired position and zoom
    CameraPosition newPosition = CameraPosition(
      target: LatLng(entryList[id - 1].latitude!, entryList[id - 1].longitude!),
      zoom: 18.0, // change to desired zoom level
    );

    //await Future.delayed(Duration(milliseconds: 500)); // Waits before moving camera.
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        newPosition)); // There's no longer an animation duration :(
  }
}

void addMarker(index,context) {
  double rarityColor = 0.0;
  switch(entryList[index].rarity!) {
    case Rarity.MYTHICAL: rarityColor = BitmapDescriptor.hueYellow; break;
    case Rarity.LEGENDARY: rarityColor = BitmapDescriptor.hueViolet; break;
    case Rarity.RARE: rarityColor = BitmapDescriptor.hueBlue; break;
    case Rarity.UNCOMMON: rarityColor = BitmapDescriptor.hueGreen; break;
    case Rarity.COMMON: rarityColor = BitmapDescriptor.hueOrange; break;
    default: break;
  }
  _markers.add(
      Marker(
          markerId: MarkerId(entryList[index].iD.toString()),
          position: LatLng(entryList[index].latitude!, entryList[index].longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(rarityColor),
          infoWindow: InfoWindow( title: entryList[index].name ),
          onTap:() { // On tap marker, opens its Dex Entry
            Navigator.push(context, MaterialPageRoute(builder: (context) => dexEntryView(entry: entryList[index])));
          }
      )
  );
}

Set<Marker> populateClientMarkers(context) {
  for (int index = 0; index < entryList.length; ++index) {     // Iterates through the Global "entryList" from main
    if(entryList[index].discovered != 0) addMarker(index, context);  // If the user has discoverd a target location
  }                                                   // Mark that location on the map with a marker
  return _markers;
}

// Maybe useful for hints to show all markers on the map, I used it for testing
Set<Marker> populateAllMarkers(context) {
  for (int index = 0; index < entryList.length; ++index) {
    addMarker(index, context);
  }
  return _markers;
}

Set<Circle> populateHintCircles() {
  for (Entry entry in entryList) {
    Color rarityColor = Colors.grey.shade400;
    switch (entry.rarity) {
      case Rarity.MYTHICAL:
        rarityColor = Colors.amber.shade400;
        break;
      case Rarity.LEGENDARY:
        rarityColor = Colors.purple;
        break;
      case Rarity.RARE:
        rarityColor = Colors.blue;
        break;
      case Rarity.UNCOMMON:
        rarityColor = Colors.green;
        break;
      case Rarity.COMMON:
        rarityColor = Colors.grey.shade400;
        break;
      default:
        break;
    }
    if (entry.discovered == 0) {
      _circles.add(Circle(
          circleId:
              CircleId(entry.iD.toString()), // Entry ID # is the Circle ID
          consumeTapEvents: true,
          fillColor: rarityColor.withOpacity(0.2),
          center: LatLng(entry.latitude!, entry.longitude!),
          radius: HINT_RADIUS, // Radius in Meters
          strokeColor: rarityColor,
          strokeWidth: 1, // Width of outline in screen points
          visible: true, // All circles are hidden by default
          zIndex: 0,
          onTap: () {
            // Check if in user is inside radius and mark as discovered
            print("Hi from hint " + entry.iD.toString());
            // _circles.removeWhere((element) => element.circleId == (CircleId(entry.iD.toString())));
          }));
    }
  }
  return _circles;
}