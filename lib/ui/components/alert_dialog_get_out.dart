import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';

class GetOutAlertDialog extends StatefulWidget {
  GetOutAlertDialog({Key? key});

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<GetOutAlertDialog> createState() => _GetOutAlertDialog();
}

class _GetOutAlertDialog extends State<GetOutAlertDialog> {

  final postRequest = PostRequest();

  Future<void> sendRequest(String idAuction, String value, String lat, String long) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_leilao": idAuction,
        "latitude": lat,
        "longitude": long,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.SEND_REQUEST, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      // final response = User.fromJson(parsedResponse);
      //
      // if (response.status == "01") {
      //   setState(() {});
      // } else {}
      // ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.paddingApplication,
                Dimens.paddingApplication,
                Dimens.paddingApplication,
                MediaQuery.of(context).viewInsets.bottom +
                    Dimens.paddingApplication),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
                // SizedBox(height: Dimens.minMarginApplication),
                Image.asset("images/notification_important.png", height: 40, width: 40,),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  textAlign: TextAlign.center,
                  "Você tem certeza que gostaria de entrar no leilão?",
                  style: TextStyle(
                    fontSize: Dimens.textSize6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                SizedBox(height: Dimens.marginApplication),
                Row( children: [
                  Expanded(child:
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: Styles().styleDefaultButton,
                      onPressed: () async {

                        Navigator.of(context).pop(true);
                      },
                      child: /* (_isLoading)
                                  ? const SizedBox(
                                  width: Dimens.buttonIndicatorWidth,
                                  height: Dimens.buttonIndicatorHeight,
                                  child: CircularProgressIndicator(
                                    color: OwnerColors.colorAccent,
                                    strokeWidth: Dimens.buttonIndicatorStrokes,
                                  ))
                                  :*/
                      Text("Sim", style: Styles().styleDefaultTextButton),
                    ),
                  )),
                  SizedBox(width: Dimens.marginApplication),
                  Expanded(child:
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: Styles().styleOutlinedRedButton,
                      onPressed: () async {

                        Navigator.of(context).pop();
                      },
                      child: /* (_isLoading)
                                  ? const SizedBox(
                                  width: Dimens.buttonIndicatorWidth,
                                  height: Dimens.buttonIndicatorHeight,
                                  child: CircularProgressIndicator(
                                    color: OwnerColors.colorAccent,
                                    strokeWidth: Dimens.buttonIndicatorStrokes,
                                  ))
                                  :*/
                      Text("Não", style: Styles().styleOutlinedRedTextButton),
                    ),
                  )),
                ],)

              ],
            ),
          ),
        ]));
  }
}
