import 'package:get/get.dart';

import '../constants/data_keys.dart';
import '../middleware/check_auth.dart';
import '../screens/home/item_detail_page.dart';
import '../screens/input/category_input_page.dart';
import '../screens/input/input_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/main_screen.dart';
import '../states/category_controller.dart';
import '../states/select_image_controller.dart';

// GETx 관련
List<GetPage<dynamic>> getPages() {
  return [
    GetPage(
      name: ROUTE_AUTH,
      page: () => AuthScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ROUTE_MAIN,
      page: () => const MainScreen(),
      middlewares: [CheckAuth()], // 미들웨어를 먼저 확인하고 "page:" 로 이동함
    ),
    GetPage(
      name: ROUTE_INPUT,
      page: () => const InputScreen(),
      transition: Transition.fadeIn,
      binding: BindingsBuilder((){
        Get.put(CategoryController());
        Get.put(SelectImageController());
      }),
      middlewares: [CheckAuth()], // 미들웨어를 먼저 확인(로그인 여부 확인)하고 "page:" 로 이동함
    ),
    GetPage(
      name: ROUTE_CATEGORY_INPUT,
      page: () => const CategoryInputPage(),
      transition: Transition.fadeIn,
      middlewares: [CheckAuth()], // 미들웨어를 먼저 확인(로그인 여부 확인)하고 "page:" 로 이동함
    ),
    GetPage(
      name: ROUTE_ITEM_DETAIL,
      page: () => const ItemDetailPage(),
      transition: Transition.fadeIn,
      middlewares: [CheckAuth()], // 미들웨어를 먼저 확인(로그인 여부 확인)하고 "page:" 로 이동함
    ),
    // GetPage(name: '/user/:uid', pages: () => const UserInfoPage()),
  ];
}
