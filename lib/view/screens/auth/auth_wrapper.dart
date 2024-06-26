import 'package:firebase/view/screens/auth/sign_in.dart';
import 'package:firebase/view/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../controller/user_controller.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
        init: AuthController(),
        builder: (ac) {
          if (ac.user == null) {
            return  SignIn();
          }
          else {
            return GetBuilder<UserController>(
                init: UserController(),
                builder: (uc) {
                  return HomeScreen();
                });
          }
        });
  }
}
