import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AgencyDashboardPage extends StatefulWidget {
  final String userId;
  AgencyDashboardPage({
    this.userId,
  });

  @override
  _AgencyDashboardPageState createState() =>
      _AgencyDashboardPageState(userId: userId);
}

class _AgencyDashboardPageState extends State<AgencyDashboardPage> {
  String userId;
  _AgencyDashboardPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'My dashboard',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),

              //user since
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('user_id', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return userSince(0);
                    } else {
                      if (snapshot.data.docs.length == 0) {
                        return userSince(0);
                      } else {
                        var date = snapshot.data.docs[0]['creation_date'];
                        return userSince(date);
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Total rental
                  Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Vehicles')
                          .where('vehicle_owner', isEqualTo: userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return totalRental('...');
                        } else {
                          if (snapshot.data.docs.length == 0) {
                            return totalRental('0');
                          } else {
                            String count = snapshot.data.docs.length.toString();
                            return totalRental(count);
                          }
                        }
                      },
                    ),
                  ),

                  //Total trucks
                  Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Trucks')
                          .where('vehicle_owner', isEqualTo: userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return totalTrucks('...');
                        } else {
                          if (snapshot.data.docs.length == 0) {
                            return totalTrucks('0');
                          } else {
                            String count = snapshot.data.docs.length.toString();
                            return totalTrucks(count);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  Text(
                    'Rental cars',
                    style: GoogleFonts.quicksand(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 0.0,
              ),

              //rental cars data
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Rental')
                      .where('vehicle_owner', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _emptyView();
                    } else {
                      if (snapshot.data.docs.length == 0) {
                        return _emptyView();
                      } else {
                        return _rentalCars(snapshot);
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  Text(
                    'Routes',
                    style: GoogleFonts.quicksand(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.0,
              ),

              //truck routes data
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('TruckRoutes')
                      .where('route_poster', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _emptyView();
                    } else {
                      if (snapshot.data.docs.length == 0) {
                        return _emptyView();
                      } else {
                        return _routes(snapshot);
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget totalRental(String count) {
    return Container(
      height: 80,
      width: (MediaQuery.of(context).size.width / 2) - 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 4,
            offset: Offset(2, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Rental',
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                  ),
                ),
                Text(
                  count,
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.car_rental,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //total trucks
  Widget totalTrucks(String count) {
    return Container(
      height: 80,
      width: (MediaQuery.of(context).size.width / 2) - 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 4,
            offset: Offset(2, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total trucks',
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                  ),
                ),
                Text(
                  count,
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  FontAwesomeIcons.truckMoving,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //user since
  Widget userSince(var date) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 4,
            offset: Offset(2, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User since',
                    style: GoogleFonts.quicksand(
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    //DateFormat('dd/MM/yyyy, hh : mm a').format(date),
                    DateFormat('dd-MM-yyyy')
                        .format(new DateTime.fromMillisecondsSinceEpoch(date)),
                    style: GoogleFonts.quicksand(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //user since
  Widget _rentalCars(AsyncSnapshot<dynamic> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataTable(
          checkboxHorizontalMargin: 2,
          dividerThickness: 2,
          showBottomBorder: true,
          columnSpacing: 30,
          horizontalMargin: 0,
          columns: [
            DataColumn(
              label: Text(
                'Model',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Number',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Visits',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          rows: _buildList(context, snapshot.data.docs),
        ),
      ],
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(cells: [
      DataCell(
        Text(
          data['vehicle_model'],
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ),
      DataCell(
        Text(
          data['vehicle_name'],
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ),
      ),
      DataCell(
        Text(
          data['vehicle_visits'].toString(),
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    ]);
  }

  //empty rental cars
  Widget _emptyView() {
    return Container(
      height: MediaQuery.of(context).size.width / 1.5,
      child: Center(
        child: Image(
          height: 190,
          image: AssetImage(
            'assets/images/empty.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //routes
  Widget _routes(AsyncSnapshot<dynamic> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataTable(
          checkboxHorizontalMargin: 2,
          dividerThickness: 2,
          showBottomBorder: true,
          columnSpacing: 30,
          horizontalMargin: 0,
          columns: [
            DataColumn(
              label: Text(
                'Model',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Number',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Requests',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          rows: _buildRoutesList(context, snapshot.data.docs),
        ),
      ],
    );
  }

  List<DataRow> _buildRoutesList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListRouteItem(context, data)).toList();
  }

  DataRow _buildListRouteItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(cells: [
      DataCell(
        Text(
          data['route_truck_model'],
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ),
      DataCell(
        Text(
          data['route_truck'],
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ),
      ),
      DataCell(
        Text(
          data['route_requests'].toString(),
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    ]);
  }
}
