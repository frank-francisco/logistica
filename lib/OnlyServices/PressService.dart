import 'package:cloud_firestore/cloud_firestore.dart';

class PressDetailsService {
  getPressInfo(String postId) {
    return FirebaseFirestore.instance
        .collection('Presses')
        .where('press_id', isEqualTo: postId)
        .get();
  }
}
