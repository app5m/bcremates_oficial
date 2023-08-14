import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/application_messages.dart';
import '../../../config/masks.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({Key? key}) : super(key: key);

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  late Validator validator;
  final postRequest = PostRequest();

  late bool _isLoading = false;

  @override
  void initState() {
    validator = Validator(context: context);
    super.initState();
  }

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> recoverPasswordByEmail(String email) async {
    try {
      final body = {
        "email": email,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.RECOVER_PASSWORD_TOKEN, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {

        Navigator.of(context).pop();
      } else {

      }

      ApplicationMessages(context: context).showMessage(response.msg);
      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(isVisibleBackButton: true),
        body: Stack(fit: StackFit.expand, children: [
          Expanded(
            child: Image.asset(
              'images/bg_main.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
              child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.all(Dimens.marginApplication),
                    child: CustomScrollView(slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                "Recuperar senha",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: Dimens.textSize8,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(height: Dimens.minMarginApplication),
                            Container(
                              width: double.infinity,
                              child: Text(
                                "Digite seu e-mail para iniciar o processo de recuperação." /*? "Insira seus dados pessoais." : "Cadastre seu e-mail e senha."*/,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            SizedBox(height: 32),
                            Container(
                              width: double.infinity,
                              margin:
                              EdgeInsets.only(bottom: Dimens.minMarginApplication),
                              child: Text(
                                "E-mail",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: OwnerColors.colorPrimary, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'exemplo@email.com',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(Dimens.radiusApplication),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                EdgeInsets.all(Dimens.textFieldPaddingApplication),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Dimens.textSize5,
                              ),
                            ),
                            SizedBox(height: 48),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(top: Dimens.marginApplication),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: Styles().styleDefaultButton,
                                onPressed: () async {

                                },
                                child: (_isLoading)
                                    ? const SizedBox(
                                    width: Dimens.buttonIndicatorWidth,
                                    height: Dimens.buttonIndicatorHeight,
                                    child: CircularProgressIndicator(
                                      color: OwnerColors.colorAccent,
                                      strokeWidth: Dimens.buttonIndicatorStrokes,
                                    ))
                                    : Text("Enviar",
                                    style: Styles().styleDefaultTextButton),
                              ),
                            ),
                            SizedBox(height: Dimens.marginApplication),

                          ],
                        ),
                      ),
                    ]),
                  )))
        ]));
  }
}

