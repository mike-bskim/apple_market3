import 'package:get/get.dart';

import '../states/user_controller.dart';

class BindingInjection implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(UserController());
  }
}
