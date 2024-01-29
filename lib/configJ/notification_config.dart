import 'dart:convert';

import 'package:bc_remates/config/preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:path/src/context.dart';


import '../model/notification.dart';


class LocalNotification1 {
  NotificationPop notification = NotificationPop();
  static final FlutterLocalNotificationsPlugin _notiPlugin =
  FlutterLocalNotificationsPlugin();

  void initialize(GlobalKey<NavigatorState> navigatorKey) async {
    const iosInitializationSetting = DarwinInitializationSettings();
    final InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
      iOS: iosInitializationSetting,
    );
    _notiPlugin.initialize(initialSettings,
        onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
          final String? payload = details.payload;
          details.notificationResponseType.name;
          if (details.payload != null) {
            //    NotificationPop notification = NotificationPop.;
            String dados = details.payload!;
            dados = dados.replaceAllMapped(
              RegExp(r'(\w+): ([^,}\]]+)(?=[,}\]])'), // Matches key: value
                  (Match match) => '"${match.group(1)}": "${match.group(2)}"', // Adds quotes around the value
            );


            print(dados);
            Map<String, dynamic> valueMap = jsonDecode(dados);
            //Map<String, dynamic> payloadMap = json.decode(dados);

            print(" OLA AQUI CAIU $valueMap");
            //  NotificationPop notification = NotificationPop.fromJson(valueMap);
            // Access the values in the map
            String titulo = valueMap['titulo'];
            String type = valueMap['type'];
            String descricao = valueMap['descricao'];
            String id_anuncio = valueMap['id_anuncio'];
            String id_de = valueMap['id_de'];
            print('Título: $titulo');
            print('Tipo: $type');
            print('Descrição: $descricao');
            print('ID do Anúncio: $id_anuncio');
            await Preferences.init();
            String userId = Preferences.getUserData()!.id.toString();




            debugPrint('notification payload: $payload');

            /*
            if(type == "anuncio"){
              await Navigator.of(navigatorKey.currentContext!).push(
                MaterialPageRoute(
                  builder: (context) => DetailRecebedor(
                    idAd: id_anuncio,
                    veio: '0',
                  ),
                ),
              );
            }
            else if(type == "chat"){
              await Navigator.of(navigatorKey.currentContext!)..push(
                MaterialPageRoute(
                  builder: (context) => ChatDoadorRecebedor(
                    type: 3,
                    id_de: id_de,
                    id_para: userId,
                    idAnuncio: id_anuncio,
                    nameUser: "",
                  ),
                ),
              );
            }
            FlutterAppBadger.removeBadge();

             */


          }
        });
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse details) {
    // ...
    //onSelectNotification(details);
  }

  void showNotification(RemoteMessage message) {
    NotificationPop notification = NotificationPop.fromJson(message.data);

    print(" dados da notificaçao ${message.data}");
    const iosNotificatonDetail = DarwinNotificationDetails();
    final NotificationDetails notiDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'com.bcremates.push_notification',
          'push_notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentBadge: true,
          badgeNumber: 1
        ));

    _notiPlugin.show(
      DateTime.now().microsecond,
      notification.title,
      notification.description,
      notiDetails,
      payload: message.data.toString(),
    );
    // getNotification(notification);
  }

  RemoteMessage pegadados(RemoteMessage message) {
    return message;
  }

  static void onSelectNotification(
      NotificationResponse notificationResponse) async {
    var payloadData = jsonDecode(notificationResponse.payload!);
    print(payloadData);
    print("onSelectNotification: ${payloadData.toString()}");

    /*
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    if (payloadData["type"] == "anuncio") {
      // Navegar para a tela desejada usando o Navigator
      // Certifique-se de ter a rota correta definida no MaterialApp
      Navigator.of(navigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder: (context) => DetailRecebedor(
            idAd: payloadData["id_anuncio"],
            veio: '0',
          ),
        ),
      );
    } else {
      print(payloadData["type"]);
    }

     */
  }

  void getNotification(RemoteMessage message) {
    print('Os dados chegou aqui');
    notification = NotificationPop.fromJson(message.data);
  }
}