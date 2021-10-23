import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminTransactionsPage extends StatefulWidget {
  final String userId;
  final userSnap;
  AdminTransactionsPage({this.userId, this.userSnap});

  @override
  _AdminTransactionsPageState createState() =>
      _AdminTransactionsPageState(userId: userId, userSnap: userSnap);
}

class _AdminTransactionsPageState extends State<AdminTransactionsPage> {
  String userId;
  var userSnap;
  _AdminTransactionsPageState({this.userId, this.userSnap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xff1e407c),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0.0),
                    bottomRight: Radius.circular(30.0),
                    topLeft: Radius.circular(0.0),
                    bottomLeft: Radius.circular(30.0)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'TRANSACTIONS',
                    style: GoogleFonts.quicksand(
                      fontSize: 24,
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Transactions overview',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.white,
                      letterSpacing: .5,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Text(
                                '0',
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Color(0xff1e407c),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              'Successful',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Text(
                                '0',
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Color(0xff1e407c),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              'Pending',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Text(
                                '0',
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Color(0xff1e407c),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              'Failed',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'TRANSACTIONS HISTORY:',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  displayHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayHistory() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Payments')
          .orderBy('payment_time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 1.5,
            child: Center(
              child: Image(
                image: AssetImage('assets/images/empty.png'),
                width: double.infinity,
              ),
            ),
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 1.5,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/empty.png'),
                  width: double.infinity,
                ),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot myHistory = snapshot.data.docs[index];
                var date = DateTime.fromMillisecondsSinceEpoch(
                    myHistory['payment_status_time']);
                return Container(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              child: myHistory['payment_package'] ==
                                      'SPREAD THE WORD'
                                  ? CircleAvatar(
                                      radius: 20,
                                      child: Text(
                                        'SW',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: Color(0xffe15d12),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      backgroundColor: Color(0xfff8cac0),
                                    )
                                  : myHistory['payment_package'] ==
                                          'BE A PUBLISHER'
                                      ? CircleAvatar(
                                          radius: 20,
                                          child: Text(
                                            'BP',
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: Color(0xff442e4c),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                          backgroundColor: Color(0xfff2e2f7),
                                        )
                                      : myHistory['payment_package'] ==
                                              'GET THE BRAND'
                                          ? CircleAvatar(
                                              radius: 20,
                                              child: Text(
                                                'GB',
                                                style: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  color: Color(0xff2c2c0c),
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: .5,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Color(0xffd6f3de),
                                            )
                                          : myHistory['payment_package'] ==
                                                  'PROMOTE YOUR MESSAGE'
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  child: Text(
                                                    'PM',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 14,
                                                      color: Color(0xff2c2c0c),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: .5,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Color(0xfff8f8c0),
                                                )
                                              : CircleAvatar(
                                                  radius: 20,
                                                  child: Text(
                                                    '*',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 14,
                                                      color: Color(0xff1e407c),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: .5,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Color(0xfff8cac0),
                                                ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  //width: MediaQuery.of(context).size.width - 92,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        myHistory['payment_package'],
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      Text(
                                        myHistory['payment_currency'] +
                                            ' ' +
                                            myHistory['payment_amount']
                                                .toString(),
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 92,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.yMMMd().format(date),
                                        style: GoogleFonts.openSans(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      Text(
                                        'SUCCESS',
                                        style: GoogleFonts.openSans(
                                          fontSize: 12,
                                          color: Colors.green,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 6.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 92,
                                  //color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                        height: 14,
                                        image: AssetImage(
                                          'assets/images/netopia_banner_blue.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //downloadAndSendStatus(),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 92,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2.0,
                                              color: Color(0xff1e407c),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              'Download',
                                              style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Color(0xff1e407c),
                                                  // fontWeight:
                                                  //     FontWeight.bold,
                                                  letterSpacing: .5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.0, color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            'Download',
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                                // fontWeight:
                                                //     FontWeight.bold,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2.0,
                                              color: Colors.green,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              'Send To Email',
                                              style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.green,
                                                  // fontWeight:
                                                  //     FontWeight.bold,
                                                  letterSpacing: .5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.0, color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            'Send To Email',
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                                // fontWeight:
                                                //     FontWeight.bold,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
                //pressItem(index, myPresses);
              },
            );
          }
        }
      },
    );
  }
}
