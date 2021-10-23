import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/AgencyPages/AgencyAddTruckRoutePage.dart';
import 'package:safirisha/AgencyPages/RouteDetailsPage.dart';

class AgencyDisplayTruckRoutesPage extends StatefulWidget {
  final String userId;
  AgencyDisplayTruckRoutesPage({this.userId});

  @override
  _AgencyDisplayTruckRoutesPageState createState() =>
      _AgencyDisplayTruckRoutesPageState(userId: userId);
}

class _AgencyDisplayTruckRoutesPageState
    extends State<AgencyDisplayTruckRoutesPage> {
  String userId;
  _AgencyDisplayTruckRoutesPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'Display truck route',
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
                      'Your\ntruck routes',
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
                                  builder: (_) => AgencyAddTruckRoutePage(
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
                                          'Add new route',
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Click to add new route',
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
                          .collection('TruckRoutes')
                          .where('route_poster', isEqualTo: userId)
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
                                DocumentSnapshot myRoute =
                                    snapshot.data.docs[index];
                                return routeItem(index, myRoute);
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

  Widget routeItem(int index, DocumentSnapshot<Object> myRoute) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              print(myRoute['route_truck']);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => RouteDetailsPage(
                    userId: userId,
                    routeSnap: myRoute,
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
                    Icon(FontAwesomeIcons.route),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myRoute['route_truck'],
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          myRoute['route_starting_point'],
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
                    Switch(
                      activeColor: Color(0xff1e407c),
                      value:
                          myRoute['route_visibility'] == 'true' ? true : false,
                      onChanged: (value) {
                        print(value);
                        updateStatus(value, myRoute['route_entry_id']);
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
        FirebaseFirestore.instance.collection('TruckRoutes').doc(id);
    usersRef.update({'route_visibility': value.toString()});
  }
}
