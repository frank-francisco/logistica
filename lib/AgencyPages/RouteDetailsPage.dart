import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:safirisha/AgencyPages/AgencyUpdateTruckRoutePage.dart';
import 'package:safirisha/OnlyServices/profileData.dart';
import 'package:safirisha/animations/FadeAnimations.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteDetailsPage extends StatefulWidget {
  final String userId;
  final routeSnap;
  RouteDetailsPage({this.userId, this.routeSnap});

  @override
  _RouteDetailsPageState createState() =>
      _RouteDetailsPageState(userId: userId, routeSnap: routeSnap);
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  String userId;
  var routeSnap;
  _RouteDetailsPageState({this.userId, this.routeSnap});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleMapController mapController;
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> _markers = {};
  bool sendingRequest = false;
  bool userFlag = false;
  var details;
  var ownerInfo;
  bool ownerFlag = false;
  Future<void> _launched;
  String onlineUserId;
  int approximatedDistance = 0;

  @override
  void initState() {
    manageUser();
    addMarkers();
    setPolyLines();
    getDistanceInKm();
    super.initState();
  }

  manageUser() async {
    final User user = _auth.currentUser;
    setState(() {
      onlineUserId = user.uid;
    });
    ProfileService().getProfileInfo(onlineUserId).then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        setState(
          () {
            userFlag = true;
            details = docs.docs[0].data();
          },
        );
      }
    });

    ProfileService()
        .getProfileInfo(routeSnap['route_poster'])
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        setState(
          () {
            ownerFlag = true;
            ownerInfo = docs.docs[0].data();
          },
        );
      }
    });
  }

  addMarkers() {
    _addMarker(
      LatLng(
        routeSnap['route_starting_latitude'],
        routeSnap['route_starting_longitude'],
      ),
    );
    _addDestinationMarker(
      LatLng(
        routeSnap['route_ending_latitude'],
        routeSnap['route_ending_longitude'],
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

  void _addDestinationMarker(LatLng pos) async {
    _markers.add(
      Marker(
        markerId: MarkerId('picked_location'),
        infoWindow: const InfoWindow(
          title: 'My location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  setPolyLines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBa00pyIHQBzvAVEY-2bU3YcS69m-4Tue4',
      PointLatLng(routeSnap['route_starting_latitude'],
          routeSnap['route_starting_longitude']),
      PointLatLng(routeSnap['route_ending_latitude'],
          routeSnap['route_ending_longitude']),
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
        width: 10,
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

  getDistanceInKm() {
    double distanceInMeters = Geolocator.distanceBetween(
        routeSnap['route_starting_latitude'],
        routeSnap['route_starting_longitude'],
        routeSnap['route_ending_latitude'],
        routeSnap['route_ending_longitude']);

    print('The distance is' +
        (distanceInMeters / 1000).toStringAsFixed(0) +
        ' Km');
    setState(() {
      approximatedDistance =
          int.parse((distanceInMeters / 1000).toStringAsFixed(0));
    });
  }

  @override
  void dispose() {
    // _controller.dispose();
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'Route details',
          style: GoogleFonts.quicksand(),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _openRouteDetailsSheet();
            },
            icon: Icon(
              Icons.info,
            ),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            routeSnap['route_starting_latitude'],
            routeSnap['route_starting_longitude'],
          ),
          zoom: 14.5,
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

  _openRouteDetailsSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      routeSnap['route_truck_model'] +
                          ' | ${routeSnap['route_truck']}',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 3.0,
                            right: 10.0,
                          ),
                          child: Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            routeSnap['route_starting_point'],
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 3.0,
                            right: 10.0,
                          ),
                          child: Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            DateFormat('dd MMM yyyy ~ hh : mm a').format(
                                new DateTime.fromMillisecondsSinceEpoch(
                                    routeSnap['route_starting_time'])),
                            style: GoogleFonts.quicksand(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 8.0,
                        width: 1.0,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4.0,
                            right: 4.0,
                          ),
                          child: Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            routeSnap['route_ending_point'],
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 3.0,
                            right: 10.0,
                          ),
                          child: Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            DateFormat('dd MMM yyyy ~ hh : mm a').format(
                                new DateTime.fromMillisecondsSinceEpoch(
                                    routeSnap['route_ending_time'])),
                            style: GoogleFonts.quicksand(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Route details',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      routeSnap['route_description'],
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buttonControl(routeSnap),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonControl(var routeSnap) {
    if (routeSnap['route_poster'] == userId) {
      return InkWell(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.0),
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Color(0xff1e407c),
            border: Border.all(
              color: Color(0xff1e407c),
              width: 1,
            ),
          ),
          child: Align(
            child: Text(
              'Update route',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: .5,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AgencyUpdateTruckRoutePage(
                routeSnap: routeSnap,
              ),
            ),
          );
        },
      );
    } else {
      return Row(
        children: [
          Flexible(
            child: InkWell(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Color(0xff1e407c),
                  border: Border.all(
                    color: Color(0xff1e407c),
                    width: 1,
                  ),
                ),
                child: Align(
                  child: sendingRequest
                      ? SpinKitThreeBounce(
                          color: Colors.white,
                          size: 20.0,
                        )
                      : Text(
                          'Request transfer',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                ),
              ),
              onTap: () {
                sendVehicleRequest();
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 0.0),
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xff1e407c),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(
                  Icons.more_horiz_rounded,
                ),
              ),
            ),
            onTap: () {
              openDialog();
            },
          ),
        ],
      );
    }
  }

  openDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)), //this right here
          child: Wrap(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'More options!',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Sometime owners can be offline, you have the option to either call them or send sms.',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                if (ownerFlag == true) {
                                  Navigator.of(context).pop();
                                  _launched = _makeCallAndSms(
                                      'tel:${ownerInfo['user_phone']}');
                                } else {
                                  ///
                                }
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.phoneAlt,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Call',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                if (ownerFlag == true) {
                                  Navigator.of(context).pop();
                                  _launched = _makeCallAndSms(
                                      'sms:${ownerInfo['user_phone']}?body=Message%20here...');
                                } else {
                                  ///
                                }
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.comment,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Sms',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _makeCallAndSms(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  sendVehicleRequest() {
    setState(() {
      sendingRequest = true;
    });
    sendNotification();
  }

  sendNotification() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(routeSnap['route_poster'])
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'Transfer request!',
      'notification_details':
          '${details['user_name']} is requesting to transfer his/her package with your ${routeSnap['route_truck_model']} with '
              'registration number ${routeSnap['route_truck']}. You can reach out to them '
              'by either calling or sending sms.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Safirisha',
      'action_title': 'transfer_request',
      'sender_phone': details['user_phone'],
      'action_destination': '',
      'action_key': '',
      'approximated_distance': approximatedDistance,
      'renting_price': 0,
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(() {
      setState(() {
        sendingRequest = false;
      });
      print('Notification created');
      DocumentReference ds = FirebaseFirestore.instance
          .collection('Users')
          .doc(routeSnap['route_poster']);
      Map<String, dynamic> _tasks = {
        'notification_count': FieldValue.increment(1),
      };
      ds.update(_tasks).whenComplete(() {
        print('notification count updated');
      });

      //route reference
      DocumentReference carRef = FirebaseFirestore.instance
          .collection('TruckRoutes')
          .doc(routeSnap['route_poster']);
      carRef.update(
        {
          'route_requests': FieldValue.increment(1),
        },
      );
    });
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ), //this right here
          child: Wrap(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Request sent!',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Your transfer request for ${routeSnap['route_truck_model']} has successfully been submitted!',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 42,
                          decoration: new BoxDecoration(
                              color: Color(0xff1e407c),
                              borderRadius: new BorderRadius.all(
                                Radius.circular(
                                  6.0,
                                ),
                              )),
                          child: Center(
                            child: Text(
                              "Okay",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
