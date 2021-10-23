import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/AgencyPages/AgencyUpdateRentalVehiclePage.dart';
import 'package:safirisha/OnlyServices/profileData.dart';
import 'package:safirisha/animations/FadeAnimations.dart';
import 'package:url_launcher/url_launcher.dart';

class RentalVehicleDetailsPage extends StatefulWidget {
  final String userId;
  final carSnap;
  RentalVehicleDetailsPage({this.userId, this.carSnap});

  @override
  _RentalVehicleDetailsPageState createState() =>
      _RentalVehicleDetailsPageState(userId: userId, carSnap: carSnap);
}

class _RentalVehicleDetailsPageState extends State<RentalVehicleDetailsPage> {
  String userId;
  var carSnap;
  _RentalVehicleDetailsPageState({this.userId, this.carSnap});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String onlineUserId;
  bool sendingRequest = false;
  bool userFlag = false;
  var details;
  var ownerInfo;
  bool ownerFlag = false;
  Future<void> _launched;

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
        .getProfileInfo(carSnap['vehicle_owner'])
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

  @override
  void initState() {
    super.initState();
    manageUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            expandedHeight: ((MediaQuery.of(context).size.width * 2) / 3),
            backgroundColor: Color(0xff1e407c),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: CarouselSlider(
                options: CarouselOptions(
                  //height: MediaQuery.of(context).size.width * 2 / 3,
                  aspectRatio: 2 / 3,
                  viewportFraction: 1.0,
                  initialPage: 1,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                items: [
                  carSnap['vehicle_image_one'],
                  carSnap['vehicle_image_two'],
                  carSnap['vehicle_image_three'],
                  carSnap['vehicle_image_four']
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.width * 2 / 3,
                        width: MediaQuery.of(context).size.width,
                        child: Image(
                          image: NetworkImage(i),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(
                        1.6,
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                carSnap['vehicle_name'],
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4.0,
                                      right: 4.0,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.carAlt,
                                      size: 16,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      carSnap['vehicle_model'],
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
                                      top: 4.0,
                                      right: 4.0,
                                    ),
                                    child: Image(
                                      height: 16,
                                      width: 16,
                                      image: AssetImage(
                                          'assets/images/steering_wheel.png'),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      carSnap['vehicle_renting_option'] ==
                                              'Vehicle only'
                                          ? carSnap['vehicle_renting_option'] +
                                              ', no driver.'
                                          : carSnap['vehicle_renting_option'],
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
                                      top: 4.0,
                                      right: 4.0,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      size: 16,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      carSnap['vehicle_location'],
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
                                height: 30,
                              ),
                              Text(
                                'About vehicle',
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
                                carSnap['vehicle_description'],
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Tsh: ',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    carSnap['vehicle_price'] + '/= per hour',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                        2,
                        buttonControl(carSnap),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonControl(var carSnap) {
    if (carSnap['vehicle_owner'] == userId) {
      return InkWell(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.0),
          height: 50,
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
              'Update vehicle',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
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
              builder: (_) => AgencyUpdateRentalVehiclePage(
                carSnap: carSnap,
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
                height: 50,
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
                          'Request vehicle',
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
              height: 50,
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
        .collection(carSnap['vehicle_owner'])
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'Rental request!',
      'notification_details':
          '${details['user_name']} wants to rent your ${carSnap['vehicle_model']} with '
              'registration number ${carSnap['vehicle_name']}. You can reach out to them '
              'by either calling or sending sms.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Safirisha',
      'action_title': 'rental_request',
      'sender_phone': details['user_phone'],
      'action_destination': '',
      'action_key': '',
      'approximated_distance': 0,
      'renting_price': int.parse(carSnap['vehicle_price']),
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(() {
      setState(() {
        sendingRequest = false;
      });
      print('Notification created');
      DocumentReference ds = FirebaseFirestore.instance
          .collection('Users')
          .doc(carSnap['vehicle_owner']);
      Map<String, dynamic> _tasks = {
        'notification_count': FieldValue.increment(1),
      };
      ds.update(_tasks).whenComplete(() {
        print('notification count updated');
      });
    });
    showDialog(
      barrierDismissible: false,
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
                        'Your rental request for ${carSnap['vehicle_model']} has successfully been submitted!',
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
