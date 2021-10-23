import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:safirisha/GlobalPages/wrapper.dart';
import 'package:safirisha/animations/FadeAnimations.dart';

class CompleteVerificationPage extends StatefulWidget {
  final String phone;
  CompleteVerificationPage({this.phone});

  @override
  _CompleteVerificationPageState createState() =>
      _CompleteVerificationPageState(phone: phone);
}

class _CompleteVerificationPageState extends State<CompleteVerificationPage> {
  String phone;
  _CompleteVerificationPageState({this.phone});

  var onTapRecognizer;
  TextEditingController textEditingController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationId = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  //Timer
  Timer _timer;
  int _start = 0;
  bool resendingCode = false;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    verifyPhone();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Enter code',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          0.6,
                          Container(
                            child: Center(
                              child: Image(
                                height: MediaQuery.of(context).size.width / 4,
                                //width: 300,
                                fit: BoxFit.contain,
                                image: AssetImage(
                                  'assets/images/otp_icon.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          0.8,
                          Visibility(
                            visible: resendingCode,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                child: SpinKitFadingCircle(
                                  color: Colors.black87,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        FadeAnimation(
                          0.8,
                          Text(
                            resendingCode
                                ? 'We are sending verification \ncode to "$phone" '
                                : 'We have sent the verification \ncode to "$phone" ',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black87,
                                letterSpacing: .5,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          1.0,
                          OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 40,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.black87,
                              ),
                            ),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onChanged: (pin) {
                              print("Changed: " + pin);
                            },
                            onCompleted: (pin) {
                              print("Completed: " + pin);
                              _signInWithPhoneNumber(pin);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1.2,
                          resendingCode
                              ? Container()
                              : Column(
                                  children: [
                                    Text(
                                      "If you didn't receive any code you can \nresend again in $_start second(s).",
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black87,
                                          letterSpacing: .5,
                                          height: 1.4,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    canResend
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "RESEND",
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Color(0xff1e407c),
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: .5,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "RESEND",
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        FadeAnimation(
                          1.4,
                          Container(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  verifyPhone() async {
    setState(() {
      resendingCode = true;
      canResend = false;
    });
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        if (auth.currentUser != null) {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => Wrapper(),
              ),
              (r) => false);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          _showErrorDialog('Invalid phone number!',
              'The phone number you have entered is invalid, please try again using a valid number.');
        } else if (e.code == 'invalid-verification-code') {
          _showErrorDialog('Invalid code!',
              'The verification code you have entered is invalid, please try again using a valid code.');
        } else {
          _showErrorDialog('Verification failed!', e.message);
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        // Create a PhoneAuthCredential with the code
        print('Code sent');
        startTimer();
        setState(() {
          this._verificationId = verificationId;
          resendingCode = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _showErrorDialog('Time out!',
            'You have run out of time to verify your phone number, click okay to try again.');

        if (this.mounted) {
          setState(() {
            this._verificationId = verificationId;
          });
        }
      },
    );
  }

  void _signInWithPhoneNumber(String smsCode) async {
    PhoneAuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    try {
      await auth.signInWithCredential(_authCredential);
      if (auth.currentUser != null) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => Wrapper(),
            ),
            (r) => false);
      }
    } catch (error) {
      if (error.code == 'invalid-verification-code') {
        _showErrorDialog('Invalid code!',
            'The verification code you have entered is invalid, please try again using a valid code.');
      } else {
        _showErrorDialog('Error occurred!',
            'An expected error has occurred during verification. Click okay to try again.');
      }
      print(error.code);
    }
  }

  void startTimer() {
    setState(() {
      _start = 120;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              canResend = true;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  _showErrorDialog(String title, String body) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ), //this right here
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
                        height: 20,
                      ),
                      Icon(
                        Icons.phonelink_erase_rounded,
                        size: 32.0,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        title,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        body,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                            letterSpacing: .5,
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
                            Navigator.of(context).pop();
                            //Navigator.of(context).pop();
                          },
                          child: Text(
                            'Okay',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 16.0,
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
                        height: 20,
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
