import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/data_keys.dart';
import '../models/user_model.dart';

class UserService {

  // 싱글톤 디자인 패턴 ***************************************
  // 인스턴스가 한번만 생성되고, 2번째 생성시에는 처음 생성한 인스턴스를 리턴,
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;
  UserService._internal();
  // 싱글톤 디자인 패턴 ***************************************

  // 사용자 uid 를 기반으로 저장하고, uid 를 기반으로 저장된 정보가 있으면 skip,
  Future createNewUser(Map<String, dynamic> json, String userKey) async {

    DocumentReference<Map<String, dynamic>> docRef =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot documentSnapshot = await docRef.get();

    // 사용자 정보가 없으면 생성함,
    if(!documentSnapshot.exists){
      await docRef.set(json);
    }
  }

  // 사용자 uid 를 이용하여 데이터 읽기,
  Future<UserModel1> getUserModel(String userKey) async {

    DocumentReference<Map<String, dynamic>> docRef =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await docRef.get();

    // UserModel 의 경우는 fromJson 을 수정하여 1줄로 코딩을 처리해야 가능,
    // UserModel userModel = UserModel.fromSnapshot(documentSnapshot);
    // UserModel1 의 경우는 fromJson 이 factory 패턴이므로 2줄로 코딩을 처리해야 함,
    UserModel1 userModel = UserModel1.fromJson(documentSnapshot.data()!);
    userModel.reference = documentSnapshot.reference;
    // debugPrint('--------------------------------------------------');
    // debugPrint('documentSnapshot: ${documentSnapshot.id}');
    // debugPrint('documentSnapshot: ${documentSnapshot.reference}');

    return userModel;
  }

  // Future fireStoreTest() async {
  //   var doc = FirebaseFirestore.instance.collection('TESTING_COLLECTION').doc('abc');
  //   doc.set({
  //     'id': doc.id,
  //     'datetime': DateTime.now().toString(),
  //     'displayName': 'BSKim',
  //   });
  // }
  //
  // void fireStoreReadTest() {
  //   var doc = FirebaseFirestore.instance.collection('TESTING_COLLECTION').doc('abc').get();
  //   doc.then((DocumentSnapshot<Map<String, dynamic>> value) => logger.d(value.data()));
  // }
}
