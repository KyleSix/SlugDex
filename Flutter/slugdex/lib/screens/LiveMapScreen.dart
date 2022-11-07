import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/Entry/entry.dart';
import 'package:slugdex/provider/LocationProvider.dart';
import 'package:slugdex/screens/DexEntryPage.dart';
import 'package:slugdex/main.dart';
import "package:slugdex/screens/DexEntryView.dart";
import 'package:slugdex/Entry/entryReadWrite.dart';

final Set<Marker> _markers = new Set();
Set<Circle> _circles = new Set(); // For the hint radii
double _radius = 60.0; // Distance in meters
class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({this.entryID = -1}); // Sentinel value when loading screen not from a hint
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
  } // End widget

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
                      initialCameraPosition: CameraPosition( target: model.locationPosition!, zoom: 18 ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: const MinMaxZoomPreference(16,19),
                      markers: populateClientMarkers(context),
                      circles: populateHintCircles(context),

                      onMapCreated: (controller){
                        setState(() { mapController = controller; });
                        if (id != -1) { navigateHint(id!); } // if we came from an entry hint, let's nav to it
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

  void navigateHint(int id) async { // Animate camera to desired position and zoom
    CameraPosition newPosition = CameraPosition(
      target: LatLng(entryList[id - 1].latitude!, entryList[id - 1].longitude!),
      zoom: 18.0, // change to desired zoom level
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(newPosition));
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
  for (int index = 0; index < entryList.length; ++index) { // Iterates through Global "entryList" from main
    if(entryList[index].discovered != 0) addMarker(index, context); // If user has discovered a target location
  } // Mark that location on the map with a marker
  return _markers;
}

// Clear All Hint Circles : variable _circles is an empty set of type Circle
Set<Circle> clearHintCircles(){ _circles.clear(); return _circles; }

Position ?_currentPosition;
getUserLocation() async { //Use Geolocator to find the current location(latitude & longitude)
  _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

Widget _buildPopupDialog(BuildContext context, _title, _message, thisEntry) {
  return new AlertDialog(
    title: Text(_title),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_message),
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => dexEntryView(entry: thisEntry)));
        },
        child: const Text("Ok"),
      ),
    ],
  );
}

Set<Circle> populateHintCircles(context) {
  _circles = clearHintCircles();
  for (Entry thisEntry in entryList) {
    Color rarityColor = Colors.grey.shade400;
    switch (thisEntry.rarity) {
      case Rarity.MYTHICAL:   rarityColor = Colors.amber.shade400; break;
      case Rarity.LEGENDARY:  rarityColor = Colors.purple; break;
      case Rarity.RARE:       rarityColor = Colors.blue; break;
      case Rarity.UNCOMMON:   rarityColor = Colors.green; break;
      case Rarity.COMMON:     rarityColor = Colors.grey.shade400; break;
      default: break;
    }
    if (thisEntry.discovered == 0) { // if not discovered
      _circles.add(
          Circle(
              circleId: CircleId(thisEntry.iD.toString()), // Entry ID # is the Circle ID
              consumeTapEvents: true,
              fillColor: rarityColor.withOpacity(0.2),
              center: LatLng(thisEntry.latitude!, thisEntry.longitude!),
              radius: _radius, // Radius in Meters
              strokeColor: rarityColor,
              strokeWidth: 1, // Width of outline in screen points
              visible: true, // All circles are hidden by default
              zIndex: 0,
              onTap: () {
                getUserLocation();
                double distance = Geolocator.distanceBetween(_currentPosition!.latitude, _currentPosition!.longitude,
                    thisEntry.latitude!.toDouble(), thisEntry.longitude!.toDouble());

                if( distance <= _radius) { // if user is inside 25 meter radius
                  showDialog(context: context, builder: (BuildContext context) => _buildPopupDialog(context, "A new Discovery! ", "Name: " + thisEntry.name.toString(), thisEntry),);
                  markDiscovered(thisEntry.iD!.toInt() - 1); // Mark Entry List[index] to discovered
                }
              }
          )
      ); // End add(Circle)
    } // End if(Not Discovered)
  } // End For(Each Entry)
  return _circles;
}
