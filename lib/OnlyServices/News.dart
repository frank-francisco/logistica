import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsDetailsService {
  getPressInfo(String postId) {
    return FirebaseFirestore.instance
        .collection('News')
        .where('news_id', isEqualTo: postId)
        .get();
  }
}
