import 'dart:convert';

import 'package:bc_remates/ui/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../configJ/constants.dart';
import '../../configJ/requests.dart';
import '../../global/application_constant.dart';
import '../../res/strings.dart';
import '../../web_service/links.dart';
import '../components/alert_dialog_sucess.dart';
import 'home.dart';

class OpenFaileLeilao extends StatefulWidget {
  int status;
  String idLeilao;

  OpenFaileLeilao({Key? key, required this.status, required this.idLeilao})
      : super(key: key);

  @override
  State<OpenFaileLeilao> createState() => _OpenFaileLeilaoState();
}

class _OpenFaileLeilaoState extends State<OpenFaileLeilao> {
  Position? _currentPosition;
  final requestsWebServices = RequestsWebServices(WSConstantes.URLBASE);

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ApplicationMessages(context: context)
          .showMessage(Strings.disable_gps_description);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ApplicationMessages(context: context)
            .showMessage(Strings.disable_gps_forever);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ApplicationMessages(context: context)
          .showMessage(Strings.disable_gps_forever);
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> participarLeilao(String idLeilao) async {
    try {
      await Preferences.init();
      int userId = Preferences.getUserData()!.id;
      final body = {
        "id_user": userId.toString(),
        "id_leilao": idLeilao,
        "latitude": _currentPosition!.latitude.toString(),
        "longitude": _currentPosition!.longitude.toString(),
        "token": ApplicationConstant.TOKEN
      };

      final dynamic response =
          await requestsWebServices.sendPostRequest(Links.SEND_REQUEST, body);

      final decodedResponse = jsonDecode(response);
      if (decodedResponse != null) {
        final darLike = decodedResponse;
        String status = darLike["status"];
        String msg = darLike["msg"];
        if (status == "01") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 0,
                shadowColor: OwnerColors.colorPrimaryDark,
                backgroundColor: OwnerColors.colorPrimaryDark,
                // Defina a forma do diálogo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                // Conteúdo do diálogo
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Fecha o diálogo quando o botão é pressionado
                          Navigator.of(context).pop();

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              ModalRoute.withName("/ui/home"));
                        },
                        child: Text(
                          'Fechar',
                          style: TextStyle(
                            fontSize: 18,
                            color: OwnerColors.colorPrimaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              ;
            },
          );
        }
      } else {
        print('NULO');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getCurrentPosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitação'),
        centerTitle: false,
        leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: OwnerColors.colorPrimaryDark,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    ModalRoute.withName("/ui/home"));
              },
            )),
      ),
      body: Stack(fit: StackFit.expand, children: [
        /*Expanded(
          child: */
        Image.asset(
          'images/bg_main.png',
          fit: BoxFit.fitWidth,
        ),
        // ),
        Container(
            padding: EdgeInsets.all(Dimens.paddingApplication),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Image.asset(
                        'images/fact_check.png',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: Dimens.minMarginApplication),
                      Container(
                        width: double.infinity,
                        child: widget.status == 3
                            ? Text(
                                textAlign: TextAlign.center,
                                "Solicitar Participação",
                                style: TextStyle(
                                  fontSize: Dimens.textSize8,
                                  color: Colors.black87,
                                ),
                              )
                            : Text(
                                textAlign: TextAlign.center,
                                "Aguarda Aprovação",
                                style: TextStyle(
                                  fontSize: Dimens.textSize8,
                                  color: Colors.black87,
                                ),
                              ),
                      ),
                      SizedBox(height: Dimens.minMarginApplication),
                      Container(
                        width: double.infinity,
                        child: widget.status == 3
                            ? Text(
                                textAlign: TextAlign.center,
                                "Para participar do leilão, é essencial solicitar sua entrada, garantindo assim a oportunidade de envolvimento nas negociações.",
                                style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black54,
                                ),
                              )
                            : Text(
                                textAlign: TextAlign.center,
                                "Após a solicitação, pedimos que aguarde a liberação para participação no leilão.",
                                style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black54,
                                ),
                              ),
                      ),
                    ])),
                Container(
                  margin: EdgeInsets.only(top: Dimens.marginApplication),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: Styles().styleDefaultButton,
                    onPressed: () async {
                      print(widget.status);
                      if (widget.status == 3) {
                        participarLeilao(widget.idLeilao);
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                            ModalRoute.withName("/ui/home"));
                      }
                    },
                    child: widget.status == 2
                        ? Text("Voltar", style: Styles().styleDefaultTextButton)
                        : Text("Solicitar",
                            style: Styles().styleDefaultTextButton),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ))
      ]),
    );
  }
}
