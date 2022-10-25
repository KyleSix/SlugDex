import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/Entry/Entry.dart';
import 'package:slugdex/provider/LocationProvider.dart';
import 'package:slugdex/screens/DexEntryPage.dart';
import 'package:slugdex/main.dart';

final Set<Marker> _markers = new Set();

class LiveMapScreen extends StatefulWidget {
  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  late GoogleMapController mapController;

  @override
  void initState() { super.initState();
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
      body: googleMapUI(),
    );
  }

  Widget googleMapUI() { return Consumer<LocationProvider>(
      builder: (consumerContext, model, child) {
        if(model.locationPosition != null) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: CameraPosition(
                          target: model.locationPosition,
                          zoom: 18
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: MinMaxZoomPreference(16,19),
                      //markers: populateAllMarkers(), // Populates all markers to hidden locations
                      markers: populateClientMarkers(), // Populates only client discovered markers
                      onMapCreated: (controller) { setState(() { mapController = controller;});},
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed:() { Navigator.push(context, MaterialPageRoute(builder: (context) => dexEntryPage()));},
                child: const Icon(Icons.menu, color: Colors.black)
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        }
        return Container( child: Center(child: CircularProgressIndicator(),), );
      }
      );
  }
}

void addMarker(intId) {
  double rarityColor = 0.0;
  switch(entryList[intId].rarity) {
    case Rarity.MYTHICAL: rarityColor = BitmapDescriptor.hueYellow; break;
    case Rarity.LEGENDARY: rarityColor = BitmapDescriptor.hueViolet; break;
    case Rarity.RARE: rarityColor = BitmapDescriptor.hueBlue; break;
    case Rarity.UNCOMMON: rarityColor = BitmapDescriptor.hueGreen; break;
    case Rarity.COMMON: rarityColor = BitmapDescriptor.hueOrange; break;
  }
  _markers.add(
      Marker(
          markerId: MarkerId(entryList[intId].iD.toString()),
          position: LatLng(entryList[intId].latitude!, entryList[intId].longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(rarityColor),
          infoWindow: InfoWindow( title: entryList[intId].name )
      )
  );
}

Set<Marker> populateClientMarkers() {
  for (int id = 0; id < entryList.length; ++id) {     // Iterates through the Global "entryList" from main
    if(entryList[id].discovered != 0) addMarker(id);  // If the user has discoverd a target location
  }                                                   // Mark that location on the map with a marker
  return _markers;
}

// Maybe useful for hints to show all markers on the map, I used it for testing
Set<Marker> populateAllMarkers() {
  for (int id = 0; id < entryList.length; ++id) {
      addMarker(id);
  }
  return _markers;
}