import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/GlobalPages/GettingStartedScreen.dart';
import 'package:safirisha/GlobalPages/HomePage.dart';
import 'package:safirisha/GlobalPages/SetupAccountPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String onlineUserId;
  String _controller;
  Timer _timer;
  String _selectedLanguage = 'Romanian';

  @override
  void initState() {
    super.initState();
    readSavedLanguage();
    manageUser();
    makeDecision();
  }

  makeDecision() {
    _timer = new Timer(
      const Duration(seconds: 3),
      () {
        print('done');
        if (_controller == 'out') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => GettingStartedScreen(),
              ),
              (r) => false);
        } else if (_controller == 'info') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => SetupAccountPage(),
                //builder: (context) => HomePage(),
              ),
              (r) => false);
        } else if (_controller == 'home') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => HomePage(),
              ),
              (r) => false);
        } else if (_controller == null) {
          MyApp.restartApp(context);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  readSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_language';
    final value = prefs.getString(key) ?? 'Romanian';
    print('read: $value');
    setState(() {
      _selectedLanguage = value;
    });
  }

  manageUser() async {
    final User user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _controller = 'out';
      });
    } else {
      final snapShot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (snapShot.exists) {
        if (this.mounted) {
          setState(() {
            _controller = 'home';
          });
        }

        // setState(() {
        //   _controller = 'home';
        // });
      } else {
        if (this.mounted) {
          setState(() {
            _controller = 'info';
          });
        }

        // setState(() {
        //   _controller = 'info';
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff1e407c),
      // appBar: AppBar(
      //   //brightness: Brightness.dark,
      //   //backgroundColor: Color(0xff1e407c),
      //   elevation: 0.0,
      // ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width / 3,
            ),
            Container(
              child: Center(
                child: Image(
                  //height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                  image: AssetImage(
                    'assets/images/512_transparent_main_bg.png',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              'Safirisha \nYour only logistics partner',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1e407c),
                  letterSpacing: .5,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
