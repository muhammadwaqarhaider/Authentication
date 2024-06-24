import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificat extends StatefulWidget {
  const Notificat({Key? key}) : super(key: key);

  @override
  State<Notificat> createState() => _NotificatState();
}

class _NotificatState extends State<Notificat> {

  String? mtoken= "";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  TextEditingController username = TextEditingController();
  TextEditingController body = TextEditingController();
  TextEditingController title = TextEditingController();


  @override
  void initState(){
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize =  const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize,iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings ,onSelectNotification: (String? payload) async {
      try{
        if(payload !=null && payload.isNotEmpty){

        }else{

        }
      }catch (e) {
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message)async {
      print(".............onMessage.........");
      print("onMessae: ${message.notification?.title}/${message.notification?.body}}");
      
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle:true,
      );

      AndroidNotificationDetails andriodPlateformChannelSpecifics = AndroidNotificationDetails(
          'dbfood', 'dbfood','dbfood', importance: Importance.high,
        styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true,
      );

      NotificationDetails plateformChannelSpecifics = NotificationDetails(android: andriodPlateformChannelSpecifics,iOS: IOSNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
        message.notification?.body, plateformChannelSpecifics,
        payload: message.data['title']
      );

    });

  }

  Future<void> getToken() async {
    String? token=await FirebaseMessaging.instance.getToken();
    print("My token is $token");
    await saveToken(token!);
  }

  Future<void> saveToken (String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("User1").set({
     'token' :token,
    });
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: username,
            ),
            TextField(
              controller: title,
            ),
            TextField(
              controller: body,
            ),
            GestureDetector(
              onTap: () {
                String name = username.text.trim();
                String titleText = title.text;
                String bodyText = body.text;
              },
              child: Container(
                margin: EdgeInsets.all(20),
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text("Button")),
              ),
            )
          ],
        ),
      ),
    );
  }
}