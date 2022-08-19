import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/data_keys.dart';
import '../states/user_controller.dart';
// import '../utils/logger.dart';

class CheckAuth extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    debugPrint('************************* (CheckAuth): ' + UserController.to.hashCode.toString());

    if (UserController.to.user.value == null) {
      return const RouteSettings(name: ROUTE_AUTH);
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
