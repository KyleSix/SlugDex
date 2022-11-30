import 'package:flutter/material.dart';
import 'package:image_overlay_map/image_overlay_map.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/Entry/entry.dart';

const Image map_image = Image(image: AssetImage("assets/SlugDexMap.png"));
const Size map_size = Size(4106.0, 7372.0);
const Offset geo_center = Offset(36.994750, -122.058763);

List<MarkerModel> _markers = <MarkerModel>[];

double scaleValue(value, oldMax, oldMin, newMax, newMin) {
  double oldRange = oldMax - oldMin;
  double newRange = newMax - newMin;
  double newValue = (((value - oldMin) * newRange) / oldRange) + newMin;
  return newValue;
}

class EntryMarker {
  int facilityId = -1;
  String name = "";

  // Leaflet CRS.Simple, bounds = [[-height / 2, -width / 2], [height / 2, width / 2]]
  double lat = 0.0;
  double lng = 0.0;
  double mapLat = 0.0;
  double mapLng = 0.0;

  EntryMarker(int facilityId, String name, double lat, double lng) {
    this.facilityId = facilityId;
    this.name = name;
    this.lat = lat;
    this.lng = lng;
    // Convert real-world coordinates to image coorindates,
    this.mapLat = scaleValue(lat, 37.010000, 36.976975, 0.0, map_size.height);
    this.mapLng = scaleValue(lng, -122.047549, -122.070457, map_size.width, 0);
  }
}

class ImageMap extends StatefulWidget {
  ImageMap({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ImageMapState createState() => _ImageMapState();
}

class _ImageMapState extends State<ImageMap> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            buildLocalImageMap(),
          ],
        ));
  }

  Widget buildLocalImageMap() {
    return Center(
      child: MapContainer(map_image, map_size,
          markers: _populateMarkers(),
          markerWidgetBuilder: _buildMarkerWidget,
          onTab: _onTab,
          onMarkerClicked: _onMarkerClicked),
    );
  }

  List<MarkerModel> _populateMarkers() {
    _markers = [];
    for (Entry entry in entryList) {
      EntryMarker e = EntryMarker(
          entry.iD!, entry.name!, entry.latitude!, entry.longitude!);
      MarkerModel m = MarkerModel(e, Offset(e.mapLng, e.mapLat));
      print(e.mapLat.toString() + " " + e.mapLng.toString());
      _markers.add(m);
    }
    return _markers;
  }

  Widget _buildMarkerWidget(double scale, MarkerModel data) {
    return Icon(Icons.location_pin, color: Colors.white);
  }

  _onMarkerClicked(MarkerModel markerModel) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Text((markerModel.data as EntryMarker).name, style: TextStyle(color: Colors.white, fontSize: 32.0, decoration: TextDecoration.none)),
          );
        },
        routeSettings: RouteSettings(name: "/facilityDetail"));
  }

  _onTab() {
    print("onTab");
  }
}
