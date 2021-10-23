import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:safirisha/AgencyPages/AgencyAddTruckPage.dart';

class AgencyUpdateTruckRoutePage extends StatefulWidget {
  final routeSnap;
  AgencyUpdateTruckRoutePage({this.routeSnap});

  @override
  _AgencyUpdateTruckRoutePageState createState() =>
      _AgencyUpdateTruckRoutePageState(routeSnap: routeSnap);
}

class _AgencyUpdateTruckRoutePageState
    extends State<AgencyUpdateTruckRoutePage> {
  String userId;
  var routeSnap;
  _AgencyUpdateTruckRoutePageState({this.routeSnap});

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  var nameController = TextEditingController();
  //new

  String formattedPlateNumber = '';
  String _description = '';
  String truckName;
  String entryId;
  String truckModel;

  final kInitialPosition = LatLng(-6.1623596080754375, 35.74842779975969);

  PickResult startingPoint;
  PickResult endingPoint;
  String initialAddress = '';
  String finalAddress = '';

  DateTime timeStartingPoint;
  DateTime timeDestination;

  @override
  void initState() {
    setState(() {
      truckName = routeSnap['route_truck'];
      truckModel = routeSnap['route_truck_model'];
      entryId = routeSnap['route_truck_id'];
      _description = routeSnap['route_description'];
      timeStartingPoint =
          DateTime.fromMillisecondsSinceEpoch(routeSnap['route_starting_time']);
      timeDestination =
          DateTime.fromMillisecondsSinceEpoch(routeSnap['route_ending_time']);
      initialAddress = routeSnap['route_starting_point'];
      finalAddress = routeSnap['route_ending_point'];
    });
    super.initState();
  }

  _submitTruckRoute() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('TruckRoutes')
        .doc(routeSnap['route_entry_id']);
    Map<String, dynamic> tasks = {
      'route_truck': truckName,
      'route_truck_id': entryId,
      'route_truck_model': truckModel,
      'route_description': _description,
      'route_starting_time': timeStartingPoint.millisecondsSinceEpoch,
      'route_starting_point': startingPoint.formattedAddress,
      'route_starting_latitude': startingPoint.geometry.location.lat,
      'route_starting_longitude': startingPoint.geometry.location.lng,
      'route_ending_time': timeDestination.millisecondsSinceEpoch,
      'route_ending_point': endingPoint.formattedAddress,
      'route_ending_latitude': endingPoint.geometry.location.lat,
      'route_ending_longitude': endingPoint.geometry.location.lng,
    };
    ds.update(tasks).whenComplete(
      () {
        setState(
          () {
            _loading = false;
          },
        );
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
                        'Route updated!',
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
                        'Your route is now from ${startingPoint.formattedAddress} to ${endingPoint.formattedAddress}. Your route has successfully been updated!',
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
          'Update truck route',
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
                        'Add new\ntruck route',
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
                        'Select truck to create route',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //select truck
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _openTrucksSheet();
                              FocusScope.of(context).unfocus();
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected truck',
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
                                      truckName == null
                                          ? 'Select truck'
                                          : truckName,
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
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => AgencyAddTruckPage(
                                    userId: userId,
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      //start location
                      Text(
                        'Choose start location:',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          openStartPickerPage();
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
                                        'Pick starting point',
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
                                        // startingPoint == null
                                        //     ? 'Starting point'
                                        //     : startingPoint.formattedAddress,
                                        initialAddress,
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
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          openStartingTimePicker();
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
                                  Icons.access_time,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pick starting time',
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
                                      timeStartingPoint == null
                                          ? 'Starting time'
                                          :
                                          //timePointOne.toString(),
                                          DateFormat('dd MMM yyyy ~ hh : mm a')
                                              .format(timeStartingPoint),
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 18.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      //Intermediate locations

                      //Destination location
                      Text(
                        'Choose destination:',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          openDestinationPickerPage();
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
                                        'Pick final destination',
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
                                        // endingPoint == null
                                        //     ? 'Destination'
                                        //     : endingPoint.formattedAddress,
                                        finalAddress,
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
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          openDestinationTimePicker();
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
                                  Icons.access_time,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pick arrival time',
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
                                      timeDestination == null
                                          ? 'Arrival time'
                                          : DateFormat(
                                                  'dd MMM yyyy ~ hh : mm a')
                                              .format(timeDestination),
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 18.0,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //route description
                      TextFormField(
                        initialValue: _description,
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
                          labelText: 'Route description',
                          contentPadding: const EdgeInsets.all(0.0),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() => _description = val.trim());
                        },
                        validator: (val) =>
                            val.length > 10 ? null : ('Too short'),
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
                                      truckName != null &&
                                      initialAddress != null &&
                                      finalAddress != null &&
                                      timeStartingPoint != null &&
                                      timeDestination != null) {
                                    setState(() => _loading = true);
                                    FocusScope.of(context).unfocus();
                                    _submitTruckRoute();
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

  _openTrucksSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Material(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Trucks')
              .where('vehicle_owner', isEqualTo: userId)
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
                return Container(
                  height: 240,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot myTrucks = snapshot.data.docs[index];
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print(myTrucks['vehicle_name']);
                                    takeAction(myTrucks);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 10.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor: Colors.black87,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          myTrucks['vehicle_name'],
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  takeAction(DocumentSnapshot<Object> myTrucks) {
    nameController.text = myTrucks['vehicle_name'];
    setState(() {
      entryId = myTrucks.id;
      truckName = myTrucks['vehicle_name'];
      truckModel = myTrucks['vehicle_model'];
    });
    Navigator.pop(context, true);
  }

  //openPickerPage
  openStartPickerPage() {
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
                startingPoint = result;
                initialAddress = result.formattedAddress;
              });
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

  //openPickerPage
  openDestinationPickerPage() {
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
                endingPoint = result;
                finalAddress = result.formattedAddress;
              });
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

  //openTimePicker
  openStartingTimePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 7)),
      onChanged: (date) {
        print('change $date');
        print('change $date in time zone ' +
            date.timeZoneOffset.inHours.toString());
      },
      onConfirm: (date) {
        print('confirm $date');
        setState(() {
          timeStartingPoint = date;
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  //openTimePicker
  openDestinationTimePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 7)),
      onChanged: (date) {
        print('change $date');
        print('change $date in time zone ' +
            date.timeZoneOffset.inHours.toString());
      },
      onConfirm: (date) {
        print('confirm $date');
        setState(() {
          timeDestination = date;
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }
}
