import 'package:get/get.dart';

import '../middleware/check_auth.dart';
import '../screens/input/input_screen.dart';
import '../screens/start/start_screen.dart';
import '../screens/home/home_screen.dart';

// GETx 관련
List<GetPage<dynamic>> getPages() {
  return [
    GetPage(
      name: '/auth',
      page: () => StartScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/',
      page: () => const HomeScreen(),
      middlewares: [CheckAuth()], // 미들웨어를 먼저 확인하고 "page:" 로 이동함
    ),
    GetPage(
      name: '/input',
      page: () => const InputScreen(),
      transition: Transition.fadeIn,
      middlewares: [CheckAuth()], // 미들웨어를 먼저 확인(로그인 여부 확인)하고 "page:" 로 이동함
    ),
    // GetPage(name: '/user/:uid', pages: () => const UserInfoPage()),
  ];
}
