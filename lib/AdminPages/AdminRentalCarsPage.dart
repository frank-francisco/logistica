import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/AgencyPages/RentalVehicleDetailsPage.dart';

class AdminRentalCarsPage extends StatefulWidget {
  final String userId;
  AdminRentalCarsPage({this.userId});

  @override
  _AdminRentalCarsPageState createState() =>
      _AdminRentalCarsPageState(userId: userId);
}

class _AdminRentalCarsPageState extends State<AdminRentalCarsPage> {
  String userId;
  _AdminRentalCarsPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text(
          'Rental vehicles',
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
                      'All the\nrental vehicles',
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
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Rental')
                          .where('vehicle_owner', isEqualTo: userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 1.5,
                            child: Center(
                              child: Image(
                                image: AssetImage('assets/images/empty.png'),
                                width: double.infinity,
                              ),
                            ),
                          );
                        } else {
                          if (snapshot.data.docs.length == 0) {
                            return Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 1.5,
                              child: Center(
                                child: Image(
                                  image: AssetImage('assets/images/empty.png'),
                                  width: double.infinity,
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot myVehicle =
                                    snapshot.data.docs[index];
                                return vehicleItem(index, myVehicle);
                              },
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget vehicleItem(int index, DocumentSnapshot<Object> myVehicle) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              print(myVehicle['vehicle_name']);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => RentalVehicleDetailsPage(
                    userId: userId,
                    carSnap: myVehicle,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                //color: Colors.black12,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      child: Image(
                        height: 40 * 1.2,
                        width: 60 * 1.2,
                        image: NetworkImage(
                          myVehicle['vehicle_image_one'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            myVehicle['vehicle_name'],
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            myVehicle['vehicle_location'],
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  // fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      activeColor: Color(0xff1e407c),
                      value: myVehicle['vehicle_visibility'] == 'true'
                          ? true
                          : false,
                      onChanged: (value) {
                        print(value);
                        updateStatus(value, myVehicle['vehicle_entry_id']);
                      },
                    ),
                    SizedBox(
                      width: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  updateStatus(bool value, String id) {
    DocumentReference usersRef =
        FirebaseFirestore.instance.collection('Rental').doc(id);
    usersRef.update({'vehicle_visibility': value.toString()});
  }
}
