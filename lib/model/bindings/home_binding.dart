import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/user_controller.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(),fenix: true);
    Get.lazyPut<UserController>(() => UserController(),fenix: true);
  }
}
