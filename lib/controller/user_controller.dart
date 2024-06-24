import 'package:get/get.dart';

import '../model/user_model.dart';
import '../services/database_manager.dart';
import '../view/widget/custom_snackbar.dart';
import 'auth_controller.dart';


class UserController extends GetxController {
  DatabaseService db = DatabaseService();
  final Rx<UserModel?> _userModel = UserModel().obs;
  AuthController authController = Get.find<AuthController>();

  UserModel get user => _userModel.value!;

  Future<UserModel> getCurrentUser() async {
    return await db.usersCollection
        .doc(authController.user!.uid)
        .get()
        .then((doc) {
          showConsole(doc.data());
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  Stream<UserModel> getUser() {
    return db.usersCollection.doc(authController.user!.uid).snapshots().map((snapshot) {
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }
  Future<UserModel> getUserById(String userId) async {
    return await db.usersCollection
        .doc(userId)
        .get()
        .then((doc) {
      showConsole(doc.data());
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<void> onReady() async {
    _userModel.value = await getCurrentUser();
    showConsole(_userModel.value!.toJson());
    super.onReady();
  }
}
