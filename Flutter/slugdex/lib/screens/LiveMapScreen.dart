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
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

MapType _currentMapType = MapType.normal;
void toggleMapType() {
  _currentMapType =
      (_currentMapType == MapType.normal) ? MapType.satellite : MapType.normal;
}

final Set<Marker> _markers = new Set();
Set<Circle> _circles = new Set(); // For the hint radii
double _radius = 25.0; // Distance in meters

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({this.entryID = -1}); // -1 When load screen not from hint
  final int entryID;
  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  late GoogleMapController mapController;
  int? id;

  bool isLoading = true;

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
          panel: getPanel(),
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
              var _currentLocation = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(_currentLocation.latitude,
                          _currentLocation.longitude),
                      zoom: await mapController.getZoomLevel())));
            },
            backgroundColor: Colors.white,
          ),
        ),
        Positioned(
          right: 20.0,
          bottom: _fabHeight,
          child: getSettingsButton(context),
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
                    //mapType: MapType.hybrid,
                    mapType: _currentMapType,
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
                        isLoading = false;
                        controller.setMapStyle('''
                      [
                        {
                          "featureType": "administrative",
                          "elementType": "labels.text.stroke",
                          "stylers": [
                            {
                              "color": "#f1ffb8"
                            },
                            {
                              "visibility": "on"
                            },
                            {
                              "weight": "2.29"
                            }
                          ]
                        },
                        {
                          "featureType": "administrative.land_parcel",
                          "stylers": [
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "landscape.man_made",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#8f8e98"
                            }
                          ]
                        },
                        {
                          "featureType": "landscape.man_made",
                          "elementType": "labels.text",
                          "stylers": [
                            {
                              "hue": "#ff0000"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "landscape.natural",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#b9c474"
                            }
                          ]
                        },
                        {
                          "featureType": "landscape.natural.landcover",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#b9c474"
                            }
                          ]
                        },
                        {
                          "featureType": "landscape.natural.terrain",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#37bda2"
                            }
                          ]
                        },
                        {
                          "featureType": "poi",
                          "elementType": "labels",
                          "stylers": [
                            {
                              "color": "#afa0a0"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "poi",
                          "elementType": "labels.text.stroke",
                          "stylers": [
                            {
                              "color": "#f1ffb8"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.attraction",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#a1f199"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.attraction",
                          "elementType": "labels.text",
                          "stylers": [
                            {
                              "color": "#000000"
                            },
                            {
                              "visibility": "simplified"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.business",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.business",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#e4dfd9"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.business",
                          "elementType": "labels.icon",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.government",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.government",
                          "elementType": "labels.text",
                          "stylers": [
                            {
                              "color": "#000000"
                            },
                            {
                              "visibility": "simplified"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.medical",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.park",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#6f9968"
                            },
                            {
                              "saturation": 5
                            },
                            {
                              "lightness": 15
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.place_of_worship",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.school",
                          "stylers": [
                            {
                              "color": "#d4aa88"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.school",
                          "elementType": "labels.text",
                          "stylers": [
                            {
                              "color": "#000000"
                            },
                            {
                              "visibility": "simplified"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.sports_complex",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#ffffff"
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "geometry.stroke",
                          "stylers": [
                            {
                              "color": "#f1ffb8"
                            },
                            {
                              "visibility": "on"
                            },
                            {
                              "weight": 1.5
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "labels.text.stroke",
                          "stylers": [
                            {
                              "color": "#f1ffb8"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "road.arterial",
                          "elementType": "geometry.stroke",
                          "stylers": [
                            {
                              "color": "#f1ffb8"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "road.arterial",
                          "elementType": "labels.text.stroke",
                          "stylers": [
                            {
                              "color": "#f1ffb8"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "road.highway",
                          "elementType": "labels.icon",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "road.local",
                          "elementType": "geometry.stroke",
                          "stylers": [
                            {
                              "color": "#f1ffb8"
                            },
                            {
                              "visibility": "on"
                            },
                            {
                              "weight": "1.48"
                            }
                          ]
                        },
                        {
                          "featureType": "road.local",
                          "elementType": "labels",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "transit",
                          "stylers": [
                            {
                              "visibility": "off"
                            }
                          ]
                        },
                        {
                          "featureType": "water",
                          "stylers": [
                            {
                              "color": "#0061ff"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        },
                        {
                          "featureType": "water",
                          "elementType": "geometry.fill",
                          "stylers": [
                            {
                              "color": "#0061ff"
                            },
                            {
                              "visibility": "on"
                            }
                          ]
                        }
                      ]
                      ''');
                        mapController = controller;
                      });
                      if (id != -1) {
                        // if we came from an entry hint
                        navigateHint(id!); // then let's nav to it
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }
      return Center(
        child: LoadingScreen(),
      );
    });
  }

  Widget getSettingsButton(context) {
    if(isLoading) {
      return Container();
    } else {
      return _buildProfileFAB(context);
    }
  }

  Widget getPanel() {
    if(isLoading) {
      return Container();
    } else {
      return dexEntryPage();
    }
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

void addMarker(index, context) async {
  final bitmapIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'assets/images/markers/' + (index + 1).toString() + '.png');
  _markers.add(Marker(
      markerId: MarkerId(entryList[index].iD.toString()),
      position: LatLng(entryList[index].latitude!, entryList[index].longitude!),
      icon: bitmapIcon,
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
    if (entryList[index].discovered != 0) // If user discovered a location
      addMarker(index, context); // Mark that location on the map with a marker
  }
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
            // if user is inside 25 meter radius or debug mode
            if (distance <= _radius || Debug == true) {
              // Debug check here
              markDiscovered(thisEntry.iD!.toInt() - 1); // Mark discovered
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
      child: profilePic()
  )
);
