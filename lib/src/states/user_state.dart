import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/logger.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final _user = Rxn<User?>();

  Rxn<User?> get user => _user;

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user.value = user;
      logger.d('(initUser)user status - $user');
      Get.offAllNamed('/');
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    initUser();
    logger.d('(onReady)user status - $user');
  }
}

class UserProvider extends ChangeNotifier {
  UserProvider() {
    initUser();
  }

  User? _user;

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      logger.d('user status - $user');
      notifyListeners();
    });
  }

  User? get user => _user;
}
