import 'dart:io';

import 'package:bc_remates/res/owner_colors.dart';
import 'package:bc_remates/ui/auth/login/login.dart';
import 'package:bc_remates/ui/auth/recover_password/recover_password.dart';
import 'package:bc_remates/ui/auth/register/register_owner_data.dart';
import 'package:bc_remates/ui/auth/validation_code.dart';
import 'package:bc_remates/ui/intro/splash.dart';
import 'package:bc_remates/ui/main/auction_details.dart';
import 'package:bc_remates/ui/main/home.dart';
import 'package:bc_remates/ui/main/menu/user/profile.dart';
import 'package:bc_remates/ui/main/notifications/notifications.dart';
import 'package:bc_remates/ui/main/questions_answers.dart';
import 'package:bc_remates/ui/main/wait.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'config/notification_helper.dart';
import 'config/preferences.dart';
import 'config/useful.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   LocalNotification.showNotification(message);
//   print("Handling a background message: $message");
// }

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // await Preferences.init();
  //
  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp();
  // } else if (Platform.isIOS){
  //   await Firebase.initializeApp(
  //     /*options: FirebaseOptions(
  //     apiKey: WSConstants.API_KEY,
  //     appId: WSConstants.APP_ID,
  //     messagingSenderId: WSConstants.MESSGING_SENDER_ID,
  //     projectId: WSConstants.PROJECT_ID,
  //   )*/);
  // }
  //
  // LocalNotification.initialize();
  //
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  //
  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }
  //
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   LocalNotification.showNotification(message);
  //   print('Mensagem recebida: ${message.data}');
  // });
  //
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('Mensagem abertaaaaaaaaa: ${message.data}');
  //
  // });
  //
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white, //fundo de todo app
      primarySwatch: Useful().getMaterialColor(OwnerColors.colorPrimary),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Useful().getMaterialColor(OwnerColors.colorPrimary)),
      fontFamily: 'MontSerrat',
    ),
    debugShowCheckedModeBanner: false,
    title: "BC Remates",
    initialRoute:'/ui/splash',
    color: OwnerColors.colorPrimary,
    routes: {
      '/ui/splash': (context) => Splash(),
      '/ui/login': (context) => Login(),
      '/ui/register': (context) => RegisterOwnerData(),
      '/ui/home': (context) => Home(),
      '/ui/profile': (context) => Profile(),
      '/ui/auction_details': (context) => AuctionDetails(),
      // '/ui/pdf_viewer': (context) => PdfViewer(),
      '/ui/notifications': (context) => Notifications(),
      '/ui/recover_password': (context) => RecoverPassword(),
      '/ui/questions_answers': (context) => QuestionsAnswers(),
      '/ui/wait': (context) => WaitAdmin(),
      '/ui/validation_code': (context) => ValidationCode(),


    },
  ));
}