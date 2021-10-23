import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddInstitutionPage extends StatefulWidget {
  @override
  _AddInstitutionPageState createState() => _AddInstitutionPageState();
}

class _AddInstitutionPageState extends State<AddInstitutionPage> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  bool _loading = false;
  File _imageFile;
  String _uploadedFileURL;
  String institutionName = '';
  String formattedName = '';
  String registrationNumber = '-';
  String institutionWebsite = '-';
  String oldInstitutionId = '-';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black87,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            height: 160.0,
                            width: 160.0,
                            child: InkWell(
                              child: _imageFile == null
                                  ? CircleAvatar(
                                      //backgroundColor: Colors.red,
                                      backgroundImage: AssetImage(
                                          'assets/images/institution_holder.jpg'),
                                      //foregroundColor: Colors.white,
                                      radius: 80,
                                      //child: Text('Select Image'),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      backgroundImage: FileImage(_imageFile),
                                      foregroundColor: Colors.white,
                                      radius: 80,
                                      //child: Text('Select Image'),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Set-up a \npersonal account',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _openInstitutions();
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Name',
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => institutionName = val.trim());
                          },
                          validator: (val) =>
                              val.length < 5 ? ('Enter a valid name') : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: '-',
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelText: 'Registration number',
                            labelStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                letterSpacing: .5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => registrationNumber = val);
                          },
                          validator: (val) => val.length < 1
                              ? ('Too short, at least 1 chars')
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: '-',
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelText: 'Institution website',
                            labelStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                letterSpacing: .5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => institutionWebsite = val);
                          },
                          validator: (val) => val.length < 1
                              ? ('Too short, at least 1 chars')
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   maxLength: 16,
                        //   style: GoogleFonts.nunito(
                        //     textStyle: TextStyle(
                        //       fontSize: 18.0,
                        //       color: Colors.black54,
                        //       letterSpacing: .5,
                        //     ),
                        //   ),
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.grey[100],
                        //     labelText: 'Phone',
                        //     labelStyle: GoogleFonts.nunito(
                        //       textStyle: TextStyle(
                        //         letterSpacing: .5,
                        //       ),
                        //     ),
                        //     contentPadding: const EdgeInsets.all(0.0),
                        //     errorStyle: TextStyle(color: Colors.brown),
                        //   ),
                        //   onChanged: (val) {
                        //     setState(() => userPhone = val);
                        //   },
                        //   validator: (val) => val.length < 10
                        //       ? ('Enter a valid phone number')
                        //       : null,
                        // ),
                        SizedBox(
                          height: 30,
                        ),
                        _loading
                            ? Container(
                                decoration: new BoxDecoration(
                                    color: Color(0xff3aa792),
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
                                  color: Color(0xff3aa792),
                                  child: Text(
                                    'Submit',
                                    style: GoogleFonts.quicksand(
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
                                        color: Color(0xff3aa792), width: 2),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => _loading = true);
                                      _startUpload();
                                    } else {
                                      var snackBar = SnackBar(
                                        content: Text(
                                          'Please fill everything!',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    // if (_imageFile == null) {
                                    //   final snackBar = SnackBar(
                                    //     content: Text(
                                    //       'Select image!',
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //   );
                                    //   Scaffold.of(context)
                                    //       .showSnackBar(snackBar);
                                    // } else {
                                    //   if (_formKey.currentState.validate()) {
                                    //     setState(() => _loading = true);
                                    //     _startUpload();
                                    //   } else {
                                    //     final snackBar = SnackBar(
                                    //       content: Text(
                                    //         'Please fill everything!',
                                    //         textAlign: TextAlign.center,
                                    //       ),
                                    //     );
                                    //     Scaffold.of(context)
                                    //         .showSnackBar(snackBar);
                                    //   }
                                    // }
                                  },
                                ),
                              ),
                        SizedBox(
                          height: 60,
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
    String nameId = '';
    setState(() {
      nameId = (institutionName.replaceAll(new RegExp(r'[^\w\s]+'), ''))
          .replaceAll("  ", " ")
          .replaceAll(" ", "_");
      formattedName = nameId;
    });
    print((institutionName.replaceAll(new RegExp(r'[^\w\s]+'), ''))
        .replaceAll("  ", " ")
        .replaceAll(" ", "_"));

    String finalString = '';
    finalString = (institutionName.replaceAll(new RegExp(r'[^\w\s]+'), ''))
        .replaceAll("  ", " ");

    String number = finalString.toLowerCase();
    List<String> listKeys = number.split("");
    List<String> output = []; // int -> String
    for (int i = 0; i < listKeys.length; i++) {
      if (i != listKeys.length - 1) {
        output.add(listKeys[i]); //
      }
      List<String> temp = [listKeys[i]];
      for (int j = i + 1; j < listKeys.length; j++) {
        temp.add(listKeys[j]); //
        output.add((temp.join()));
      }
    }
    output.toSet().toList();
    output.remove(' ');

    if (_imageFile == null) {
      createData(output);
    } else {
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      try {
        await storage.ref('Institutions/Logos/$nameId.jpg').putFile(_imageFile);
        print('File Uploaded');

        String downloadURL = await storage
            .ref('Institutions/Logos/$nameId.jpg')
            .getDownloadURL();

        setState(
          () {
            _uploadedFileURL = downloadURL;
            createData(output);
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

  createData(List<dynamic> keysList) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('InstitutionsDatabase')
        .doc('Tanzania')
        .collection('Active')
        .doc(formattedName);
    Map<String, dynamic> tasks = {
      'institution_name': institutionName,
      'institution_type': '-',
      'institution_verification': 'Verified',
      'institution_email': '-',
      'institution_id': formattedName,
      'institution_reg_id': registrationNumber,
      'institution_image': _imageFile == null
          ? 'https://firebasestorage.googleapis.com/v0/b/uniccus-2019.appspot.com/o/PlaceHolders%2Finstitution_holder.jpg?alt=media&token=05b8d475-f296-4465-80a9-9b57dd113852'
          : _uploadedFileURL,
      'institution_phone': '-',
      'institution_city': '-',
      'institution_plan': '-',
      'institution_locality': 'Tanzania',
      'institution_description':
          'Hello there! We are ${institutionName[0].toUpperCase()}${institutionName.substring(1).toLowerCase()}. We are on Uniccus.',
      'institution_link': institutionWebsite,
      'institution_students_count': 0,
      'institution_staff_count': 0,
      'institution_action_title': '-',
      'notification_count': 0,
      'institution_device_token': '-',
      'institution_creation_date': DateTime.now().millisecondsSinceEpoch,
      'institution_facebook_profile': '-',
      'institution_instagram_profile': '-',
      'institution_linked_in_profile': '-',
      'institution_password': '123456',
      'institution_extra': 'extra',
      'search_keywords': FieldValue.arrayUnion(keysList),
    };
    ds.set(tasks).whenComplete(() {
      //sendNotification();
      setState(() {
        _loading = false;
      });
      print('New institution created');
      DocumentReference ds = FirebaseFirestore.instance
          .collection('Institutions')
          .doc(oldInstitutionId);
      Map<String, dynamic> tasks = {
        'activation_status': 'Copied',
      };
      ds.update(tasks).whenComplete(() {
        print('Old institution updated');
      });
    });
  }

  getKeys() {
    List<String> outputOne = [];
    String nameId = 'ABDULRAHMAN AL- SUMAIT MEMORIAL UNIVERSITY - MAGHARIBI';
    String finalString = '';
    finalString =
        (nameId.replaceAll(new RegExp(r'[^\w\s]+'), '')).replaceAll("  ", " ");
    outputOne = finalString.split(" ");
    //print(outputOne);

    String number = 'abc dea';
    List<String> listnumber = number.split("");
    List<String> output = []; // int -> String
    for (int i = 0; i < listnumber.length; i++) {
      if (i != listnumber.length - 1) {
        output.add(listnumber[i]); //
      }
      List<String> temp = [listnumber[i]];
      for (int j = i + 1; j < listnumber.length; j++) {
        temp.add(listnumber[j]); //
        output.add((temp.join()));
      }
    }
    print(output.toString());
    print(output.toSet().toList());
    output.remove(' ');
    print(output);

    // var ids = [1, 4, 4, 4, 5, 6, 6];
    // var distinctIds = ids.toSet().toList();
    //print(output.toString());
  }

  _openInstitutions() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Material(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Institutions')
              .orderBy('institution_name', descending: false)
              .where('activation_status', isEqualTo: 'Active')
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 240,
                child: Center(
                  child: SpinKitThreeBounce(
                    color: Colors.black54,
                    size: 20.0,
                  ),
                ),
              );
            } else {
              if (snapshot.data.docs.length == 0) {
                return Container(
                  height: 240,
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/images/empty.png'),
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myInstitution = snapshot.data.docs[index];
                    return institutionItem(index, myInstitution);
                  },
                );
              }
            }
          },
        ),
      ),
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
              takeAction(myInstitution);
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

  takeAction(DocumentSnapshot<Object> myInstitution) {
    nameController.text = myInstitution['institution_name'];
    setState(() {
      oldInstitutionId = myInstitution.id;
      institutionName = myInstitution['institution_name'];
    });
    Navigator.pop(context, true);
  }
}
