import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/auth_controller.dart';
import '../controller/user_controller.dart';
import '../model/user_model.dart';
import '../model/utils/colors.dart';
import '../model/utils/constants.dart';
import '../model/utils/dimensions.dart';
import '../model/utils/images.dart';
import '../model/utils/styles.dart';
import '../services/image_services.dart';
import '../services/storage_services.dart';
import '../view/widget/custom_snackbar.dart';
import '../view/widget/edit_field.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StreamBuilder<UserModel>(
            stream: userController.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              UserModel currentUser = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 55,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 30,),
                      Text("Profile",style: interExtraBold.copyWith(color: textBlack,fontSize: 30)),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()){
                            await authController.updateUserProfile(currentUser);
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: btnColor,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: SvgPicture.asset(Images.edit),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    child: ClipOval(
                      child: InkWell(
                        onTap:() async {
                          File? pickedFile = await ImageService().getImage(ImageSource.gallery);
                          if (pickedFile != null) {
                            String? imageUrl=await StorageServices().uploadToStorage(pickedFile,"Profile Images");
                            if(imageUrl!=null){
                              currentUser.profilePicture=imageUrl;
                              authController.updateProfileImage(currentUser);
                            }
                          }
                        },
                        child: Image.network(
                          currentUser.profilePicture??AppConstants.profilePlaceholder,
                          width: 90,height: 90,fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(currentUser.Name??"",style: interMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
                  const SizedBox(height: 5,),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex:2,
                                    child: EditTextField(
                                      name:currentUser.Name,
                                      preFix: Images.profile,
                                      text: "Name",
                                      onChanged: (val) => currentUser.Name=val,
                                      validator: (value) {
                                        if (currentUser.Name == null || currentUser.Name!.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    )
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            EditTextField(
                              name: currentUser.phone??"Enter phone",
                              text: "Phone",
                              onChanged: (val) => currentUser.phone=val,
                              validator: (value) {
                                if (currentUser.phone == null || currentUser.phone!.isEmpty) {
                                  return 'Please enter your phone';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10,),
                            EditTextField(
                              name: currentUser.email,
                              preFix: Images.google,
                              text: "Email",
                              textInputType: TextInputType.emailAddress,
                              onChanged: (val) => currentUser.email=val,
                              validator: (value) {
                                if (currentUser.email == null || currentUser.email!.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!currentUser.email!.isEmail) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10,),
                            EditTextField(
                              name: "******",
                              preFix: Images.lock,
                              text: "Password",
                              isSecure: true,
                              onChanged: (val) => currentUser.password=val,
                            ),
                            const SizedBox(height: 10,),
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                  onTap: () {
                                    if(currentUser.accountType=="SignInWithGoogle"){
                                      showConsole("Password Reset: Password can't be changed. You are login with google");
                                      showCustomSnackBar("Password Reset","Password can't changed. You are login with google");
                                    }
                                    // else if(currentUser.accountType=="SignInWithFacebook"){
                                    //   showConsole("Password Reset: Password can't be changed. You are login with facebook");
                                    //   showCustomSnackBar("Password Reset","Password can't changed. You are login with facebook");
                                    // }
                                    else if(currentUser.password!=null&&currentUser.password!.length>=6){
                                      authController.updatePassword(currentUser);
                                    }
                                    else{
                                      showConsole("Password Reset: Password should be 6 digit");
                                      showCustomSnackBar("Password Reset","Password should be 6 digit");
                                    }
                                  },
                                  child: Text("change password",style: interRegular.copyWith(color: colorPurple),)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: editFieldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () => authController.signOut(),
                      trailing: const Icon(Icons.logout,color: Colors.red,),
                      title: Text("Logout",style: interRegular.copyWith(color: Colors.red),),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
