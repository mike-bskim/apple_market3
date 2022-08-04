import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref_key.dart';
import '../models/user_model.dart';
import '../repo/user_service.dart';
import '../utils/logger.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final _user = Rxn<User?>();
  final _userModel = Rxn<UserModel1?>();

  Rxn<User?> get user => _user;

  Rxn<UserModel1?> get userModel => _userModel;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    initUser();
    logger.d('(onReady)user status - $user');
  }

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      // user 정보가 변경되면, 호출됨,
      _user.value = user;
      Get.offAndToNamed('/');
      await _setNewUser(user);
    });
  }

  Future<void> _setNewUser(User? user) async {
    // user 정보가 변경되면, 전화번호가 있어야만 호출됨,
    if (user != null && user.phoneNumber != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String address = prefs.getString(SHARED_ADDRESS) ?? '';
      double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      double lon = prefs.getDouble(SHARED_LON) ?? 0;
      String phoneNumber = user.phoneNumber!;
      String userKey = user.uid;

      // 기존 모델이 아닌 새로운 모델로 작업중, UserModel >> UserModel1
      UserModel1 userModel = UserModel1(
        userKey: userKey,
        phoneNumber: phoneNumber,
        address: address,
        lat: lat,
        lon: lon,
        geoFirePoint: GeoFirePoint(lat, lon),
        createdDate: DateTime.now().toUtc(),
      );

      // 사용자 정보가 없으면 생성함, 있으면 무시함,
      await UserService().createNewUser(userModel.toJson(), userKey);
      _userModel.value = await UserService().getUserModel(userKey);
      logger.d('(_userModel) - ${_userModel.toString()}');
      logger.d('(_setNewUser/if) user status - $user');
    } else {
      logger.d('(_setNewUser/else) user status - $user');
    }
  }
}

// class UserProvider extends ChangeNotifier {
//   UserProvider() {
//     initUser();
//   }
//
//   User? _user;
//
//   void initUser() {
//     FirebaseAuth.instance.authStateChanges().listen((user) {
//       _user = user;
//       logger.d('user status - $user');
//       notifyListeners();
//     });
//   }
//
//   User? get user => _user;
// }
