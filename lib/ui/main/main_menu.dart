import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../auth/login/login.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  final postRequest = PostRequest();
  User? _profileResponse;

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> loadProfileRequest() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PROFILE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> disableAccount() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.DISABLE_ACCOUNT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.init();
        Preferences.clearUserData();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            ModalRoute.withName("/ui/login"));
      } else {}
      ApplicationMessages(context: context)
          .showMessage(response.msg + "\n\n" + Strings.enable_account);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }
  abrirWhatsApp() async {
    //Número de telefone do WhatsApp
    String phoneNumber = "+5555999751533";
    // Adicione uma mensagem inicial, se desejar
    String message = "Olá!";

    // O link que será aberto no WhatsApp
    String whatsappUrl =
        "https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}";
    await launchUrl(Uri.parse(whatsappUrl));
    // Verifica se o URL pode ser lançado
    // if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
    //   await launchUrl(Uri.parse(whatsappUrl));
    // } else {
    //   throw 'Não foi possível abrir $whatsappUrl';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Perfil", isVisibleBackButton: false),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                child: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                // Expanded(
                FutureBuilder<Map<String, dynamic>>(
                  future: loadProfileRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final response = User.fromJson(snapshot.data!);

                      return Material(
                          elevation: Dimens.elevationApplication,
                          child: Container(
                            padding:
                                EdgeInsets.all(Dimens.maxPaddingApplication),
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      right: Dimens.marginApplication),
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: Size.fromRadius(42),
                                      // Image radius
                                      child: Image.network(
                                          ApplicationConstant.URL_AVATAR +
                                              response.avatar.toString(),
                                          fit: BoxFit.cover,
                                          /*fit: BoxFit.cover*/
                                          errorBuilder: (context, exception,
                                                  stackTrack) =>
                                              Image.asset(
                                                'images/person.jpg',
                                              )),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        response.nome,
                                        style: TextStyle(
                                          fontSize: Dimens.textSize6,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        response.email,
                                        style: TextStyle(
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    'images/edit.png',
                                    width: 22,
                                    height: 22,
                                  ),
                                  onPressed: () => {
                                    Navigator.pushNamed(context, "/ui/profile")
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return Styles().defaultLoading;
                  },
                ),

                // Styles().div_horizontal,

                InkWell(

                    child: Container(
                      padding: EdgeInsets.all(Dimens.paddingApplication),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Suporte",
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            'images/zap.png',
                            height: 22,
                            width: 22,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      abrirWhatsApp();
                    }),

                InkWell(
                    child: Container(
                      padding: EdgeInsets.all(Dimens.paddingApplication),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dúvidas frequentes",
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            size: 20,
                            Icons.arrow_forward_ios,
                            color: OwnerColors.colorPrimary,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/ui/questions_answers");
                    }),

                InkWell(
                    child: Container(
                      padding: EdgeInsets.all(Dimens.paddingApplication),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Desativar conta",
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            size: 20,
                            Icons.arrow_forward_ios,
                            color: OwnerColors.colorPrimary,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        context: context,
                        shape: Styles().styleShapeBottomSheet,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        builder: (BuildContext context) {
                          return GenericAlertDialog(
                              title: Strings.attention,
                              content: Strings.disable_account,
                              btnBack: TextButton(
                                  child: Text(Strings.no,
                                      style: TextStyle(
                                        color: Colors.black54,
                                      )),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              btnConfirm: TextButton(
                                  child: Text(Strings.yes),
                                  onPressed: () {
                                    disableAccount();
                                  }));
                        },
                      );
                    }),

                Spacer(),

                Container(
                  margin: EdgeInsets.all(Dimens.marginApplication),
                  width: double.infinity,
                  child: OutlinedButton(
                      style: Styles().styleOutlinedRedButton,
                      onPressed: () async {
                        showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          context: context,
                          shape: Styles().styleShapeBottomSheet,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          builder: (BuildContext context) {
                            return GenericAlertDialog(
                                title: Strings.attention,
                                content: Strings.logout,
                                btnBack: TextButton(
                                    child: Text(
                                      Strings.no,
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                btnConfirm: TextButton(
                                    child: Text(Strings.yes),
                                    onPressed: () async {
                                      await Preferences.init();
                                      Preferences.clearUserData();

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()),
                                          ModalRoute.withName("/ui/login"));
                                    }));
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login_outlined, color: Colors.red),
                          SizedBox(width: 10),
                          Text(
                            "Sair",
                            style: Styles().styleOutlinedRedTextButton,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ]))));
  }
}
