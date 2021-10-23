import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/AgencyPages/AgencyUpdateProfile.dart';
import 'package:safirisha/animations/FadeAnimations.dart';

class AgencyProfilePage extends StatefulWidget {
  final String userId;
  final userSnap;
  AgencyProfilePage({this.userId, this.userSnap});

  @override
  _AgencyProfilePageState createState() =>
      _AgencyProfilePageState(userId: userId, userSnap: userSnap);
}

class _AgencyProfilePageState extends State<AgencyProfilePage> {
  String userId;
  var userSnap;
  _AgencyProfilePageState({this.userId, this.userSnap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('user_id', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              DocumentSnapshot userInfo = snapshot.data.docs[0];

              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    expandedHeight: MediaQuery.of(context).size.width,
                    backgroundColor: Theme.of(context).primaryColor,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
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
                                colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(.2)
                                ]),
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
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FadeAnimation(
                                  1.2,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          userInfo['user_phone'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              letterSpacing: .5,
                                            ),
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
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FadeAnimation(
                                1.6,
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ("About ${userInfo['user_name']}")
                                            .toUpperCase(),
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        userInfo['about_user'],
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FadeAnimation(
                                2,
                                InkWell(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.0),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xff1e407c),
                                        width: 1,
                                      ),
                                    ),
                                    child: Align(
                                      child: Text(
                                        'Update profile',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            color: Color(0xff1e407c),
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => AgencyUpdateProfile(
                                          userSnap: userSnap,
                                          userId: userId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          }),
    );
  }

  Widget emptyView() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 48,
          ),
          Text(
            'You haven\'t posted anything yet',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              'Press the plus icon to post your first post on the feeds.',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: .5,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (_) => SelectFromGalleryPage(
              //       //userId: _onlineUserId,
              //     ),
              //   ),
              // );
            },
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[400],
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
