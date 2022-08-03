import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../states/user_state.dart';
import '../utils/logger.dart';

class CheckAuth extends GetMiddleware {
  @override
  int? get priority => 2;

  bool isAuthenticated = false;

  @override
  RouteSettings? redirect(String? route) {
    debugPrint(UserController.to.hashCode.toString());
    // debugPrint(Get.find<UserController>().hashCode.toString());
    // if(Get.find<UserController>().user.value != null) {
    if(UserController.to.user.value != null) {
      isAuthenticated = true;
      logger.d('No redirect goto (/): ${UserController.to.user.value}');
    } else {
      isAuthenticated = false;
      logger.d('YES redirect goto (/auth): ${UserController.to.user.value}');
    }

    if (isAuthenticated == false) {
      return const RouteSettings(name: '/auth');
    }
    return null;
  }

// //This function will be called  before anything created we can use it to
// // change something about the page or give it new page
// @override
// GetPage? onPageCalled(GetPage? page) {
//   return super.onPageCalled(page);
// }
//
// //This function will be called right before the Bindings are initialized.
// // Here we can change Bindings for this page.
// @override
// List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
//   return super.onBindingsStart(bindings);
// }
//
// //This function will be called right after the Bindings are initialized.
// // Here we can do something after  bindings created and before creating the page widget.
// @override
// GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
//   return super.onPageBuildStart(page);
// }
//
// // Page build and widgets of page will be shown
// @override
// Widget onPageBuilt(Widget page) {
//   return super.onPageBuilt(page);
// }
//
// //This function will be called right after disposing all the related objects
// // (Controllers, views, ...) of the page.
// @override
// void onPageDispose() {
//   super.onPageDispose();
// }

}

// https://www.youtube.com/watch?v=Ism-kh-PXP8
