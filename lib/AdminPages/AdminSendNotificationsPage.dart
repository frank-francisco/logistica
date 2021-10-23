import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AdminSendNotificationsPage extends StatefulWidget {
  final String userId;
  final userSnap;
  AdminSendNotificationsPage({this.userId, this.userSnap});

  @override
  _AdminSendNotificationsPageState createState() =>
      _AdminSendNotificationsPageState(userId: userId, userSnap: userSnap);
}

class _AdminSendNotificationsPageState
    extends State<AdminSendNotificationsPage> {
  String userId;
  var userSnap;
  _AdminSendNotificationsPageState({this.userId, this.userSnap});

  final _formKey = GlobalKey<FormState>();
  String categoryName;
  String categoryId;
  String bodyText = '';
  bool _loading = false;

  _submitNotification() {
    if (categoryId == 'All') {
      FirebaseFirestore.instance
          .collection('Users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          //add count
          DocumentReference userRef = FirebaseFirestore.instance
              .collection('Users')
              .doc(doc['user_id']);
          Map<String, dynamic> countTasks = {
            'notification_count': FieldValue.increment(1),
          };
          userRef.update(countTasks);

          //send msg
          DocumentReference ds = FirebaseFirestore.instance
              .collection('Notifications')
              .doc('important')
              .collection(doc['user_id'])
              .doc();
          Map<String, dynamic> tasks = {
            'notification_tittle': 'Notice!',
            'notification_details': bodyText,
            'notification_time': DateTime.now().millisecondsSinceEpoch,
            'notification_sender': 'Safirisha',
            'action_title': '',
            'action_destination': '',
            'action_key': '',
            'post_id': 'extra',
          };
          ds.set(tasks);
        });
      }).then((value) => _showDialog());
    }
    if (categoryId == 'Company') {
      FirebaseFirestore.instance
          .collection('Users')
          .where('account_type', isEqualTo: 'Company')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          //add count
          DocumentReference userRef = FirebaseFirestore.instance
              .collection('Users')
              .doc(doc['user_id']);
          Map<String, dynamic> countTasks = {
            'notification_count': FieldValue.increment(1),
          };
          userRef.update(countTasks);

          //send msg
          DocumentReference ds = FirebaseFirestore.instance
              .collection('Notifications')
              .doc('important')
              .collection(doc['user_id'])
              .doc();
          Map<String, dynamic> tasks = {
            'notification_tittle': 'Notice!',
            'notification_details': bodyText,
            'notification_time': DateTime.now().millisecondsSinceEpoch,
            'notification_sender': 'Safirisha',
            'action_title': '',
            'action_destination': '',
            'action_key': '',
            'post_id': 'extra',
          };
          ds.set(tasks);
        });
      }).then((value) => _showDialog());
    }
    if (categoryId == 'Personal') {
      FirebaseFirestore.instance
          .collection('Users')
          .where('account_type', isEqualTo: 'Personal')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          //add count
          DocumentReference userRef = FirebaseFirestore.instance
              .collection('Users')
              .doc(doc['user_id']);
          Map<String, dynamic> countTasks = {
            'notification_count': FieldValue.increment(1),
          };
          userRef.update(countTasks);

          //send msg
          DocumentReference ds = FirebaseFirestore.instance
              .collection('Notifications')
              .doc('important')
              .collection(doc['user_id'])
              .doc();
          Map<String, dynamic> tasks = {
            'notification_tittle': 'Notice!',
            'notification_details': bodyText,
            'notification_time': DateTime.now().millisecondsSinceEpoch,
            'notification_sender': 'Safirisha',
            'action_title': '',
            'action_destination': '',
            'action_key': '',
            'post_id': 'extra',
          };
          ds.set(tasks);
        });
      }).then((value) => _showDialog());
    }
    if (categoryId == 'Administration') {
      FirebaseFirestore.instance
          .collection('Users')
          .where('account_type', whereIn: ['Editor', 'Admin'])
          .get()
          .then(
            (QuerySnapshot querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                //add count
                DocumentReference userRef = FirebaseFirestore.instance
                    .collection('Users')
                    .doc(doc['user_id']);
                Map<String, dynamic> countTasks = {
                  'notification_count': FieldValue.increment(1),
                };
                userRef.update(countTasks);

                //send msg
                DocumentReference ds = FirebaseFirestore.instance
                    .collection('Notifications')
                    .doc('important')
                    .collection(doc['user_id'])
                    .doc();
                Map<String, dynamic> tasks = {
                  'notification_tittle': 'Notice!',
                  'notification_details': bodyText,
                  'notification_time': DateTime.now().millisecondsSinceEpoch,
                  'notification_sender': 'Safirisha',
                  'action_title': '',
                  'action_destination': '',
                  'action_key': '',
                  'post_id': 'extra',
                };
                ds.set(tasks);
              });
            },
          )
          .then(
            (value) => _showDialog(),
          );
    }
  }

  _showDialog() {
    setState(() {
      _loading = false;
    });
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
                        'Notifications delivered!',
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
                        'Group notification has successfully been delivered to selected category.',
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: new BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          width: double.infinity,
                          height: 42.0,
                          child: Center(
                            child: Text(
                              'Okay',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text('Dashboard'),
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
                        'Send notification \nto a specific group of users',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                                  'Selected group',
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
                                  categoryName == null
                                      ? 'Select group'
                                      : categoryName,
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
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
                          labelText: 'Body text',
                          labelStyle: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              letterSpacing: .5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(0.0),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() => bodyText = val);
                        },
                        validator: (val) =>
                            val.length < 50 ? 'Text too short' : null,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _loading
                          ? Container(
                              decoration: new BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                              ),
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
                                if (_formKey.currentState.validate() &&
                                    categoryName != null) {
                                  setState(() => _loading = true);
                                  FocusScope.of(context).unfocus();
                                  _submitNotification();
                                } else {
                                  final snackBar = SnackBar(
                                    content:
                                        const Text('Please fill everything!'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                                width: double.infinity,
                                height: 48.0,
                                child: Center(
                                  child: Text(
                                    'Send',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
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
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Select user group:',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Colors.grey,
                height: 1,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        takeAction('All', 'All accounts');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.black87,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'All accounts',
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
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        takeAction('Company', 'Agency accounts');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.black87,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Agency accounts',
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
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        takeAction('Personal', 'Personal accounts');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.black87,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Personal accounts',
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
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        takeAction('Administration', 'Administration accounts');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.black87,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Administration accounts',
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
            ),
          ],
        ),
      ),
    );
  }

  takeAction(String id, String name) {
    setState(() {
      categoryName = name;
      categoryId = id;
    });
    Navigator.pop(context, true);
  }
}
