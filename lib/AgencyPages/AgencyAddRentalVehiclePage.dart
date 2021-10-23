import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AgencyAddRentalVehiclePage extends StatefulWidget {
  final String userId;
  AgencyAddRentalVehiclePage({this.userId});

  @override
  _AgencyAddRentalVehiclePageState createState() =>
      _AgencyAddRentalVehiclePageState(userId: userId);
}

class _AgencyAddRentalVehiclePageState
    extends State<AgencyAddRentalVehiclePage> {
  String userId;
  _AgencyAddRentalVehiclePageState({this.userId});

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  int tag = 0;
  List<String> options = [
    'Vehicle only',
    'Vehicle with driver',
  ];

  //new
  File _imageFile1;
  File _imageFile2;
  File _imageFile3;
  File _imageFile4;
  String plateNumber = '';
  String vehicleModel = '';
  String formattedPlateNumber = '';
  String _description = '';
  String _price = '';
  String _navigationOption = 'Vehicle only';
  String _uploadedFileURL1;
  String _uploadedFileURL2;
  String _uploadedFileURL3;
  String _uploadedFileURL4;
  PickResult selectedCarLocation;

  _submitRentalCar() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Rental')
        .doc(formattedPlateNumber);
    Map<String, dynamic> tasks = {
      'vehicle_name': plateNumber,
      'vehicle_type': 'Rental',
      'vehicle_model': vehicleModel,
      'vehicle_description': _description,
      'vehicle_location': selectedCarLocation.formattedAddress,
      'vehicle_location_longitude': selectedCarLocation.geometry.location.lng,
      'vehicle_location_latitude': selectedCarLocation.geometry.location.lat,
      'vehicle_price': _price,
      'vehicle_renting_option': _navigationOption,
      'vehicle_image_one': _uploadedFileURL1,
      'vehicle_image_two': _uploadedFileURL2,
      'vehicle_image_three': _uploadedFileURL3,
      'vehicle_image_four': _uploadedFileURL4,
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
                        'Vehicle submitted!',
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
                        'Your vehicle has successfully been submitted as rental!',
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
          'Add rental vehicle',
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
                        'Add new\nrental vehicle',
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
                        'Select 4 vehicle images',
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
                        height: 200.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.0),
                              ),
                              child: Container(
                                height: 200.0,
                                width: 300.0,
                                child: InkWell(
                                  child: _imageFile1 == null
                                      ? Image(
                                          image: AssetImage(
                                            'assets/images/add_image_holder.jpg',
                                          ),
                                          fit: BoxFit.cover,
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
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.0),
                              ),
                              child: Container(
                                height: 200.0,
                                width: 300.0,
                                child: InkWell(
                                  child: _imageFile2 == null
                                      ? Image(
                                          image: AssetImage(
                                            'assets/images/add_image_holder.jpg',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : Image(
                                          image: FileImage(_imageFile2),
                                          fit: BoxFit.cover,
                                        ),
                                  onTap: () {
                                    getImage2();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.0),
                              ),
                              child: Container(
                                height: 200.0,
                                width: 300.0,
                                child: InkWell(
                                  child: _imageFile3 == null
                                      ? Image(
                                          image: AssetImage(
                                            'assets/images/add_image_holder.jpg',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : Image(
                                          image: FileImage(_imageFile3),
                                          fit: BoxFit.cover,
                                        ),
                                  onTap: () {
                                    getImage3();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.0),
                              ),
                              child: Container(
                                height: 200.0,
                                width: 300.0,
                                child: InkWell(
                                  child: _imageFile4 == null
                                      ? Image(
                                          image: AssetImage(
                                            'assets/images/add_image_holder.jpg',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : Image(
                                          image: FileImage(_imageFile4),
                                          fit: BoxFit.cover,
                                        ),
                                  onTap: () {
                                    getImage4();
                                  },
                                ),
                              ),
                            ),
                          ],
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
                      InkWell(
                        onTap: () {
                          //_openLocationSheet('StartingPoint');
                          FocusScope.of(context).unfocus();
                          openPickerPage();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 110,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1.0,
                                color: Color(0xff1e407c),
                              ),
                            ),
                            color: Colors.grey[100],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 2.0,
                              bottom: 4.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 8.0,
                                ),
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Vehicle location',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      Text(
                                        selectedCarLocation == null
                                            ? 'Click to pick vehicle location'
                                            : selectedCarLocation
                                                .formattedAddress,
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 18.0,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
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
                        height: 20,
                      ),
                      Text(
                        'Renting options',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.black87,
                          letterSpacing: .5,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      ChipsChoice<int>.single(
                        padding: EdgeInsets.all(0),
                        value: tag,
                        onChanged: (val) {
                          setState(() {
                            tag = val;
                            _navigationOption = options[val];
                          });
                        },
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: options,
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.number,
                        maxLength: 7,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
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
                          labelText: 'Price/hr (Tsh)',
                          contentPadding: const EdgeInsets.all(0.0),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() => _price = val.trim());
                        },
                        validator: (val) =>
                            val.length > 2 ? null : ('Enter a valid price'),
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
                                      _imageFile1 != null &&
                                      _imageFile2 != null &&
                                      _imageFile3 != null &&
                                      _imageFile4 != null) {
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
        _imageFile1 = croppedFile;
        print(_imageFile1.lengthSync());
      },
    );
  }

  Future getImage2() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
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
        _imageFile2 = croppedFile;
        print(_imageFile2.lengthSync());
      },
    );
  }

  Future getImage3() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
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
        _imageFile3 = croppedFile;
        print(_imageFile3.lengthSync());
      },
    );
  }

  Future getImage4() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
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
        _imageFile4 = croppedFile;
        print(_imageFile4.lengthSync());
      },
    );
  }

  //Uploading images
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

        _uploadImage2();
      });
    } on FirebaseException catch (e) {
      print(e.message);
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _uploadImage2() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref('Images/RentalCars/${formattedPlateNumber + '_2.jpg'}')
          .putFile(_imageFile2);
      print('File 1 Uploaded');

      String downloadURL = await storage
          .ref('Images/RentalCars/${formattedPlateNumber + '_2.jpg'}')
          .getDownloadURL();

      setState(() {
        _uploadedFileURL2 = downloadURL;

        _uploadImage3();
      });
    } on FirebaseException catch (e) {
      print(e.message);
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _uploadImage3() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref('Images/RentalCars/${formattedPlateNumber + '_3.jpg'}')
          .putFile(_imageFile3);
      print('File 1 Uploaded');

      String downloadURL = await storage
          .ref('Images/RentalCars/${formattedPlateNumber + '_3.jpg'}')
          .getDownloadURL();

      setState(() {
        _uploadedFileURL3 = downloadURL;

        _uploadImage4();
      });
    } on FirebaseException catch (e) {
      print(e.message);
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _uploadImage4() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref('Images/RentalCars/${formattedPlateNumber + '_4.jpg'}')
          .putFile(_imageFile4);
      print('File 1 Uploaded');

      String downloadURL = await storage
          .ref('Images/RentalCars/${formattedPlateNumber + '_4.jpg'}')
          .getDownloadURL();

      setState(() {
        _uploadedFileURL4 = downloadURL;

        _submitRentalCar();
      });
    } on FirebaseException catch (e) {
      print(e.message);
      setState(() {
        _loading = false;
      });
    }
  }

  //openPickerPage
  openPickerPage() {
    final kInitialPosition = LatLng(-33.8567844, 151.213108);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: 'AIzaSyBa00pyIHQBzvAVEY-2bU3YcS69m-4Tue4',
            initialPosition: kInitialPosition,
            useCurrentLocation: true,
            selectInitialPosition: true,

            //usePlaceDetailSearch: true,
            onPlacePicked: (result) {
              setState(() {
                selectedCarLocation = result;
              });
              print(
                  'Latitudes: ${result.geometry.location.lat} Longitudes: ${result.geometry.location.lng}');
              Navigator.of(context).pop();
            },
            //forceSearchOnZoomChanged: true,
            //automaticallyImplyAppBarLeading: false,
            //autocompleteLanguage: "ko",
            //region: 'au',
            //selectInitialPosition: true,
            // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
            //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
            //   return isSearchBarFocused
            //       ? Container()
            //       : FloatingCard(
            //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
            //           leftPosition: 0.0,
            //           rightPosition: 0.0,
            //           width: 500,
            //           borderRadius: BorderRadius.circular(12.0),
            //           child: state == SearchingState.Searching
            //               ? Center(child: CircularProgressIndicator())
            //               : RaisedButton(
            //                   child: Text("Pick Here"),
            //                   onPressed: () {
            //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
            //                     //            this will override default 'Select here' Button.
            //                     print("do something with [selectedPlace] data");
            //                     Navigator.of(context).pop();
            //                   },
            //                 ),
            //         );
            // },
            // pinBuilder: (context, state) {
            //   if (state == PinState.Idle) {
            //     return Icon(Icons.favorite_border);
            //   } else {
            //     return Icon(Icons.favorite);
            //   }
            // },
          );
        },
      ),
    );
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
