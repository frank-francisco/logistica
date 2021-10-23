import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class AgencyUpdateRentalVehiclePage extends StatefulWidget {
  final carSnap;
  AgencyUpdateRentalVehiclePage({this.carSnap});

  @override
  _AgencyUpdateRentalVehiclePageState createState() =>
      _AgencyUpdateRentalVehiclePageState(carSnap: carSnap);
}

class _AgencyUpdateRentalVehiclePageState
    extends State<AgencyUpdateRentalVehiclePage> {
  var carSnap;
  _AgencyUpdateRentalVehiclePageState({this.carSnap});

  @override
  void initState() {
    // TODO: implement initState
    setInitialValues();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  int tag = 0;
  List<String> options = [
    'Vehicle only',
    'Vehicle with driver',
  ];

  //
  String plateNumber = '';
  String vehicleModel = '';
  String formattedPlateNumber = '';
  String _description = '';
  String _price = '';
  String _navigationOption = 'Vehicle only';
  String location = '';
  PickResult selectedCarLocation;

  setInitialValues() {
    setState(() {
      plateNumber = carSnap['vehicle_name'];
      vehicleModel = carSnap['vehicle_model'];
      formattedPlateNumber = carSnap['vehicle_entry_id'];
      _description = carSnap['vehicle_description'];
      _price = carSnap['vehicle_price'];
      location = carSnap['vehicle_location'];
    });
  }

  _rentalUpdate() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Rental')
        .doc(formattedPlateNumber);
    Map<String, dynamic> tasks = {
      'vehicle_name': plateNumber,
      'vehicle_model': vehicleModel,
      'vehicle_description': _description,
      'vehicle_location': selectedCarLocation.formattedAddress,
      'vehicle_location_longitude': selectedCarLocation.geometry.location.lng,
      'vehicle_location_latitude': selectedCarLocation.geometry.location.lat,
      'vehicle_price': _price,
      'vehicle_renting_option': _navigationOption,
    };
    ds.update(tasks).whenComplete(
      () {
        setState(() {
          _loading = false;
          print('rental updated');
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
                        'Update submitted!',
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
                        'Your rental vehicle information has successfully been updated!',
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            expandedHeight: ((MediaQuery.of(context).size.width * 2) / 3),
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: CarouselSlider(
                options: CarouselOptions(
                  //height: MediaQuery.of(context).size.width * 2 / 3,
                  aspectRatio: 2 / 3,
                  viewportFraction: 1.0,
                  initialPage: 1,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                items: [
                  carSnap['vehicle_image_one'],
                  carSnap['vehicle_image_two'],
                  carSnap['vehicle_image_three'],
                  carSnap['vehicle_image_four']
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.width * 2 / 3,
                        width: MediaQuery.of(context).size.width,
                        child: Image(
                          image: NetworkImage(i),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: carSnap['vehicle_name'],
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.name,
                          maxLength: 8,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[A-Z0-9]')),
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
                          initialValue: carSnap['vehicle_model'],
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
                            width: MediaQuery.of(context).size.width,
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
                                              ? location
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
                          initialValue: carSnap['vehicle_description'],
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
                          initialValue: carSnap['vehicle_price'],
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
                            : InkWell(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => _loading = true);
                                    FocusScope.of(context).unfocus();
                                    _rentalUpdate();
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
                                child: Container(
                                  decoration: new BoxDecoration(
                                      color: Color(0xff1e407c),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(4.0))),
                                  width: double.infinity,
                                  height: 48.0,
                                  child: Center(
                                    child: Text(
                                      'Update',
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
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
