import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/Entry/entry.dart';
import 'package:slugdex/provider/LocationProvider.dart';
import 'package:slugdex/main.dart';
import "package:slugdex/screens/DexEntryView.dart";
import 'package:slugdex/screens/Animations.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'DexEntryPage.dart';
import 'package:slugdex/screens/settingsPage.dart';
import 'package:slugdex/settings/settingsTools.dart';
import 'package:slugdex/db/ManageUserData.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

final Set<Marker> _markers = new Set();
Set<Circle> _circles = new Set(); // For the hint radii
double _radius = 25.0; // Distance in meters

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

  final double _initFabHeight = 80.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0; // calculated later
  double _panelHeightClosed = 72.0;

  @override
  void initState() {
    id = widget.entryID; // set id member to class parameter
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen =
        MediaQuery.of(context).size.height * .8; // 80% of the total height

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: logo,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(MediaQuery.of(context).size.width, 64.0),
          ))),
      body: Stack(alignment: Alignment.topCenter, children: <Widget>[
        SlidingUpPanel(
          backdropColor: Colors.black,
          minHeight: _panelHeightClosed, // in pixels, 10% of total height
          maxHeight: _panelHeightOpen,
          body: googleMapUI(context),
          panel: dexEntryPage(),
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          defaultPanelState: PanelState.CLOSED,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          onPanelSlide: (double pos) => setState(() {
            _fabHeight =
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
          }),
        ),
        Positioned(
          left: 20.0,
          bottom: _fabHeight,
          child: FloatingActionButton(
            mini: true,
            heroTag: "GPSBtn",
            child: Icon(
              Icons.gps_fixed,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              var _currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
              mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
                      zoom: await mapController.getZoomLevel()
                      )));
            },
            backgroundColor: Colors.white,
          ),
        ),
        Positioned(
          right: 20.0,
          bottom: _fabHeight,
          child: _buildProfileFAB(context),
        ),
      ]),
    );
  } // End widget

  Widget googleMapUI(context) {
    return Consumer<LocationProvider>(builder: (consumerContext, model, child) {
      if (model.locationPosition != null) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                        target: model.locationPosition!, zoom: 18),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    minMaxZoomPreference: const MinMaxZoomPreference(16, 19),
                    markers: populateClientMarkers(context),
                    circles: populateHintCircles(context),
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                      if (id != -1) {
                        navigateHint(id!);
                      } // if we came from an entry hint, let's nav to it
                    },
                  ),
                )
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton.extended(
          //     heroTag: "DexViewBtn",
          //     backgroundColor: Colors.white,
          //     onPressed: () {
          //       Navigator.of(context).push(openDexPage());
          //     },
          //     label: Row(
          //       children: [Icon(Icons.catching_pokemon, color: Colors.black)],
          //     )),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
        );
      }
      return Center(
        child: LoadingScreen(),
      );
    });
  }

  void navigateHint(int id) async {
    // Animate camera to desired position and zoom
    CameraPosition newPosition = CameraPosition(
      target: LatLng(entryList[id - 1].latitude!, entryList[id - 1].longitude!),
      zoom: 18.0, // change to desired zoom level
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }
}

void addMarker(index, context) {
  double rarityColor = 0.0;
  switch (entryList[index].rarity!) {
    case Rarity.MYTHICAL:
      rarityColor = BitmapDescriptor.hueYellow;
      break;
    case Rarity.LEGENDARY:
      rarityColor = BitmapDescriptor.hueViolet;
      break;
    case Rarity.RARE:
      rarityColor = BitmapDescriptor.hueBlue;
      break;
    case Rarity.UNCOMMON:
      rarityColor = BitmapDescriptor.hueGreen;
      break;
    case Rarity.COMMON:
      rarityColor = BitmapDescriptor.hueOrange;
      break;
    default:
      break;
  }
  _markers.add(Marker(
      markerId: MarkerId(entryList[index].iD.toString()),
      position: LatLng(entryList[index].latitude!, entryList[index].longitude!),
      icon: BitmapDescriptor.defaultMarkerWithHue(rarityColor),
      infoWindow: InfoWindow(title: entryList[index].name),
      onTap: () {
        // On tap marker, opens its Dex Entry
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dexEntryView(entry: entryList[index])));
      }));
}

Set<Marker> populateClientMarkers(context) {
  for (int index = 0; index < entryList.length; ++index) {
    // Iterates through Global "entryList" from main
    if (entryList[index].discovered != 0)
      addMarker(index, context); // If user has discovered a target location
  } // Mark that location on the map with a marker
  return _markers;
}

// Clear All Hint Circles : variable _circles is an empty set of type Circle
Set<Circle> clearHintCircles() {
  _circles.clear();
  return _circles;
}

Position? _currentPosition;
getUserLocation() async {
  //Use Geo locator to find the current location(latitude & longitude)
  _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => dexEntryView(entry: thisEntry)));
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
    if (thisEntry.discovered == 0) {
      // if not discovered
      _circles.add(Circle(
          circleId:
              CircleId(thisEntry.iD.toString()), // Entry ID # is the Circle ID
          consumeTapEvents: true,
          fillColor: rarityColor.withOpacity(0.2),
          center: LatLng(thisEntry.latitude!, thisEntry.longitude!),
          radius: _radius, // Radius in Meters
          strokeColor: rarityColor,
          strokeWidth: 1, // Width of outline in screen points
          visible: true, // All circles are hidden by default
          zIndex: 0,
          onTap: () {
            getUserLocation(); // Sets _currentPosition variables lat / lng members to current position lat / lng
            double distance = Geolocator.distanceBetween(
                _currentPosition?.latitude ?? 0,
                _currentPosition?.longitude ?? 0,
                thisEntry.latitude!.toDouble(),
                thisEntry.longitude!.toDouble());

            bool? Debug =
                Settings.getValue<bool>("key-dev-mode", defaultValue: false);
            if (distance <= _radius || Debug == true) {
              /////// Note debug check here
              // if user is inside 25 meter radius or debug mode
              markDiscovered(thisEntry.iD!.toInt() -
                  1); // Mark Entry List[index] to discovered

              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    dexEntryView(entry: thisEntry),
              );
              showDialog(
                context: context,
                builder: (BuildContext context) => DiscoveryAnimation(),
              );
            } else {
              // User is not in range, so let's tell them
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Try getting closer..."),
                    duration: const Duration(milliseconds: 2000)),
              );
            }
          })); // End add(Circle)
    } // End if(Not Discovered)
  } // End For(Each Entry)
  return _circles;
}

Widget _buildProfileFAB(context) => Container(
  height: 80.0,
  width: 80.0,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.white, width: 2),
    borderRadius: BorderRadius.circular(120)
  ),
  child: FloatingActionButton(
      heroTag: "SettingsBtn",
      backgroundColor: Color.fromRGBO(255, 255, 255, .0),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingsPage()));
      },
      child: profilePic
  )
);
