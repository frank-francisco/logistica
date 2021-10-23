import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/AgencyPages/AgencyAddRentalVehiclePage.dart';
import 'package:safirisha/AgencyPages/RentalVehicleDetailsPage.dart';

class AgencyDisplayRentalCarPage extends StatefulWidget {
  final String userId;
  AgencyDisplayRentalCarPage({this.userId});

  @override
  _AgencyDisplayRentalCarPageState createState() =>
      _AgencyDisplayRentalCarPageState(userId: userId);
}

class _AgencyDisplayRentalCarPageState
    extends State<AgencyDisplayRentalCarPage> {
  String userId;
  _AgencyDisplayRentalCarPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'Display your vehicle',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Your\nrental vehicles',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => AgencyAddRentalVehiclePage(
                                    userId: userId,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Container(
                                //color: Colors.black12,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      backgroundColor: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add new vehicle',
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Click to add rental vehicle',
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                                // fontSize: 18.0,
                                                // fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Icon(Icons.keyboard_arrow_right),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Rental')
                          .where('vehicle_owner', isEqualTo: userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                              //empty
                              );
                        } else {
                          if (snapshot.data.docs.length == 0) {
                            return Container(
                                //empty
                                );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot myVehicle =
                                    snapshot.data.docs[index];
                                return vehicleItem(index, myVehicle);
                              },
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget vehicleItem(int index, DocumentSnapshot<Object> myVehicle) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              print(myVehicle['vehicle_name']);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => RentalVehicleDetailsPage(
                    userId: userId,
                    carSnap: myVehicle,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                //color: Colors.black12,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      child: Image(
                        height: 40 * 1.2,
                        width: 60 * 1.2,
                        image: NetworkImage(
                          myVehicle['vehicle_image_one'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            myVehicle['vehicle_name'],
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            myVehicle['vehicle_location'],
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  // fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      activeColor: Color(0xff1e407c),
                      value: myVehicle['vehicle_visibility'] == 'true'
                          ? true
                          : false,
                      onChanged: (value) {
                        print(value);
                        updateStatus(value, myVehicle['vehicle_entry_id']);
                      },
                    ),
                    SizedBox(
                      width: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  updateStatus(bool value, String id) {
    DocumentReference usersRef =
        FirebaseFirestore.instance.collection('Rental').doc(id);
    usersRef.update({'vehicle_visibility': value.toString()});
  }
}
