import 'package:firebase/model/utils/colors.dart';
import 'package:firebase/model/utils/dimensions.dart';
import 'package:firebase/model/utils/styles.dart';
import 'package:firebase/view/screens/auth/forgot_password.dart';
import 'package:firebase/view/screens/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../model/user_model.dart';
import '../../../model/utils/images.dart';
import '../../widget/custom_button.dart';
import '../../widget/social_card.dart';
import '../../widget/theme_helper.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();
  UserModel userModel=UserModel();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30,),
                    Text("Firebase",style: interExtraBold.copyWith(color: textBlack,fontSize: 50),),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        const SizedBox(),
                        const SizedBox(),
                        const SizedBox(),
                        const SizedBox(),
                        const SizedBox(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Welcome Back",style: interBold.copyWith(fontSize: Dimensions.fontSizeOverLarge-2,height: 0.8),),
                            Text("sign in to firebase",style: interRegular.copyWith(color: textDullGray,fontSize: Dimensions.fontSizeSmall,height: 0.8),),
                          ],
                        ),
                        const SizedBox(),
                      ],
                    ),
                    SizedBox(height: 60,),
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
                    SizedBox(height: 30.0),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          label: Text("Password"),
                          hintText: "Enter Your Password",
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        onChanged: (val) => userModel.password=val,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          else if (value.length<6) {
                            return 'Password should  be 6 digit';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 40,),
                    CustomButton(
                      text: "Sign in",
                      onTap: () async {
                        if (_formKey.currentState!.validate()){
                          await authController.signInWithEmailAndPassword(userModel);
                        }
                      },
                    ),
                    const SizedBox(height: 15,),
                    InkWell(
                      onTap: (){
                        Get.to(ForgotPassword());
                      },
                      child: Text("Forgot Password ?",style: interRegular.copyWith(color: Colors.red),),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children:  [
                        const Expanded(child: Divider(color: Colors.grey,height: 1,)),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("or",style: interRegular.copyWith(color: textDullGray),),
                        ),
                        const Expanded(child: Divider(color: Colors.grey,height: 1,)),
                      ],
                    ),
                    Row(
                      children: [
                        SocialCard(icon: Images.google, name: "google",onTap: () async => await authController.signInWithGoogle(),),
                        const SizedBox(width: 12,),
                        SocialCard(icon: Images.facebook, name: "facebook",),
                      ],
                    ),
                    const SizedBox(height: 170,),
                    InkWell(
                      onTap: (){
                        Get.to(SignUp());
                      },
                      child: RichText(
                        text: TextSpan(
                          style: interMedium.copyWith(color:Colors.black),
                          children: <TextSpan>[
                            const TextSpan(text: "Not a member?  "),
                            TextSpan(text: "Sign up now",style: interMedium.copyWith(color: Colors.red))
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
