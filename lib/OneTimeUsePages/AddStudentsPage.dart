import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddStudentsPage extends StatefulWidget {
  @override
  _AddStudentsPageState createState() => _AddStudentsPageState();
}

class _AddStudentsPageState extends State<AddStudentsPage> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  bool _loading = false;
  String institutionName = '';
  String institutionId = '';
  String studentRegistrationNumber;
  String studentName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add user',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              //fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: .5,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.minHeight,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Image(
                              height: MediaQuery.of(context).size.width / 4,
                              //width: 300,
                              fit: BoxFit.contain,
                              image: AssetImage(
                                'assets/images/search_user.png',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Add user \nto database',
                          style: GoogleFonts.quicksand(
                            fontSize: 24,
                            color: Color(0xff1e407c),
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'User institution name',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              letterSpacing: .5,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        InkWell(
                          onTap: () {
                            openInstitutionsSearch();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                institutionName == ''
                                    ? 'Search institution'.toUpperCase()
                                    : institutionName,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black87,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          maxLines: 1,
                          maxLength: 10,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'user registration number',
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                letterSpacing: .5,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() => studentRegistrationNumber = val);
                          },
                          validator: (val) => val.length < 4 || val.length > 10
                              ? ('Enter a valid registration number')
                              : null,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          maxLines: 1,
                          maxLength: 10,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'user name',
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                letterSpacing: .5,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() => studentName = val);
                          },
                          validator: (val) =>
                              val.length < 4 ? ('Enter a valid name') : null,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _loading
                            ? Container(
                                decoration: new BoxDecoration(
                                  color: Color(0xff1e407c),
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                                width: double.infinity,
                                height: 46.0,
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 46.0,
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate()) {
                                      //_createKeys();
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
                                  },
                                  child: Text(
                                    'Add student',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Color(0xff1e407c),
                                    onSurface: Colors.grey,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 40,
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

  openInstitutionsSearch() {
    String searchInput = '';
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Material(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('InstitutionsDatabase')
                  .doc('Tanzania')
                  .collection('Active')
                  .orderBy('institution_name', descending: false)
                  .where("search_keywords",
                      arrayContains: searchInput.toLowerCase())
                  .snapshots(),
              builder: (context, snapshot) {
                return Container(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search...'),
                        onChanged: (val) {
                          setModalState(
                            () {
                              searchInput = val;
                            },
                          );
                        },
                      ),
                      !snapshot.hasData
                          ? Container(
                              height: 240,
                              child: Center(
                                child: SpinKitThreeBounce(
                                  color: Colors.black54,
                                  size: 20.0,
                                ),
                              ),
                            )
                          : (snapshot.data.docs.length == 0
                              ? Container(
                                  height: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey[400],
                                        size: 32,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Type to start\nsearching',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: .5,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )

                                      // Image(
                                      //   image:
                                      //       AssetImage('assets/images/empty.png'),
                                      //   width:
                                      //       MediaQuery.of(context).size.width / 2,
                                      // ),
                                      ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot myInstitution =
                                        snapshot.data.docs[index];
                                    return institutionItem(
                                        index, myInstitution);
                                  },
                                )),
                    ],
                  ),
                );
              },
            ),
          );
        },
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
              setState(() {
                institutionName = myInstitution['institution_name'];
                institutionId = myInstitution['institution_id'];
              });
              Navigator.pop(context, true);
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

  _createKeys() {
    String finalString = '';
    finalString = (studentName.replaceAll(new RegExp(r'[^\w\s]+'), ''))
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
    createData(output);
  }

  createData(List<dynamic> keysList) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('StudentsDatabase')
        .doc('Tanzania')
        .collection(institutionId)
        .doc(studentRegistrationNumber);
    Map<String, dynamic> tasks = {
      'student_name': studentName,
      'student_institution_name': institutionName,
      'student_type': '-',
      'student_status': '-',
      'student_reg_number': studentRegistrationNumber,
      'student_description': '-',
      'student_start_time': '-',
      'search_keywords': FieldValue.arrayUnion(keysList),
    };
    ds.set(tasks).whenComplete(() {
      //sendNotification();
      setState(() {
        _loading = false;
      });
      print('Student created');
    });
  }
}
