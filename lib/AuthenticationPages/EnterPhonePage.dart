import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/AuthenticationPages/CompleteVerificationPage.dart';
import 'package:safirisha/animations/FadeAnimations.dart';

class EnterPhonePage extends StatefulWidget {
  @override
  _EnterPhonePageState createState() => _EnterPhonePageState();
}

class _EnterPhonePageState extends State<EnterPhonePage> {
  String _input = '';
  final _formKey = GlobalKey<FormState>();
  String _phone = '';
  bool _loading = false;

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
              'Create account',
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
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    'assets/images/enter_number.png',
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
                            Text(
                              'Enter your phone \nnumber to create account',
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
                            Text(
                              'We will send you one time \nverification code',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                  letterSpacing: .5,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                            1.2,
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 180,
                              ),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 16,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                    //letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  labelText: 'Phone',
                                  labelStyle: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.brown,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _input = val.trim();
                                  });
                                },
                                validator: (val) => (val.length < 10)
                                    ? 'Enter a valid number'
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          FadeAnimation(
                            1.4,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SizedBox(
                                height: 48.0,
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate()) {
                                      reFormatPhone();
                                    } else {
                                      var snackBar = SnackBar(
                                        content: Text(
                                          'Enter a valid number!',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Text(
                                    'Send',
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
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
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

  reFormatPhone() {
    if ((_input[0] == '+') && (_input.length == 13)) {
      setState(() {
        _phone = _input;
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => CompleteVerificationPage(
              phone: _phone,
            ),
          ),
        );
      });
    } else if ((_input[0] == '0') && (_input.length == 10)) {
      setState(() {
        _phone = _input.replaceFirst(RegExp('0'), '+255');
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => CompleteVerificationPage(
              phone: _phone,
            ),
          ),
        );
      });
    } else if ((_input[0] + _input[1] + _input[2] == '255') &&
        (_input.length == 12)) {
      setState(() {
        _phone = _input.replaceFirst(RegExp('255'), '+255');
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => CompleteVerificationPage(
              phone: _phone,
            ),
          ),
        );
      });
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => CompleteVerificationPage(
            phone: _input,
          ),
        ),
      );
    }
  }
}
