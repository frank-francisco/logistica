import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  getProfileInfo(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('user_id', isEqualTo: uid)
        .get();
  }
}
