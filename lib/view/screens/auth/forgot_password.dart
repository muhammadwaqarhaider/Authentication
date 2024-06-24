import 'package:firebase/model/utils/colors.dart';
import 'package:firebase/model/utils/styles.dart';
import 'package:firebase/view/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../model/user_model.dart';
import '../../../model/utils/dimensions.dart';
import '../../widget/custom_button.dart';
import '../../widget/theme_helper.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  UserModel userModel=UserModel();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: textWhite,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100,),
                  SizedBox(height: Get.width*0.15,),
                  Text("Forgot password",style: interBold.copyWith(fontSize: Dimensions.fontSizeOverLarge-2,height: 0.8),),
                  const SizedBox(height: 10,),
                  Text(
                    "Enter your email to receive an email \nto reset password",
                    style: interMedium.copyWith(color: textBlack,fontSize: Dimensions.fontSizeSmall,height: 0.8),
                  ),
                  SizedBox(height: Get.width*0.2,),
                  Container(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      decoration: ThemeHelper().textInputDecoration('Email', 'Enter your  Email',Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => userModel.email=val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        else if (!value.isEmail) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15,),
                  CustomButton(
                    text: "Send",
                    onTap: () async {
                      if (_formKey.currentState!.validate()){
                        await authController.forgotPassword(userModel);
                      }
                    },
                  ),
                  SizedBox(height: Get.width*0.25,),
                  Align(
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      onTap: () async {
                        Get.to(() => SignIn());
                      },
                      child: RichText(
                        text: TextSpan(
                          style: interMedium.copyWith(color:Colors.black),
                          children: <TextSpan>[
                            const TextSpan(text: "Already Have an account?  "),
                            TextSpan(text: "Sign in now",style: interMedium.copyWith(color: Colors.red))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
