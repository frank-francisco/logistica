import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safirisha/AgencyPages/RouteDetailsPage.dart';

class TruckRoutesMapPage extends StatefulWidget {
  final String userId;
  final double startingLatitudes;
  final double startingLongitudes;
  final double stoppingLatitudes;
  final double stoppingLongitudes;
  TruckRoutesMapPage(
      {this.userId,
      this.startingLatitudes,
      this.startingLongitudes,
      this.stoppingLatitudes,
      this.stoppingLongitudes});

  @override
  _TruckRoutesMapPageState createState() => _TruckRoutesMapPageState(
      userId: userId,
      startingLatitudes: startingLatitudes,
      startingLongitudes: startingLongitudes,
      stoppingLatitudes: stoppingLatitudes,
      stoppingLongitudes: stoppingLongitudes);
}

class _TruckRoutesMapPageState extends State<TruckRoutesMapPage> {
  String userId;
  double startingLatitudes;
  double startingLongitudes;
  double stoppingLatitudes;
  double stoppingLongitudes;
  _TruckRoutesMapPageState({
    this.userId,
    this.startingLatitudes,
    this.startingLongitudes,
    this.stoppingLatitudes,
    this.stoppingLongitudes,
  });

  GoogleMapController mapController;
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates_2 = [];
  PolylinePoints polylinePoints_2 = PolylinePoints();
  bool fabVisibility = false;
  var routeSnap;

  @override
  void initState() {
    // TODO: implement initState
    putMyMarkers();
    putMyPolyLines();
    getTrucksAround();

    super.initState();
  }

  putMyMarkers() {
    _addMarker(
      LatLng(
        startingLatitudes,
        startingLongitudes,
      ),
    );
    _addDestinationMarker(
      LatLng(
        stoppingLatitudes,
        stoppingLongitudes,
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    _markers.add(
      Marker(
          markerId: MarkerId('pickup_location'),
          infoWindow: const InfoWindow(
            title: 'Pickup location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos,
          onTap: () {
            setState(() {
              fabVisibility = false;
              //routeSnap = doc;
              polylineCoordinates_2.clear();
            });
          }),
    );
  }

  void _addDestinationMarker(LatLng pos) async {
    _markers.add(
      Marker(
          markerId: MarkerId('destination_location'),
          infoWindow: const InfoWindow(
            title: 'Dropping location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
          onTap: () {
            setState(() {
              fabVisibility = false;
              //routeSnap = doc;
              polylineCoordinates_2.clear();
            });
          }),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  putMyPolyLines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBa00pyIHQBzvAVEY-2bU3YcS69m-4Tue4',
      PointLatLng(
        startingLatitudes,
        startingLongitudes,
      ),
      PointLatLng(
        stoppingLatitudes,
        stoppingLongitudes,
      ),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      });

      PolylineId id = PolylineId('poly');
      Polyline polyline = Polyline(
        width: 8,
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
      );
      polyLines[id] = polyline;
      setState(() {
        //
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'Available routes',
          style: GoogleFonts.quicksand(),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: fabVisibility
          ? InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => RouteDetailsPage(
                      userId: userId,
                      routeSnap: routeSnap,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: 60,
                width: MediaQuery.of(context).size.width / 1.5,
                child: routeSnap == null
                    ? Container()
                    : Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue with:',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                routeSnap['route_truck_model'],
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            )
          : Container(),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            startingLatitudes,
            startingLongitudes,
          ),
          zoom: 11.5,
          tilt: 50.0,
        ),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: _markers,
        polylines: Set<Polyline>.of(polyLines.values),
      ),
    );
  }

  getTrucksAround() {
    FirebaseFirestore.instance
        .collection('TruckRoutes')
        .where('route_visibility', isEqualTo: 'true')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        double distanceInMeters = Geolocator.distanceBetween(
            startingLatitudes,
            startingLongitudes,
            doc['route_starting_latitude'],
            doc['route_starting_longitude']);
        print('The distance is : $distanceInMeters meters');
        if (distanceInMeters < 30000) {
          _addMarkerVehicleRoutes(
            LatLng(doc['route_starting_latitude'],
                doc['route_starting_longitude']),
            doc['route_entry_id'],
            doc,
            doc['route_starting_latitude'],
            doc['route_starting_longitude'],
            doc['route_ending_latitude'],
            doc['route_ending_longitude'],
          );
        } else {
          ///
        }
      });
    });
  }

  _addMarkerVehicleRoutes(
    LatLng pos,
    String id,
    QueryDocumentSnapshot<Object> doc,
    double startLtd,
    double startLng,
    double endLtd,
    double endLng,
  ) async {
    if (this.mounted) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(id + '_transfer'),
            infoWindow: InfoWindow(
              title: 'Rental car',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            position: pos,
            onTap: () {
              if (polylineCoordinates_2.isEmpty) {
                _makePolyLine(
                  startLtd,
                  startLng,
                  endLtd,
                  endLng,
                );
              }

              _addRouteDestinationMarker(
                LatLng(
                  endLtd,
                  endLng,
                ),
              );

              setState(() {
                fabVisibility = true;
                routeSnap = doc;
              });
            },
          ),
        );
      });
    }
  }

  _makePolyLine(
    double startLtd,
    double startLng,
    double endLtd,
    double endLng,
  ) async {
    PolylineResult result = await polylinePoints_2.getRouteBetweenCoordinates(
      'AIzaSyBa00pyIHQBzvAVEY-2bU3YcS69m-4Tue4',
      PointLatLng(startLtd, startLng),
      PointLatLng(endLtd, endLng),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates_2.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      });

      PolylineId id = PolylineId('poly_2');
      Polyline polyline = Polyline(
        width: 6,
        polylineId: id,
        color: Colors.deepOrangeAccent,
        points: polylineCoordinates_2,
      );
      polyLines[id] = polyline;
      setState(() {
        //
      });
    }
  }

  _addRouteDestinationMarker(LatLng pos) {
    _markers.add(
      Marker(
          markerId: MarkerId('destination_location_2'),
          infoWindow: const InfoWindow(
            title: 'Route destination',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: pos,
          onTap: () {
            setState(() {
              fabVisibility = false;
              //routeSnap = doc;
              polylineCoordinates_2.clear();
            });
          }),
    );
  }
}
