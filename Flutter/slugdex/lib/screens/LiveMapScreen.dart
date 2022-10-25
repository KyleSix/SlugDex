import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/provider/location_provider.dart';
import 'package:slugdex/screens/DexEntryPage.dart';
import 'package:slugdex/main.dart';

var clientDiscoveredMarkersList = [];
final Set<Marker> _markers = new Set();
final Set<Circle> _circles = new Set(); // For the hint radii

class LiveMapScreen extends StatefulWidget {
  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  late GoogleMapController mapController;
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("SlugDex", style: TextStyle(
            inherit: true,
            shadows: [
              Shadow(
                  offset: Offset(-1.5, 1.5),
                  color: Colors.black
              ),
              Shadow(
                  offset: Offset(1.5, -1.5),
                  color: Colors.black
              ),
              Shadow(
                  offset: Offset(1.5, 1.5),
                  color: Colors.black
              ),
              Shadow(
                  offset: Offset(-1.5, -1.5),
                  color: Colors.black
              ),
            ]
        )),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: googleMapUI(),
    );
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(
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
                      markers: populateClientMarkers(),
                      circles: populateHintCircles(),
                      onMapCreated: (controller){
                        setState(() {
                          mapController = controller;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => dexEntryPage()));
              },
              child: const Icon(Icons.menu, color: Colors.black)
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        }
        return Container(
          child: Center(child: CircularProgressIndicator(),),
        );
      }
    );
  }

  void showHint(int id) async { // Function is async so camera animation doesn't block
    //mapController.moveCamera(CameraUpdate.newLatLng(LatLng(entryList[id].latitude!, entryList[id].longitude!)))

    // Animate camera to desired position and location
    newPosition = CameraPosition(
      target: LatLng(entryList[id].latitude!, entryList[id].longitude!),
      zoom: 18, // change to desired zoom level
    );
    moveDuration = 200; // in milliseconds

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(newPosition), // Camera position, zoom and tilt 
      moveDuration,                                // Animation duration 
      showHintRadius(id)                           // Callback when animation is finished
    );
  }
  void showHintRadius(int id) {
    //Un-hide desired circle
  }
}

Set<Circle> populateHintCircles() {
  // Circle({required CircleId circleId, 
  // bool consumeTapEvents = false, 
  // Color fillColor = Colors.transparent, 
  // LatLng center = const LatLng(0.0, 0.0), 
  // double radius = 0, 
  // Color strokeColor = Colors.black, 
  // int strokeWidth = 10, 
  // bool visible = true, 
  // int zIndex = 0, 
  // VoidCallback? onTap});
}



void addMarker(i){
  _markers.add(
      Marker(
          markerId: MarkerId(entryList[i].iD.toString()),
          position: LatLng(entryList[i].latitude!, entryList[i].longitude!),
          // TODO Change bitmapdescriptor color of marker by agreed rarity color later
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
              title: entryList[i].name
          )
      )
  );
}

Set<Marker> populateClientMarkers() {
  for (int i = 0; i < entryList.length; ++i) {
    if(entryList[i].discovered != 0){
      clientDiscoveredMarkersList.add(entryList[i]);
      addMarker(i);
    }
  }
  return _markers;
}