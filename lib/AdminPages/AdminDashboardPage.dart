import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/AdminPages/AdminRentalCarsPage.dart';
import 'package:safirisha/AdminPages/AdminRoutesPage.dart';
import 'package:safirisha/AdminPages/AdminSendNotificationsPage.dart';
import 'package:safirisha/AdminPages/AdminTransactionsPage.dart';
import 'package:safirisha/AdminPages/AdminUsersPage.dart';
import 'package:safirisha/GlobalWidgets/NewAddCorneredButton.dart';

class AdminDashboardPage extends StatefulWidget {
  final String userId;
  final userSnap;
  AdminDashboardPage({this.userId, this.userSnap});

  @override
  _AdminDashboardPageState createState() =>
      _AdminDashboardPageState(userId: userId, userSnap: userSnap);
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String userId;
  var userSnap;
  _AdminDashboardPageState({this.userId, this.userSnap});

  int allUsers = 0;
  int usersThisWeek = 0;
  int usersThisMonth = 0;
  int companyCount = 0;
  int personalCount = 0;
  DateTime date = new DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    getUsers();
    super.initState();
  }

  getUsers() {
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        allUsers = querySnapshot.size;
      });
      print('There are ' + querySnapshot.size.toString());
      //
    });

    FirebaseFirestore.instance
        .collection('Users')
        .where('creation_date',
            isGreaterThan:
                date.subtract(Duration(days: 7)).millisecondsSinceEpoch)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        usersThisWeek = querySnapshot.size;
      });
      print('This week ' + querySnapshot.size.toString());
      //
    });

    FirebaseFirestore.instance
        .collection('Users')
        .where('creation_date',
            isGreaterThan:
                date.subtract(Duration(days: 30)).millisecondsSinceEpoch)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        usersThisMonth = querySnapshot.size;
      });
      print('This month ' + querySnapshot.size.toString());
      //
    });

    FirebaseFirestore.instance
        .collection('Users')
        .where('account_type', isEqualTo: 'Company')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        companyCount = querySnapshot.size;
      });
      print('Companies ' + querySnapshot.size.toString());
      //
    });

    FirebaseFirestore.instance
        .collection('Users')
        .where('account_type', isEqualTo: 'Personal')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        personalCount = querySnapshot.size;
      });
      print('Personal ' + querySnapshot.size.toString());
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text('Dashboard'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      companyUserVariations(),
                      SizedBox(
                        height: 20,
                      ),
                      companiesDenomination(),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          Text(
                            'Actions',
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(0),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        crossAxisCount: 2,
                        childAspectRatio: (2 / 1.3),
                        shrinkWrap: true,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => AdminUsersPage(),
                                ),
                              );
                            },
                            child: newAddCorneredButton(
                              'Manage users',
                              FontAwesomeIcons.usersCog,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => AdminTransactionsPage(
                                    userId: userId,
                                    userSnap: userSnap,
                                  ),
                                ),
                              );
                            },
                            child: newAddCorneredButton(
                              'Transactions',
                              FontAwesomeIcons.moneyCheckAlt,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => AdminRoutesPage(
                                    userId: userId,
                                  ),
                                ),
                              );
                            },
                            child: newAddCorneredButton(
                              'Routes',
                              FontAwesomeIcons.route,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => AdminRentalCarsPage(
                                    userId: userId,
                                  ),
                                ),
                              );
                            },
                            child: newAddCorneredButton(
                              'Car renting',
                              FontAwesomeIcons.key,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => AdminSendNotificationsPage(
                                    userId: userId,
                                    userSnap: userSnap,
                                  ),
                                ),
                              );
                            },
                            child: newAddCorneredButton(
                              'Notifications',
                              FontAwesomeIcons.bell,
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     // Navigator.push(
                          //     //   context,
                          //     //   CupertinoPageRoute(
                          //     //     builder: (_) => AdminApplicantsPage(),
                          //     //   ),
                          //     // );
                          //   },
                          //   child: newAddCorneredButton(
                          //     'Plans and offers',
                          //     FontAwesomeIcons.cubes,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //Company user variations
  Widget companyUserVariations() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xff1287c3),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                color: Color(0xff1287c3),
                height: 1,
                width: 16,
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  'USER GROWTH',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Color(0xff1287c3),
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    allUsers.toString(),
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Total number',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        '100%',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    usersThisWeek.toString(),
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Last 7 days',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      ((usersThisWeek - 7) / 7 * 100) > 0
                          ? Icon(
                              Icons.arrow_drop_up,
                              color: Color(0xff12c3a6),
                              size: 14,
                            )
                          : Icon(
                              Icons.arrow_drop_down,
                              color: Colors.red,
                              size: 14,
                            ),
                      ((usersThisWeek - 7) / 7 * 100) > 0
                          ? Text(
                              ((usersThisWeek - 7) / 7 * 100)
                                      .abs()
                                      .toStringAsFixed(0) +
                                  ' %',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Color(0xff12c3a6),
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                            )
                          : Text(
                              ((usersThisWeek - 7) / 7 * 100)
                                      .abs()
                                      .toStringAsFixed(0) +
                                  ' %',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    usersThisMonth.toString(),
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Last 30 days',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      ((usersThisMonth - 30) / 30 * 100) > 0
                          ? Icon(
                              Icons.arrow_drop_up,
                              color: Color(0xff12c3a6),
                              size: 14,
                            )
                          : Icon(
                              Icons.arrow_drop_down,
                              color: Colors.red,
                              size: 14,
                            ),
                      ((usersThisMonth - 30) / 30 * 100) > 0
                          ? Text(
                              ((usersThisMonth - 30) / 30 * 100)
                                      .abs()
                                      .toStringAsFixed(0) +
                                  ' %',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Color(0xff12c3a6),
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                            )
                          : Text(
                              ((usersThisMonth - 30) / 30 * 100)
                                      .abs()
                                      .toStringAsFixed(0) +
                                  ' %',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'The original number comes from the assumption that, the average growth is 1 user per day.',
              style: GoogleFonts.quicksand(
                fontSize: 12,
                color: Colors.black87,
                letterSpacing: .5,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget companiesDenomination() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xff1287c3),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                color: Color(0xff1287c3),
                height: 1,
                width: 16,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'USER DISTRIBUTION',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Color(0xff1287c3),
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: companyCount,
                  child: Container(
                    height: 10,
                    color: Color(0xff1287c3),
                  ),
                ),
                Expanded(
                  flex: personalCount,
                  child: Container(
                    height: 10,
                    color: Color(0xff12c3a6),
                  ),
                ),
                Expanded(
                  flex: allUsers - (companyCount + personalCount),
                  child: Container(
                    height: 10,
                    color: Color(0xffe91632),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        height: 8,
                        width: 16,
                        color: Color(0xff1287c3),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agency accounts',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                        Text(
                          '$companyCount accounts',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        height: 8,
                        width: 16,
                        color: Color(0xff12c3a6),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal accounts',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                        Text(
                          '$personalCount accounts',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        height: 8,
                        width: 16,
                        color: Color(0xffe91632),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Other accounts',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                        Text(
                          ((allUsers - (companyCount + personalCount))
                                  .toString() +
                              ' accounts'),
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget journalistDenomination() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xff1287c3),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                color: Color(0xff1287c3),
                height: 1,
                width: 16,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                ('JOURNALISTS: 23'),
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Color(0xff1287c3),
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 10,
                    color: Color(0xff1287c3),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 10,
                    color: Color(0xfff88b40),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        height: 8,
                        width: 16,
                        color: Color(0xff1287c3),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Journalists with\nregular accounts',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                        Text(
                          '23 journalists',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        height: 8,
                        width: 16,
                        color: Color(0xfff88b40),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Journalists with\nPRO accounts',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                        Text(
                          '5 journalists',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.black87,
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
