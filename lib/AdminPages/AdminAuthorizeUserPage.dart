import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAuthorizeUserPage extends StatefulWidget {
  @override
  _AdminAuthorizeUserPageState createState() => _AdminAuthorizeUserPageState();
}

class _AdminAuthorizeUserPageState extends State<AdminAuthorizeUserPage> {
  final _formKey = GlobalKey<FormState>();
  String _addedPhone = '';
  bool _loading = false;
  String _selectedCategory = 'Editor';

  final List<String> _userCategories = [
    'Editor',
    'Admin',
  ];

  _submitUser() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Authorized').doc();
    Map<String, dynamic> tasks = {
      'user_phone': _addedPhone,
      'user_authority': _selectedCategory,
      'user_extra': 'Extra',
    };
    ds.set(tasks).whenComplete(
      () {
        print('user authorized');
        _displayAuthorizationCompleteDialog();
        setState(() {
          _loading = false;
        });
      },
    );
  }

  _displayAuthorizationCompleteDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
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
                        height: 16,
                      ),
                      Text(
                        'Authorized!',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
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
                        'The user with phone number "$_addedPhone" has successfully been authorized to sign up as an $_selectedCategory.',
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
                      SizedBox(
                        width: 320.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _addedPhone = '';
                            });
                          },
                          child: Text(
                            "Okay",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blueGrey,
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text('Authorize a user'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
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
                        'Authorize\nan admin or an editor',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                        value: _selectedCategory ?? 'Editor',
                        items: _userCategories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedCategory = val);
                        },
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Authority',
                          labelStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              letterSpacing: .5,
                              fontSize: 20,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 15.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Color(0xff1e407c),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          errorStyle: TextStyle(
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        maxLength: 13,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'User phone',
                          labelStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              letterSpacing: .5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Color(0xff1e407c),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                          errorStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              color: Colors.brown,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _addedPhone = val);
                        },
                        validator: (val) =>
                            (val.contains('+255') && val.length == 13)
                                ? null
                                : 'Enter a valid phone number (Eg: +255 ...)',
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _loading
                          ? Container(
                              decoration: new BoxDecoration(
                                  color: Color(0xff1e407c),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(4.0))),
                              width: double.infinity,
                              height: 48.0,
                              child: Center(
                                child: SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                            )
                          : ButtonTheme(
                              height: 48,
                              child: FlatButton(
                                color: Color(0xff1e407c),
                                child: Text(
                                  'Authorize',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff1e407c), width: 2),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                padding: const EdgeInsets.all(10),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => _loading = true);
                                    FocusScope.of(context).unfocus();
                                    _submitUser();
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Fill valid user emails!',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                },
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
}
