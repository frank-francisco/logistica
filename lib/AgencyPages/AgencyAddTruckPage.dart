import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AgencyAddTruckPage extends StatefulWidget {
  final String userId;
  AgencyAddTruckPage({this.userId});

  @override
  _AgencyAddTruckPageState createState() =>
      _AgencyAddTruckPageState(userId: userId);
}

class _AgencyAddTruckPageState extends State<AgencyAddTruckPage> {
  String userId;
  _AgencyAddTruckPageState({this.userId});

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  //new
  File _imageFile1;
  String plateNumber = '';
  String formattedPlateNumber = '';
  String vehicleModel = '';
  String _description = '';
  String _uploadedFileURL1;

  _submitTruckVehicle() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Trucks')
        .doc(formattedPlateNumber);
    Map<String, dynamic> tasks = {
      'vehicle_name': plateNumber,
      'vehicle_type': 'Truck',
      'vehicle_model': vehicleModel,
      'vehicle_description': _description,
      'vehicle_image': _uploadedFileURL1,
      'vehicle_owner': userId,
      'vehicle_date_posted': DateTime.now().millisecondsSinceEpoch,
      'vehicle_entry_id': ds.id,
      'vehicle_visibility': 'true',
      'vehicle_status': 'on',
      'vehicle_visits': 0,
      'vehicle_requests': 0,
      'vehicle_extra': 'Extra',
    };
    ds.set(tasks).whenComplete(
      () {
        setState(() {
          _loading = false;
        });

        _showDialog();
      },
    );
  }

  _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)), //this right here
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
                        'Truck submitted!',
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
                        'Your truck has successfully been submitted to your listing!',
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
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Okay",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          color: Colors.blue,
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
        title: Text(
          'Add truck vehicle',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                        height: 60,
                      ),
                      Text(
                        'Add new\ntruck vehicle',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Select your truck images',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        child: InkWell(
                          child: _imageFile1 == null
                              ? AspectRatio(
                                  aspectRatio: (3 / 2),
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/add_image_holder.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image(
                                  image: FileImage(_imageFile1),
                                  fit: BoxFit.cover,
                                ),
                          onTap: () {
                            getImage1();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.name,
                        maxLength: 8,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                          new CustomInputFormatter()
                        ],
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black54,
                            letterSpacing: .5,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Plate number',
                          contentPadding: const EdgeInsets.all(0.0),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() => plateNumber = val.trim());
                        },
                        validator: (val) => val.length > 7
                            ? null
                            : ('Enter a valid plate number'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.name,
                        maxLength: 20,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black54,
                            letterSpacing: .5,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Vehicle model',
                          contentPadding: const EdgeInsets.all(0.0),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() => vehicleModel = val.trim());
                        },
                        validator: (val) => val.length > 2
                            ? null
                            : ('Enter a valid vehicle model'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 300,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black54,
                            letterSpacing: .5,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Vehicle description',
                          contentPadding: const EdgeInsets.all(0.0),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() => _description = val.trim());
                        },
                        validator: (val) =>
                            val.length > 50 ? null : ('Too short'),
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
                                  'Submit',
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff1e407c),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                padding: const EdgeInsets.all(10),
                                onPressed: () async {
                                  if (_formKey.currentState.validate() &&
                                      _imageFile1 != null) {
                                    setState(() => _loading = true);
                                    FocusScope.of(context).unfocus();
                                    _uploadImage1();
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Please fill everything!',
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
                                  }
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
          );
        },
      ),
    );
  }

  //select images
  final ImagePicker _picker = ImagePicker();

  Future getImage1() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        maxHeight: 900,
        maxWidth: 1600,
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
        _imageFile1 = croppedFile;
        print(_imageFile1.lengthSync());
      },
    );
  }

  Future<void> _uploadImage1() async {
    setState(() {
      formattedPlateNumber =
          (plateNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''))
              .replaceAll("  ", " ")
              .replaceAll(" ", "_");
    });

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref('Images/RentalCars/${formattedPlateNumber + '_1.jpg'}')
          .putFile(_imageFile1);
      print('File 1 Uploaded');

      String downloadURL = await storage
          .ref('Images/RentalCars/${formattedPlateNumber + '_1.jpg'}')
          .getDownloadURL();

      setState(() {
        _uploadedFileURL1 = downloadURL;

        _submitTruckVehicle();
      });
    } on FirebaseException catch (e) {
      print(e.message);
      setState(() {
        _loading = false;
      });
    }
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
