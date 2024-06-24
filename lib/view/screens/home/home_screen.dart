import 'package:firebase/model/utils/colors.dart';
import 'package:firebase/model/utils/dimensions.dart';
import 'package:firebase/view/screens/home/contacts_saver.dart';
import 'package:firebase/view/screens/home/todo_app.dart';
import 'package:firebase/view/screens/home/image_uplode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../profile/edit_profile.dart';
import 'notification.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.menu,color: textWhite,size: 25,),
        centerTitle: true,
        title: Text("Firebase",style: TextStyle(color: textWhite,fontSize: Dimensions.radiusExtraLarge),),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.share,size: 25,color: textWhite,),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                Get.to(TodoScreen());
              },
              child: Text("ToDo App"),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                Get.to(MyHomePage());
              },
              child: Text("Image_Uplode"),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                Get.to(EditProfile());
              },
              child: Text("Profile"),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                Get.to(ContactsScreen());
              },
              child: Text("Contats_saver_app"),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                Get.to(Notificat());
              },
              child: Text("Notification"),
            ),

          ],
        ),
      ),
    );

  }
}

