import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safirisha/AgencyPages/RentalVehicleDetailsPage.dart';

class HomeMapPage extends StatefulWidget {
  final String userId;
  HomeMapPage({this.userId});

  @override
  _HomeMapPageState createState() => _HomeMapPageState(userId: userId);
}

class _HomeMapPageState extends State<HomeMapPage> {
  String userId;
  _HomeMapPageState({this.userId});

  GoogleMapController _googleMapController;

  //String userId = '';
  //var userInfo;
  double _myLatitude;
  double _myLongitude;

  Location location = new Location();
  Marker _origin;
  Marker _destination;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Set<Marker> _markers = {};

  getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _myLatitude = _locationData.latitude;
      _myLongitude = _locationData.longitude;
      print("Hello: $_myLatitude $_myLongitude");
    });

    updateLocation();
    _addMarker(
      LatLng(
        _myLatitude,
        _myLongitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          width: 40.0,
          height: 40.0,
          child: FloatingActionButton(
            heroTag: null,
            child: Icon(
              Icons.my_location,
              size: 16.0,
            ),
            backgroundColor: Colors.blueGrey,
            onPressed: () {
              getCurrentLocation();
            },
          ),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: _myLatitude == null
              ? LatLng(
                  37.4219983,
                  -122.084,
                )
              : LatLng(
                  _myLatitude,
                  _myLongitude,
                ),
          zoom: 11.5,
        ),
        myLocationEnabled: false,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: _markers,
      ),
    );
  }

  updateLocation() {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _myLatitude,
            _myLongitude,
          ),
          zoom: 14.5,
          tilt: 50.0,
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    _markers.add(
      Marker(
        markerId: MarkerId('origin'),
        infoWindow: const InfoWindow(
          title: 'My location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      ),
    );
  }
}
