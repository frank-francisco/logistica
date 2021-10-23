import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:safirisha/AdminPages/AdminSetupAccountPage.dart';
import 'package:safirisha/AgencyPages/SetupAgencyAccountPage.dart';
import 'package:safirisha/GlobalPages/GettingStartedScreen.dart';
import 'package:safirisha/OneTimeUsePages/AddStudentsPage.dart';
import 'package:safirisha/PersonalPages/SetupPersonalAccountPage.dart';

class SetupAccountPage extends StatefulWidget {
  @override
  _SetupAccountPageState createState() => _SetupAccountPageState();
}

class _SetupAccountPageState extends State<SetupAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;
  bool _error = false;
  bool _resultVisibility = false;
  String _errorMessage = '';

  String institutionName = '';
  String studentId = '';

  //
  String userId = '';
  String userPhone = '';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  getUserId() {
    final User user = auth.currentUser;
    userId = user.uid;
    userPhone = user.phoneNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Choose account type',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              //fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: .5,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.minHeight,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: double.infinity,
                        child: Center(
                          child: Image(
                            height: MediaQuery.of(context).size.width / 4,
                            //width: 300,
                            fit: BoxFit.contain,
                            image: AssetImage(
                              'assets/images/choose_icon_1.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Choose \nyour account type',
                        style: GoogleFonts.quicksand(
                          fontSize: 24,
                          color: Color(0xff1e407c),
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Please select what type of account you\'re signing up with.',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 14.0,
                            letterSpacing: .5,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 46.0,
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => SetupAgencyAccountPage(
                                      userId: userId,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Agency',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Color(0xff1e407c),
                                onSurface: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 46.0,
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => SetupPersonalAccountPage(
                                      userId: userId,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Personal',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Color(0xff1e407c),
                                onSurface: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _checkIfAuthorized(),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        height: 46.0,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            _logOut();
                          },
                          child: Text(
                            '- Log out -',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xffC13584),
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            primary: Color(0xff1e407c),
                            backgroundColor: Colors.white,
                            onSurface: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  openInstitutionsSearch() {
    String searchInput = '';
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return Material(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('InstitutionsDatabase')
                .doc('Tanzania')
                .collection('Active')
                .orderBy('institution_name', descending: false)
                .where("search_keywords",
                    arrayContains: searchInput.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              return Container(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search...'),
                      onChanged: (val) {
                        setModalState(
                          () {
                            searchInput = val;
                          },
                        );
                      },
                    ),
                    !snapshot.hasData
                        ? Container(
                            height: 240,
                            child: Center(
                              child: SpinKitThreeBounce(
                                color: Colors.black54,
                                size: 20.0,
                              ),
                            ),
                          )
                        : (snapshot.data.docs.length == 0
                            ? Container(
                                height: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.search,
                                      color: Colors.grey[400],
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    searchInput == ''
                                        ? Text(
                                            'Type something to \nstart searching',
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .5,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            'Nothing found to match \nyour search',
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .5,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  ],
                                )

                                    // Image(
                                    //   image:
                                    //       AssetImage('assets/images/empty.png'),
                                    //   width:
                                    //       MediaQuery.of(context).size.width / 2,
                                    // ),
                                    ),
                              )
                            : ListView.builder(
                                //shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot myInstitution =
                                      snapshot.data.docs[index];
                                  return institutionItem(index, myInstitution);
                                },
                              )),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget institutionItem(int index, DocumentSnapshot<Object> myInstitution) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              print(myInstitution['institution_name']);
              setState(() {
                institutionName = myInstitution['institution_name'];
              });
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 10.0,
              ),
              child: Text(
                myInstitution['institution_name'],
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _checkIfAuthorized() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Authorized')
            .where('user_phone', isEqualTo: userPhone)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                //color: Colors.white,
                );
          } else {
            if (snapshot.data.docs.length == 0) {
              return Container(
                  //color: Colors.white,
                  );
            } else {
              DocumentSnapshot myData = snapshot.data.docs[0];
              return Visibility(
                visible: true,
                child: Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.error_outline,
                              size: 24,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Looks like you are authorized to join the Management team as an ${myData['user_authority']}. Click the button below to continue.',
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        myData['user_authority'] == 'Admin'
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('Administrator'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (_) => AdminSetupAccountPage(
                                            userId: userId,
                                            userPhone: userPhone,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    child: const Text('Editor'),
                                    onPressed: null,
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('Administrator'),
                                    onPressed: null,
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    child: const Text('Editor'),
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //     builder: (_) =>
                                      //         EditorSetupAccountPage(),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}
