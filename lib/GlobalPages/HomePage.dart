import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:safirisha/AdminPages/AdminDashboardPage.dart';
import 'package:safirisha/AgencyPages/AgencyAddTruckPage.dart';
import 'package:safirisha/AgencyPages/AgencyAddTruckRoutePage.dart';
import 'package:safirisha/AgencyPages/AgencyDisplayRentalCarPage.dart';
import 'package:safirisha/AgencyPages/AgencyDisplayTruckRoutesPage.dart';
import 'package:safirisha/AgencyPages/AgencyProfilePage.dart';
import 'package:safirisha/AgencyPages/AgencyDashboardPage.dart';
import 'package:safirisha/GlobalPages/GettingStartedScreen.dart';
import 'package:safirisha/GlobalPages/HomeMapPage.dart';
import 'package:safirisha/GlobalPages/RentalVehiclesMapPage.dart';
import 'package:safirisha/GlobalPages/TruckRoutesMapPage.dart';
import 'package:safirisha/OnlyServices/profileData.dart';
import 'package:safirisha/PersonalPages/PersonalProfilePage.dart';
import 'package:safirisha/animations/FadeAnimations.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

import 'NotificationsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool openPoster = false;
  String onlineUserId;
  String bodyInput = '';
  String whatsAppShareLink =
      'https://wa.me/?text=Tumia application ya Safirisha kusafirisha mizigo na kukodi magari kwaajili ya shughuli mbalimbali. Pakua hapa: https://play.google.com/store/apps/details?id=com.safirisha';
  bool userFlag = false;
  var details;

  int selectedSearch = 0;
  PickResult locationForRental;
  PickResult startingTruckLocation;
  PickResult stoppingTruckLocation;
  final kInitialPosition = LatLng(-33.8567844, 151.213108);
  double _value = 5.0;

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
  }

  @override
  void initState() {
    super.initState();
    manageUser();
  }

  void _launchURL() async => await canLaunch(whatsAppShareLink)
      ? await launch(whatsAppShareLink)
      : throw 'Could not launch $whatsAppShareLink';

  Widget popupAgencyMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        size: 26.0,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Row(
            children: [
              Icon(
                Icons.add_location_alt_outlined,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Add truck route',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '1',
          child: Row(
            children: [
              Icon(
                Icons.car_rental,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Display rental car',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2',
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'My profile',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '3',
          child: Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Dashboard',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '4',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Share App',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '5',
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Log out',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (retVal) async {
        if (retVal == '0') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AgencyDisplayTruckRoutesPage(
                userId: onlineUserId,
              ),
            ),
          );
        }
        if (retVal == '1') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AgencyDisplayRentalCarPage(
                userId: onlineUserId,
              ),
            ),
          );
        }
        if (retVal == '2') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AgencyProfilePage(
                userId: onlineUserId,
                userSnap: details,
              ),
            ),
          );
        }
        if (retVal == '3') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AgencyDashboardPage(
                userId: onlineUserId,
              ),
            ),
          );
        }
        if (retVal == '4') {
          _launchURL();
        }
        if (retVal == '5') {
          _logOut();
        }
      },
    );
  }

  Widget popupPersonalMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        size: 26.0,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'My profile',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '1',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Share App',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2',
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Log out',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (retVal) async {
        if (retVal == '0') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => PersonalProfilePage(
                userId: onlineUserId,
                userSnap: details,
              ),
            ),
          );
        }
        if (retVal == '1') {
          _launchURL();
        }
        if (retVal == '2') {
          _logOut();
        }
      },
    );
  }

  Widget popupAdminMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        size: 26.0,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Admin dashboard',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '1',
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'My profile',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Share App',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '3',
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Log out',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (retVal) async {
        if (retVal == '0') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AdminDashboardPage(
                userId: onlineUserId,
                userSnap: details,
              ),
            ),
          );
        }
        if (retVal == '1') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => PersonalProfilePage(
                userId: onlineUserId,
                userSnap: details,
              ),
            ),
          );
        }
        if (retVal == '2') {
          _launchURL();
        }
        if (retVal == '3') {
          _logOut();
        }
      },
    );
  }

  Widget popupLoadingButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        size: 26.0,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.facebook,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Facebook',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (retVal) async {
        if (retVal == '0') {
          //
        }
      },
    );
  }

  Future _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => GettingStartedScreen(),
          ),
          (r) => false);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'Safirisha',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: .5,
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          _notificationBell(),
          //_accountProfile(),
          userFlag
              ? (details['account_type'] == 'Company'
                  ? popupAgencyMenuButton()
                  : details['account_type'] == 'Admin'
                      ? popupAdminMenuButton()
                      : popupPersonalMenuButton())
              : popupLoadingButton(),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: HomeMapPage(userId: onlineUserId),
          ),
          Visibility(
            visible: openPoster,
            child: posterSheet(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: openPoster
          ? null
          : FloatingActionButton.extended(
              heroTag: null,
              isExtended: true,
              icon: Icon(
                FontAwesomeIcons.search,
                color: Colors.white,
                size: 16,
              ),
              label: Text(
                'Search',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
              backgroundColor: Color(0xff1e407c),
              onPressed: () {
                print("Hey: $onlineUserId");
                setState(() {
                  openPoster = true;
                });
              },
            ),
    );
  }

  Widget posterSheet() {
    return Positioned(
      bottom: 0.0,
      left: 0,
      right: 0,
      child: FadeAnimation(
        0.4,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(4, 1), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pick\nyour search',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff1e407c),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.windowClose,
                        color: Colors.pink,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            openPoster = false;
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ToggleSwitch(
                  minWidth: double.infinity,
                  initialLabelIndex: selectedSearch,
                  totalSwitches: 2,
                  activeBgColor: [Color(0xff1e407c)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey[300],
                  inactiveFgColor: Colors.black87,
                  borderColor: [Color(0xff1e407c)],
                  borderWidth: 1,
                  labels: ['Rental cars', 'Transit Trucks'],
                  onToggle: (index) {
                    print('switched to: $index');
                    setState(() {
                      selectedSearch = index;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                selectedSearch == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Select your location:',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              openPickerRentalPage();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: Color(0xff1e407c),
                                  ),
                                ),
                                color: Colors.grey[100],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 4.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pick your location',
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            locationForRental == null
                                                ? 'Pick location'
                                                : locationForRental
                                                    .formattedAddress,
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 18.0,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Select radius:',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                ' ${_value.toStringAsFixed(2)} Km',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black87,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SfSlider(
                            min: 5,
                            max: 30,
                            value: _value,
                            interval: 5,
                            showTicks: true,
                            showLabels: true,
                            enableTooltip: true,
                            minorTicksPerInterval: 0,
                            onChanged: (dynamic value) {
                              setState(() {
                                _value = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 42.0,
                            //width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (locationForRental != null) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => RentalVehiclesMapPage(
                                        userId: onlineUserId,
                                        latitudes: locationForRental
                                            .geometry.location.lat,
                                        longitudes: locationForRental
                                            .geometry.location.lng,
                                        radius: _value,
                                      ),
                                    ),
                                  );
                                } else {
                                  var snackBar = SnackBar(
                                    content: Text(
                                      'Please select location!',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  'Search Rental Cars',
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Color(0xff1e407c),
                                onSurface: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose pickup location:',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              openPickerTrucksPage();
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: Color(0xff1e407c),
                                  ),
                                ),
                                color: Colors.grey[100],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 4.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pickup location',
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            startingTruckLocation == null
                                                ? 'Click to pick location'
                                                : startingTruckLocation
                                                    .formattedAddress,
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 18.0,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Choose dropping location:',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              openDropperTrucksPage();
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: Color(0xff1e407c),
                                  ),
                                ),
                                color: Colors.grey[100],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 4.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dropping location',
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            stoppingTruckLocation == null
                                                ? 'Click to pick location'
                                                : stoppingTruckLocation
                                                    .formattedAddress,
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 18.0,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 42.0,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (startingTruckLocation != null &&
                                    stoppingTruckLocation != null) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => TruckRoutesMapPage(
                                        userId: onlineUserId,
                                        startingLatitudes: startingTruckLocation
                                            .geometry.location.lat,
                                        startingLongitudes:
                                            startingTruckLocation
                                                .geometry.location.lng,
                                        stoppingLatitudes: stoppingTruckLocation
                                            .geometry.location.lat,
                                        stoppingLongitudes:
                                            stoppingTruckLocation
                                                .geometry.location.lng,
                                      ),
                                    ),
                                  );

                                  //reFormatPhone();
                                  //             //getData();
                                  //             setState(() {
                                  //               _loading = true;
                                  //               _resultVisibility = false;
                                  //               _error = false;
                                  //             });
                                } else {
                                  var snackBar = SnackBar(
                                    content: Text(
                                      'Please select both locations!',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  'Search Trucks',
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Color(0xff1e407c),
                                onSurface: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _notificationBell() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('user_id', isEqualTo: onlineUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: CircleAvatar(
                backgroundColor: Color(0xff1e407c),
                radius: 18,
                child: IconButton(
                    icon: Icon(
                      CupertinoIcons.bell_fill,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      //_onBellClick();
                    }),
              ),
            ),
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: CircleAvatar(
                  backgroundColor: Color(0xff1e407c),
                  radius: 18,
                  child: IconButton(
                      icon: Icon(
                        CupertinoIcons.bell_fill,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        //_onBellClick();
                      }),
                ),
              ),
            );
          } else {
            DocumentSnapshot myInfo = snapshot.data.docs[0];
            if (myInfo['notification_count'] == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff1e407c),
                    radius: 18,
                    child: IconButton(
                        icon: Icon(
                          CupertinoIcons.bell_fill,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _onBellClick(myInfo);
                        }),
                  ),
                ),
              );
            } else {
              int myCount = snapshot.data.docs[0]['notification_count'];
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: CircleAvatar(
                        backgroundColor: Color(0xff1e407c),
                        radius: 18,
                        child: IconButton(
                            icon: Icon(
                              CupertinoIcons.bell_fill,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _onBellClick(myInfo);
                            }),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 36,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Color(0xfffd1d1d),
                          width: 1,
                        ),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        myCount.toString(),
                        style: TextStyle(
                          color: Color(0xfffd1d1d),
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        }
      },
    );
  }

  _onBellClick(DocumentSnapshot myInfo) {
    DocumentReference usersRef =
        FirebaseFirestore.instance.collection('Users').doc(onlineUserId);
    usersRef.update({'notification_count': 0});
    if (myInfo['account_type'] == 'Company') {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => NotificationsPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => NotificationsPage(),
        ),
      );
    }
  }

  openPickerRentalPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: 'AIzaSyBa00pyIHQBzvAVEY-2bU3YcS69m-4Tue4',
            initialPosition: kInitialPosition,
            useCurrentLocation: true,
            selectInitialPosition: true,

            //usePlaceDetailSearch: true,
            onPlacePicked: (result) {
              setState(() {
                locationForRental = result;
              });

              Navigator.of(context).pop();
            },
            //forceSearchOnZoomChanged: true,
            //automaticallyImplyAppBarLeading: false,
            //autocompleteLanguage: "ko",
            //region: 'au',
            //selectInitialPosition: true,
            // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
            //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
            //   return isSearchBarFocused
            //       ? Container()
            //       : FloatingCard(
            //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
            //           leftPosition: 0.0,
            //           rightPosition: 0.0,
            //           width: 500,
            //           borderRadius: BorderRadius.circular(12.0),
            //           child: state == SearchingState.Searching
            //               ? Center(child: CircularProgressIndicator())
            //               : RaisedButton(
            //                   child: Text("Pick Here"),
            //                   onPressed: () {
            //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
            //                     //            this will override default 'Select here' Button.
            //                     print("do something with [selectedPlace] data");
            //                     Navigator.of(context).pop();
            //                   },
            //                 ),
            //         );
            // },
            // pinBuilder: (context, state) {
            //   if (state == PinState.Idle) {
            //     return Icon(Icons.favorite_border);
            //   } else {
            //     return Icon(Icons.favorite);
            //   }
            // },
          );
        },
      ),
    );
  }

  openPickerTrucksPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: 'AIzaSyBa00pyIHQBzvAVEY-2bU3YcS69m-4Tue4',
            initialPosition: kInitialPosition,
            useCurrentLocation: true,
            selectInitialPosition: true,

            //usePlaceDetailSearch: true,
            onPlacePicked: (result) {
              setState(() {
                startingTruckLocation = result;
              });
              Navigator.of(context).pop();
            },
            //forceSearchOnZoomChanged: true,
            //automaticallyImplyAppBarLeading: false,
            //autocompleteLanguage: "ko",
            //region: 'au',
            //selectInitialPosition: true,
            // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
            //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
            //   return isSearchBarFocused
            //       ? Container()
            //       : FloatingCard(
            //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
            //           leftPosition: 0.0,
            //           rightPosition: 0.0,
            //           width: 500,
            //           borderRadius: BorderRadius.circular(12.0),
            //           child: state == SearchingState.Searching
            //               ? Center(child: CircularProgressIndicator())
            //               : RaisedButton(
            //                   child: Text("Pick Here"),
            //                   onPressed: () {
            //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
            //                     //            this will override default 'Select here' Button.
            //                     print("do something with [selectedPlace] data");
            //                     Navigator.of(context).pop();
            //                   },
            //                 ),
            //         );
            // },
            // pinBuilder: (context, state) {
            //   if (state == PinState.Idle) {
            //     return Icon(Icons.favorite_border);
            //   } else {
            //     return Icon(Icons.favorite);
            //   }
            // },
          );
        },
      ),
    );
  }

  openDropperTrucksPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: 'AIzaSyBa00pyIHQBzvAVEY-2bU3YcS69m-4Tue4',
            initialPosition: kInitialPosition,
            useCurrentLocation: true,
            selectInitialPosition: true,

            //usePlaceDetailSearch: true,
            onPlacePicked: (result) {
              setState(() {
                stoppingTruckLocation = result;
              });
              Navigator.of(context).pop();
            },
            //forceSearchOnZoomChanged: true,
            //automaticallyImplyAppBarLeading: false,
            //autocompleteLanguage: "ko",
            //region: 'au',
            //selectInitialPosition: true,
            // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
            //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
            //   return isSearchBarFocused
            //       ? Container()
            //       : FloatingCard(
            //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
            //           leftPosition: 0.0,
            //           rightPosition: 0.0,
            //           width: 500,
            //           borderRadius: BorderRadius.circular(12.0),
            //           child: state == SearchingState.Searching
            //               ? Center(child: CircularProgressIndicator())
            //               : RaisedButton(
            //                   child: Text("Pick Here"),
            //                   onPressed: () {
            //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
            //                     //            this will override default 'Select here' Button.
            //                     print("do something with [selectedPlace] data");
            //                     Navigator.of(context).pop();
            //                   },
            //                 ),
            //         );
            // },
            // pinBuilder: (context, state) {
            //   if (state == PinState.Idle) {
            //     return Icon(Icons.favorite_border);
            //   } else {
            //     return Icon(Icons.favorite);
            //   }
            // },
          );
        },
      ),
    );
  }
}
