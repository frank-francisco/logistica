import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safirisha/AdminPages/AdminAuthorizeUserPage.dart';
import 'package:safirisha/AdminPages/AdminUsersEngagePage.dart';

class AdminUsersPage extends StatefulWidget {
  @override
  _AdminUsersPageState createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  bool _companyVisibility = true;
  bool _personalVisibility = false;
  bool _adminsVisibility = false;
  bool _editorsVisibility = false;

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
            'Authorize a user',
            style: GoogleFonts.quicksand(
              color: Colors.black87,
            ),
          ),
        ),
      ],
      onSelected: (retVal) {
        if (retVal == '0') {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AdminAuthorizeUserPage(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xff1e407c),
        brightness: Brightness.dark,
        title: Text('Users'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        actions: [
          popupMenuButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   border: Border.all(
                //     color: Colors.grey[400],
                //   ),
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(8),
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Agencies',
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _companyVisibility = !_companyVisibility;

                                  //_newUsersVisibility = true;
                                  _personalVisibility = false;
                                  _adminsVisibility = false;
                                  _editorsVisibility = false;
                                });
                              },
                              child: _companyVisibility
                                  ? Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _companyVisibility,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .where('account_type', isEqualTo: 'Company')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 64.0),
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.black54,
                                    size: 20.0,
                                  ),
                                ),
                              );
                            } else {
                              if (snapshot.data.docs.length == 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 32.0,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/empty.png',
                                        ),
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot newUsers =
                                        snapshot.data.docs[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (_) =>
                                                  AdminUsersEngagePage(
                                                userInfo: newUsers,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 28.0,
                                                backgroundColor: Colors.black38,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      newUsers['user_image'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      CircleAvatar(
                                                    radius: 27,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                  placeholder: (context, url) =>
                                                      CircleAvatar(
                                                    radius: 26,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/holder.jpg'),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    radius: 26,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/holder.jpg'),
                                                  ),
                                                ),

                                                // CircleAvatar(
                                                //   radius: 26.0,
                                                //   backgroundColor:
                                                //       Colors.blueGrey,
                                                //   backgroundImage: NetworkImage(
                                                //       newUsers['user_image']),
                                                // ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      newUsers['user_name'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(
                                                      height: 2.0,
                                                    ),
                                                    Text(
                                                      newUsers['account_type'] +
                                                          ' | ' +
                                                          newUsers[
                                                              'user_locality'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 6.0,
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      width: 80,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    Text(
                                                      newUsers['about_user'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   border: Border.all(
                //     color: Colors.grey[400],
                //   ),
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(8),
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Personal accounts',
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _personalVisibility = !_personalVisibility;
                                  _companyVisibility = false;
                                  _adminsVisibility = false;
                                  _editorsVisibility = false;
                                });
                              },
                              child: _personalVisibility
                                  ? Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _personalVisibility,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .where('account_type', isEqualTo: 'Personal')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 64.0),
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.black54,
                                    size: 20.0,
                                  ),
                                ),
                              );
                            } else {
                              if (snapshot.data.docs.length == 0) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0),
                                  child: Center(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/empty.png',
                                        ),
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot newUsers =
                                        snapshot.data.docs[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (_) =>
                                                  AdminUsersEngagePage(
                                                userInfo: newUsers,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 28.0,
                                                backgroundColor: Colors.black38,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      newUsers['user_image'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      CircleAvatar(
                                                    radius: 27,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                  placeholder: (context, url) =>
                                                      CircleAvatar(
                                                    radius: 26,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/holder.jpg'),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    radius: 26,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/holder.jpg'),
                                                  ),
                                                ),

                                                // CircleAvatar(
                                                //   radius: 26.0,
                                                //   backgroundColor:
                                                //       Colors.blueGrey,
                                                //   backgroundImage: NetworkImage(
                                                //       newUsers['user_image']),
                                                // ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      newUsers['user_name'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(
                                                      height: 2.0,
                                                    ),
                                                    Text(
                                                      newUsers['account_type'] +
                                                          ' | ' +
                                                          newUsers[
                                                              'user_locality'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 6.0,
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      width: 80,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    Text(
                                                      newUsers['about_user'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   border: Border.all(
                //     color: Colors.grey[400],
                //   ),
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(8),
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Administrators',
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _adminsVisibility = !_adminsVisibility;

                                  _companyVisibility = false;
                                  _personalVisibility = false;
                                  _editorsVisibility = false;
                                });
                              },
                              child: _adminsVisibility
                                  ? Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _adminsVisibility,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .where('account_type', isEqualTo: 'Admin')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 64.0),
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.black54,
                                    size: 20.0,
                                  ),
                                ),
                              );
                            } else {
                              if (snapshot.data.docs.length == 0) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0),
                                  child: Center(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/empty.png',
                                        ),
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot newUsers =
                                        snapshot.data.docs[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (_) =>
                                                  AdminUsersEngagePage(
                                                userInfo: newUsers,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 28.0,
                                                backgroundColor: Colors.black38,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      newUsers['user_image'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      CircleAvatar(
                                                    radius: 27,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                  placeholder: (context, url) =>
                                                      CircleAvatar(
                                                    radius: 26,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/holder.jpg'),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    radius: 26,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/holder.jpg'),
                                                  ),
                                                ),

                                                // CircleAvatar(
                                                //   radius: 26.0,
                                                //   backgroundColor:
                                                //       Colors.blueGrey,
                                                //   backgroundImage: NetworkImage(
                                                //       newUsers['user_image']),
                                                // ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      newUsers['user_name'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(
                                                      height: 2.0,
                                                    ),
                                                    Text(
                                                      newUsers['account_type'] +
                                                          ' | ' +
                                                          newUsers[
                                                              'user_locality'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 6.0,
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      width: 80,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    Text(
                                                      newUsers['about_user'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   border: Border.all(
                //     color: Colors.grey[400],
                //   ),
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(8),
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Editors',
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _editorsVisibility = !_editorsVisibility;

                                  _companyVisibility = false;
                                  _personalVisibility = false;
                                  _adminsVisibility = false;
                                });
                              },
                              child: _editorsVisibility
                                  ? Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _editorsVisibility,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .where('account_type', isEqualTo: 'Editor')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 64.0),
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.black54,
                                    size: 20.0,
                                  ),
                                ),
                              );
                            } else {
                              if (snapshot.data.docs.length == 0) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0),
                                  child: Center(
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/empty.png',
                                        ),
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot newUsers =
                                        snapshot.data.docs[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (_) =>
                                                  AdminUsersEngagePage(
                                                userInfo: newUsers,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 28.0,
                                                backgroundColor: Colors.black38,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      newUsers['user_image'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      CircleAvatar(
                                                    radius: 27,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        imageProvider,
                                                  ),
                                                  placeholder: (context, url) =>
                                                      CircleAvatar(
                                                    radius: 28,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/holder.jpg'),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    radius: 28,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/holder.jpg'),
                                                  ),
                                                ),

                                                // CircleAvatar(
                                                //   radius: 26.0,
                                                //   backgroundColor:
                                                //       Colors.blueGrey,
                                                //   backgroundImage: NetworkImage(
                                                //       newUsers['user_image']),
                                                // ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      newUsers['user_name'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(
                                                      height: 2.0,
                                                    ),
                                                    Text(
                                                      newUsers['account_type'] +
                                                          ' | ' +
                                                          newUsers[
                                                              'user_locality'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 6.0,
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      width: 80,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    Text(
                                                      newUsers['about_user'],
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
