import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/animations/FadeAnimations.dart';

class AdminUsersEngagePage extends StatefulWidget {
  final userInfo;
  AdminUsersEngagePage({
    this.userInfo,
  });

  @override
  _AdminUsersEngagePageState createState() =>
      _AdminUsersEngagePageState(userInfo: userInfo);
}

class _AdminUsersEngagePageState extends State<AdminUsersEngagePage> {
  var userInfo;
  _AdminUsersEngagePageState({this.userInfo});
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Widget popupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 30.0,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Text(
            'Delete user',
            style: GoogleFonts.quicksand(
              color: Colors.black87,
            ),
          ),
        ),
      ],
      onSelected: (retVal) {
        if (retVal == '0') {
          _confirmDelete();
        }
      },
    );
  }

  _confirmInvalidate(DocumentSnapshot userStream) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
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
                        'Confirm your action!',
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
                        'Are you sure you want to invalidate this user?',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              try {
                                fireStore
                                    .collection('Users')
                                    .doc(userStream['user_id'])
                                    .update(
                                  {
                                    'user_verification': '-',
                                  },
                                );
                                // Fluttertoast.showToast(
                                //     msg: "User successfully invalidated!",
                                //     toastLength: Toast.LENGTH_LONG,
                                //     gravity: ToastGravity.BOTTOM,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor: Colors.brown,
                                //     textColor: Colors.white,
                                //     fontSize: 16.0);
                              } catch (e) {
                                print(e.toString());
                              }
                              setState(() {
                                userInfo = userStream;
                              });
                            },
                            child: Text(
                              'Invalidate',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  _confirmVerify(DocumentSnapshot userStream) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
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
                          'Confirm your action!',
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
                          'Are you sure you want to verify this user?',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();

                                try {
                                  fireStore
                                      .collection('Users')
                                      .doc(userStream['user_id'])
                                      .update(
                                    {
                                      'user_verification': 'Verified',
                                    },
                                  );
                                  // Fluttertoast.showToast(
                                  //     msg: "User successfully verified!",
                                  //     toastLength: Toast.LENGTH_LONG,
                                  //     gravity: ToastGravity.BOTTOM,
                                  //     timeInSecForIosWeb: 1,
                                  //     backgroundColor: Colors.green,
                                  //     textColor: Colors.white,
                                  //     fontSize: 16.0);
                                } catch (e) {
                                  print(e.toString());
                                }
                                setState(() {
                                  userInfo = userStream;
                                });
                              },
                              child: Text(
                                'Verify',
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.blue,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
        });
  }

  _confirmDelete() {
    showDialog(
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
                        'Confirm your action!',
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
                        'This process is irreversible. \nAre you sure you want to delete this user?',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                              DocumentReference users = fireStore
                                  .collection('Users')
                                  .doc(userInfo['user_id']);
                              users.delete().then((value) {
                                final snackBar = SnackBar(
                                  content: const Text('User deleted!'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }).catchError((onError) {
                                final snackBar = SnackBar(
                                  content: const Text('Error occurred!'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            },
                            child: Text(
                              'Delete',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ),
                        ],
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
  void initState() {
    super.initState();
    //print(userInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              popupMenuButton(),
            ],
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.width,
            backgroundColor: Theme.of(context).primaryColor,
            pinned: true,
            floating: false,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: constraints.biggest.height < 120.0 ? 1.0 : 0.0,
                    child: Text('Account details'),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(userInfo['user_image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.black, Colors.black.withOpacity(.2)],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FadeAnimation(
                              1,
                              Text(
                                userInfo['user_name'],
                                style: GoogleFonts.quicksand(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FadeAnimation(
                                  1.2,
                                  Text(
                                    '${userInfo['account_type']}',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                userInfo['user_verification'] == 'Verified'
                                    ? Icon(
                                        Icons.verified_user_outlined,
                                        size: 20,
                                        color: Colors.grey,
                                      )
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                      1.6,
                      Text(
                        "About ${userInfo['user_name']}",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                      1.6,
                      Text(
                        userInfo['about_user'],
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                      1.6,
                      Text(
                        "Account info",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                      1.6,
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.person_outline,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userInfo['user_name'],
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.merge_type,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userInfo['account_type'],
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.email_outlined,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userInfo['user_email'],
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userInfo['user_phone'],
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.location_on_outlined,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userInfo['user_city'] +
                                            ', ' +
                                            userInfo['user_locality'],
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.verified_user_outlined,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userInfo['user_verification'],
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
