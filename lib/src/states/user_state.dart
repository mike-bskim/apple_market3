import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final RxBool _userLoggedIn = false.obs;

  RxBool get userState => _userLoggedIn;

  void setUserAuth(bool authState) {
    _userLoggedIn(authState);
    // auth_page 에서 여기로 이동
    Get.offAllNamed('/');
  }
}

class UserProvider extends ChangeNotifier {
  bool _userLoggedIn = false;

  bool get userState => _userLoggedIn;

  void setUserAuth(bool authState) {
    _userLoggedIn = authState;
    notifyListeners();
  }
}
