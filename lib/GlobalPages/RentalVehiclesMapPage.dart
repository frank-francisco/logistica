import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safirisha/AgencyPages/RentalVehicleDetailsPage.dart';

class RentalVehiclesMapPage extends StatefulWidget {
  final String userId;
  final double latitudes;
  final double longitudes;
  final double radius;
  RentalVehiclesMapPage(
      {this.userId, this.latitudes, this.longitudes, this.radius});

  @override
  _RentalVehiclesMapPageState createState() => _RentalVehiclesMapPageState(
      userId: userId,
      latitudes: latitudes,
      longitudes: longitudes,
      radius: radius);
}

class _RentalVehiclesMapPageState extends State<RentalVehiclesMapPage> {
  String userId;
  double latitudes;
  double longitudes;
  double radius;
  _RentalVehiclesMapPageState(
      {this.userId, this.latitudes, this.longitudes, this.radius});

  GoogleMapController _googleMapController;
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};

  @override
  void initState() {
    addCenterMarker();
    getRentalCars();
    super.initState();
  }

  addCenterMarker() {
    _addMarker(
      LatLng(
        latitudes,
        longitudes,
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    _markers.add(
      Marker(
        markerId: MarkerId('picked_location'),
        infoWindow: const InfoWindow(
          title: 'My location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      ),
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    // timer.cancel();
    super.dispose();
  }

  getRentalCars() {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection("Rental")
        .where('vehicle_visibility', isEqualTo: 'true')
        .snapshots();
    stream.forEach(
      (QuerySnapshot element) {
        if (element == null) return;

        for (int count = 0; count < element.docs.length; count++) {
          double distanceInMeters = Geolocator.distanceBetween(
              latitudes,
              longitudes,
              element.docs[count]['vehicle_location_latitude'],
              element.docs[count]['vehicle_location_longitude']);
          print(
              'The distance is : $distanceInMeters meters, BUt radius is: ${radius}');
          if (distanceInMeters < radius * 1000) {
            _addMarkerRentalCars(
              LatLng(
                element.docs[count]['vehicle_location_latitude'],
                element.docs[count]['vehicle_location_longitude'],
              ),
              element.docs[count]['vehicle_entry_id'],
              element.docs[count],
            );
          } else {
            ///
          }
        }
      },
    );

    // await FirebaseFirestore.instance
    //     .collection('Rental')
    //     .where('vehicle_visibility', isEqualTo: 'true')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     double distanceInMeters = Geolocator.distanceBetween(
    //         latitudes,
    //         longitudes,
    //         doc['vehicle_location_latitude'],
    //         doc['vehicle_location_longitude']);
    //
    //     //decide
    //     if (distanceInMeters > radius * 1000) {
    //       print('********** found');
    //       _addMarkerRentalCars(
    //         LatLng(
    //           doc['vehicle_location_latitude'],
    //           doc['vehicle_location_longitude'],
    //         ),
    //         doc['vehicle_entry_id'],
    //         doc,
    //       );
    //     } else {
    //       print('********** not found');
    //
    //       ///
    //     }
    //   });
    // });
  }

  _addMarkerRentalCars(
      LatLng pos, String id, QueryDocumentSnapshot<Object> doc) async {
    if (this.mounted) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(id + '_rental'),
            infoWindow: InfoWindow(
              title: 'Rental car',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: pos,
            onTap: () {
              updateViews(doc);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => RentalVehicleDetailsPage(
                    userId: userId,
                    carSnap: doc,
                  ),
                ),
              );
            },
          ),
        );
      });
    }
  }

  updateViews(DocumentSnapshot<Object> myVehicle) {
    DocumentReference carRef = FirebaseFirestore.instance
        .collection('Rental')
        .doc(myVehicle['vehicle_entry_id']);
    carRef.update(
      {
        'vehicle_visits': FieldValue.increment(1),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'Rental vehicles',
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
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            latitudes,
            longitudes,
          ),
          zoom: 14.5,
          tilt: 50.0,
        ),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
      ),
    );
  }
}
