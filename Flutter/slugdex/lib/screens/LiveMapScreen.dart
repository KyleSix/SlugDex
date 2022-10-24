import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slugdex/provider/location_provider.dart';
import 'package:slugdex/screens/DexEntryPage.dart';

class LiveMapScreen extends StatefulWidget {
  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
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
                      scrollGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: MinMaxZoomPreference(16,19),
                      onMapCreated: (GoogleMapController controller){
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
}
