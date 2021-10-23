import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  getSubscriptionInfo(String subscriberUid, String subscribedUid) {
    return FirebaseFirestore.instance
        .collection('Subscribers')
        .doc('subscribed_users')
        .collection(subscribedUid)
        .where('subscriber_id', isEqualTo: subscriberUid)
        .get();
  }
}
