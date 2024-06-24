import 'dart:async';
import 'package:firebase/model/utils/colors.dart';
import 'package:firebase/model/utils/dimensions.dart';
import 'package:firebase/model/utils/styles.dart';
import 'package:firebase/view/screens/auth/auth_wrapper.dart';
import 'package:firebase/view/screens/auth/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 3), (){
      Get.offAll(AuthWrapper());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Firebase",style: interExtraBold.copyWith(color: textBlack,fontSize: Dimensions.radiusExtraLarge)),
            ],
          ),
        ),
      ),
    );
  }
}
