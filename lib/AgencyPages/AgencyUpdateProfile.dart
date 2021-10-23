import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AgencyUpdateProfile extends StatefulWidget {
  final userSnap;
  final String userId;
  AgencyUpdateProfile({this.userSnap, this.userId});

  @override
  _AgencyUpdateProfileState createState() =>
      _AgencyUpdateProfileState(userSnap: userSnap, userId: userId);
}

class _AgencyUpdateProfileState extends State<AgencyUpdateProfile> {
  var userSnap;
  String userId;
  _AgencyUpdateProfileState({this.userSnap, this.userId});

  TextEditingController nameInput;
  TextEditingController bioInput;
  TextEditingController emailInput;

  @override
  void initState() {
    super.initState();
    getInitialValues();
  }

  getInitialValues() {
    nameInput = TextEditingController(text: userSnap['user_name']);
    bioInput = TextEditingController(text: userSnap['about_user']);
    emailInput = TextEditingController(text: userSnap['user_email']);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nameInput.dispose();
    bioInput.dispose();
    emailInput.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String name = '';
  String biography = '';
  String userEmail = '';

  //image capture
  File _imageFile;
  String _uploadedFileURL = '';
  //end of image capture

  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 1000,
      maxWidth: 1000,
      compressQuality: 80,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Color(0xff1e407c),
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    setState(() {
      _imageFile = croppedFile;
      print(_imageFile.lengthSync());
    });
  }

  //create data
  createDataWithNewImage() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(userId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'user_image': _uploadedFileURL,
      'about_user': biography,
      'user_email': userEmail,
    };
    ds.update(tasks).whenComplete(() {
      print('profile updated');
      setState(() {
        //loading = false;
        Navigator.pop(context, true);
      });
    });
  }

  createDataWithOldImage() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(userId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'about_user': biography,
      'user_email': userEmail,
    };
    ds.update(tasks).whenComplete(() {
      print('profile updated');
      setState(() {
        Navigator.pop(context, true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text('Update profile'),
        elevation: 0.0,
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
          return Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xff1e407c),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(0.0),
                                bottomRight: Radius.circular(140.0),
                                topLeft: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0)),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Container(
                                    height: 168.0,
                                    width: 168.0,
                                    child: InkWell(
                                      child: _imageFile == null
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 84,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  userSnap['user_image'],
                                                ),
                                                radius: 80,
                                                //child: Text('Select Image'),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 84,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.blue,
                                                backgroundImage:
                                                    FileImage(_imageFile),
                                                foregroundColor: Colors.white,
                                                radius: 80,
                                                //child: Text('Select Image'),
                                              ),
                                            ),
                                      onTap: () {
                                        getImage();
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Update \nyour account',
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: nameInput,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLength: 30,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'Agent name',
                                  contentPadding: const EdgeInsets.all(0.0),
                                  errorStyle: TextStyle(color: Colors.brown),
                                ),
                                validator: (val) =>
                                    val.isEmpty ? ('Enter a name') : null,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: bioInput,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLength: 300,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'Bio',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 8.0),
                                  errorStyle: TextStyle(color: Colors.brown),
                                ),
                                validator: (val) => val.length < 30
                                    ? ('Too short at least 30 chars')
                                    : null,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: emailInput,
                                keyboardType: TextInputType.emailAddress,
                                maxLength: 40,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'Email',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 0),
                                  errorStyle: TextStyle(color: Colors.brown),
                                ),
                                validator: (val) =>
                                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(val)
                                        ? ('Enter a valid email')
                                        : null,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              loading
                                  ? Container(
                                      width: double.infinity,
                                      decoration: new BoxDecoration(
                                          color: Color(0xff1e407c),
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(4.0))),
                                      height: 48.0,
                                      child: Center(
                                        child: SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    )
                                  : ButtonTheme(
                                      minWidth: double.infinity,
                                      height: 48.0,
                                      child: FlatButton(
                                        color: Color(0xff1e407c),
                                        child: Text(
                                          'Submit',
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                        ),
                                        shape: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff1e407c),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        onPressed: () async {
                                          setState(() {
                                            name = nameInput.text;
                                          });
                                          print(name);
                                          if (_imageFile == null) {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(
                                                () {
                                                  loading = true;
                                                  name = nameInput.text;
                                                  biography = bioInput.text;
                                                  userEmail = emailInput.text;
                                                  createDataWithOldImage();
                                                },
                                              );
                                              // do something
                                            } else {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  'Please fill everything!',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          } else {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                loading = true;
                                                name = nameInput.text;
                                                biography = bioInput.text;
                                                userEmail = emailInput.text;
                                              });
                                              _startUpload();
                                              // do something
                                            } else {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  'Please fill everything!',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                              SizedBox(
                                height: 180,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _startUpload() async {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Profiles/$uid.jpg').putFile(_imageFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Profiles/$uid.jpg').getDownloadURL();

      setState(() {
        _uploadedFileURL = downloadURL;
        createDataWithNewImage();
      });
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
    }
  }
}
