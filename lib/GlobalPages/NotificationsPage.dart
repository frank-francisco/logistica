import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_constants.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:safirisha/OnlyServices/time_ago_since_now_en.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future _data;
  String _onlineUserId;
  Future<void> _launched;

  Future _getUsers() async {
    final User user = _firebaseAuth.currentUser;
    setState(() {
      _onlineUserId = user.uid;
    });
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot qn = await _fireStore
        .collection('Notifications')
        .doc('important')
        .collection(_onlineUserId)
        .orderBy('notification_time', descending: true)
        .get();
    return qn.docs;
  }

  @override
  void initState() {
    super.initState();
    _data = _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'Notifications',
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
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Notifications')
              .doc('important')
              .collection(_onlineUserId)
              .orderBy('notification_time', descending: true)
              .where('notification_time', isNotEqualTo: 0)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitThreeBounce(
                  color: Colors.grey,
                  size: 20.0,
                ),
              );
            } else {
              if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image(
                      image: AssetImage('assets/images/empty.png'),
                      width: double.infinity,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myNotifications =
                        snapshot.data.docs[index];
                    return _displayNotifications(index, myNotifications);
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _displayNotifications(index, myNotifications) {
    return Padding(
      padding: index == 0
          ? EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 16)
          : EdgeInsets.only(left: 10, right: 10, bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          //color: Color(0xffe7f3f9),
          border: Border.all(
            color: Color(0xff1e407c),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                myNotifications['notification_tittle'],
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                myNotifications['notification_details'],
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              (myNotifications['action_title'] == 'rental_request' ||
                      myNotifications['action_title'] == 'transfer_request')
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
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
                                    width: 16,
                                  ),
                                  Text(
                                    'Contact',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              openDialog(myNotifications['sender_phone']);
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Accept request',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              if (myNotifications['action_title'] ==
                                  'transfer_request') {
                                openRoutePaymentSheet(myNotifications,
                                    myNotifications['approximated_distance']);
                              } else {
                                openRentalPaymentSheet(myNotifications);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    timeAgoSinceDateEn(
                      DateTime.fromMillisecondsSinceEpoch(
                              myNotifications['notification_time'])
                          .toString(),
                    ),
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _viewOnMap(double latitudes, double longitudes) {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (_) => ViewLocationPage(
    //       latitudes: latitudes,
    //       longitudes: longitudes,
    //     ),
    //   ),
    // );
    //MapsLauncher.launchCoordinates(latitudes, longitudes);
    print(latitudes.toString() + ' and ' + longitudes.toString());
  }

  openDialog(String phoneNumber) {
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
                        'Contacting options!',
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
                        'We provide you with options to call or text the person requesting, '
                        'to get more information you need from them.',
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
                                Navigator.of(context).pop();
                                _launched = _makeCallAndSms('tel:$phoneNumber');
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
                                Navigator.of(context).pop();
                                _launched = _makeCallAndSms(
                                    'sms:$phoneNumber?body=Message%20here...');
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

  openRoutePaymentSheet(var myNotifications, int distance) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Confirm payment',
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
              Text(
                'Package transfer',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                myNotifications['notification_details'],
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Approximated Distance: ',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    distance.toString() + ' Km',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Container()),
                  Text(
                    'Fee: ',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    distance < 50
                        ? '1,500 Tsh'
                        : distance >= 50
                            ? '20,000 Tsh'
                            : distance >= 200
                                ? '50,000 Tsh'
                                : '50,000 Tsh',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PAY NOW',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  beginPayment();
                  // if (myNotifications['action_title'] ==
                  //     'transfer_request') {
                  //   openRoutePaymentSheet(myNotifications);
                  // } else {
                  //   openRentalPaymentSheet(myNotifications);
                  // }
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  openRentalPaymentSheet(var myNotifications) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Confirm payment',
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
              Text(
                'Car rental',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                myNotifications['notification_details'],
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price: ',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    myNotifications['renting_price'].toString() + ' / hr',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Container()),
                  Text(
                    'Fee: ',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    (myNotifications['renting_price'] * 0.1).toString() +
                        ' Tsh',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PAY NOW',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  beginPayment();
                  // if (myNotifications['action_title'] ==
                  //     'transfer_request') {
                  //   openRoutePaymentSheet(myNotifications);
                  // } else {
                  //   openRentalPaymentSheet(myNotifications);
                  // }
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  beginPayment() async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
        context: this.context,
        encryptionKey: "your_test_encryption_key",
        publicKey: "your_public_key",
        currency: FlutterwaveCurrency.USD,
        amount: '200',
        email: "valid@email.com",
        fullName: "Valid Full Name",
        txRef: _onlineUserId,
        isDebugMode: true,
        phoneNumber: "0123456789",
        acceptCardPayment: true,
        acceptUSSDPayment: false,
        acceptAccountPayment: false,
        acceptFrancophoneMobileMoney: false,
        acceptGhanaPayment: false,
        acceptMpesaPayment: false,
        acceptRwandaMoneyPayment: true,
        acceptUgandaPayment: false,
        acceptZambiaPayment: false);

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction.
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          // provide value to customer
        } else {
          // check message
          print(response.message);

          // check status
          print(response.status);

          // check processor error
          print(response.data.processorResponse);
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data.currency == FlutterwaveCurrency.USD &&
        response.data.amount == '200' &&
        response.data.txRef == _onlineUserId;
  }
}
