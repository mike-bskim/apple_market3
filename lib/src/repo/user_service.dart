import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/logger.dart';

class UserService {
  Future fireStoreTest() async {
    var doc = FirebaseFirestore.instance.collection('TESTING_COLLECTION').doc('abc');
    doc.set({
      'id': doc.id,
      'datetime': DateTime.now().toString(),
      'displayName': 'BSKim',
    });
  }

  void fireStoreReadTest() {
    var doc = FirebaseFirestore.instance.collection('TESTING_COLLECTION').doc('abc').get();
    doc.then((DocumentSnapshot<Map<String, dynamic>> value) => logger.d(value.data()));
  }
}
