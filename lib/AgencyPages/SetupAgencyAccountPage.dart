import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safirisha/GlobalPages/HomePage.dart';

class SetupAgencyAccountPage extends StatefulWidget {
  final String userId;
  SetupAgencyAccountPage({this.userId});

  @override
  _SetupAgencyAccountPageState createState() =>
      _SetupAgencyAccountPageState(userId: userId);
}

class _SetupAgencyAccountPageState extends State<SetupAgencyAccountPage> {
  String userId;
  _SetupAgencyAccountPageState({this.userId});

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;
  DateTime _date = DateTime.now();
  final databaseReference = FirebaseFirestore.instance;
  final myController = TextEditingController();
  TextEditingController bioController;
  FirebaseMessaging messaging;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  //text field state
  String error = '';
  String name = '';
  String biography = '';
  String userCountry = '';
  String userPhone = 'not set';

  //image capture
  File _imageFile;
  String _uploadedFileURL;
  String onlineUserId;
  String onlineUserEmail;
  String _deviceToken = '';
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
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(
      () {
        _imageFile = croppedFile;
        print(_imageFile.lengthSync());
      },
    );
  }

  //create data
  createData() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(onlineUserId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'account_type': 'Company',
      'email_verification': 'Verified',
      'user_authority': '-',
      'user_email': onlineUserEmail,
      'user_id': onlineUserId,
      'user_image': _uploadedFileURL,
      'user_phone': userPhone,
      'user_city': '-',
      'works_for_firm': 'False',
      'user_plan': '-',
      'user_power': '-',
      'user_locality': 'Tanzania',
      'about_user': bioController.text,
      'external_link': '-',
      'user_verification': '-',
      'user_circle_count': 0,
      'action_title': '',
      'notification_count': 1,
      'make_money': '-',
      'device_token': _deviceToken,
      'creation_date': _date.millisecondsSinceEpoch,
      'feedback_consent': 'True',
      'rated_on_stores': 'False',
      'show_task_dialog': 'False',
      'facebook_profile': '',
      'linked_in_profile': '',
      'user_extra': 'extra',
      'searchKeywords': FieldValue.arrayUnion([
        '${name[0]}',
        '${name[1]}',
        '${name[2]}',
        '${name[3]}',
        '${name[4]}',
        '${name[0]}${name[1]}',
        '${name[0]}${name[1]}${name[2]}',
        '${name[0]}${name[1]}${name[2]}${name[3]}',
        '${name[0]}${name[1]}${name[2]}${name[3]}${name[4]}',
        '$name',
        '${name[0].toLowerCase()}',
        '${name[1].toLowerCase()}',
        '${name[2].toLowerCase()}',
        '${name[3].toLowerCase()}',
        '${name[4].toLowerCase()}',
        '${name[0].toLowerCase()}${name[1].toLowerCase()}',
        '${name[0].toLowerCase()}${name[1].toLowerCase()}${name[2].toLowerCase()}',
        '${name[0].toLowerCase()}${name[1].toLowerCase()}${name[2].toLowerCase()}${name[3].toLowerCase()}',
        '${name[0].toLowerCase()}${name[1].toLowerCase()}${name[2].toLowerCase()}${name[3].toLowerCase()}${name[4].toLowerCase()}',
        '${name.toLowerCase()}',
      ]),
    };
    ds.set(tasks).whenComplete(() {
      sendNotification();
    });
  }

  sendNotification() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(onlineUserId)
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'Karibu $name!',
      'notification_details':
          'Karibu katika Safirisha App. Safirisha inakuwezesha kukamilisha '
              'mahitaji yako ya kusafirisha mizigo na kukodi magari kwaajili ya '
              'shughuli mbalimbali, kwa urahisi. Tunafurahi wewe ni miongoni mwa watumiaji wetu.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Safirisha',
      'action_title': '',
      'action_destination': '',
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(() {
      print('Notification created');
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => HomePage(),
          ),
          (r) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    manageUser();
    bioController = new TextEditingController(
        text:
            'Hello there! I\'m using Safirisha App from Tanzania to get all the logistics services I need. I can transport my goods with ease, I am a proud user of Safirisha App.');
  }

  manageUser() async {
    final User user = _auth.currentUser;
    if (user != null) {
      setState(
        () {
          userPhone = user.phoneNumber;
        },
      );
    } else {
      //out
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('Device token: $deviceToken');
      setState(() {
        _deviceToken = deviceToken;
      });
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        elevation: 0.0,
        brightness: Brightness.dark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            color: Colors.white,
            width: double.infinity,
            child: SingleChildScrollView(
              child: AbsorbPointer(
                absorbing: _loading,
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
                                                //backgroundColor: Colors.red,
                                                backgroundImage: AssetImage(
                                                    'assets/images/holder_agancy.jpg'),
                                                //foregroundColor: Colors.white,
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
                                  'Set-up an \nagency account',
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                maxLength: 30,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black54,
                                    letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'Official name',
                                  contentPadding: const EdgeInsets.all(0.0),
                                  errorStyle: TextStyle(color: Colors.brown),
                                ),
                                onChanged: (val) {
                                  setState(() => name = val.trim());
                                },
                                validator: (val) =>
                                    name.contains(' ') && val.length > 5
                                        ? null
                                        : ('Enter a valid name'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                maxLength: 40,
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black54,
                                    letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'Email',
                                  labelStyle: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(0.0),
                                  errorStyle: TextStyle(color: Colors.brown),
                                ),
                                onChanged: (val) {
                                  setState(() => onlineUserEmail = val);
                                },
                                validator: (val) =>
                                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(val)
                                        ? ('Enter a valid email')
                                        : null,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: bioController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLength: 300,
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black54,
                                    letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  labelText: 'Biography',
                                  labelStyle: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(0.0),
                                  errorStyle: TextStyle(color: Colors.brown),
                                ),
                                onChanged: (val) {
                                  setState(() => biography = val);
                                },
                                validator: (val) => val.length < 30
                                    ? ('Too short, at least 30 chars')
                                    : null,
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
                                      minWidth: double.infinity,
                                      child: FlatButton(
                                        color: Color(0xff1e407c),
                                        child: Text(
                                          'Submit',
                                          style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                        ),
                                        shape: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff1e407c),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          if (_imageFile == null) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Select image!',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() => _loading = true);
                                              _startUpload();
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
                                height: 60,
                              ),
                            ],
                          ),
                        )
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
    _getToken();

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Profiles/$uid.jpg').putFile(_imageFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Profiles/$uid.jpg').getDownloadURL();

      setState(
        () {
          _uploadedFileURL = downloadURL;
          onlineUserId = uid;
          createData();
        },
      );
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        _loading = false;
      });
    }
  }
}
