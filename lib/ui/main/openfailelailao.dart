import 'dart:async';
import 'dart:convert';

import 'package:bc_remates/model/leilao.dart';
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
import 'auction_details.dart';
import 'home.dart';

class OpenFaileLeilao extends StatefulWidget {
  int status;
  Leilao leilao;
  String idLeilao;

  OpenFaileLeilao({Key? key, required this.status, required this.leilao, required this.idLeilao})
      : super(key: key);

  @override
  State<OpenFaileLeilao> createState() => _OpenFaileLeilaoState();
}

class _OpenFaileLeilaoState extends State<OpenFaileLeilao> {
  Position? _currentPosition;
  final requestsWebServices = RequestsWebServices(WSConstantes.URLBASE);
  String statusParticipar = "04";
  late Timer _timer;
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

  bool isLoading = false;



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
          _showModalBottomSheet(context, msg);
        }else{
          _showModalBottomSheet(context, msg);
        }
      } else {
        print('NULO');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> participarLeilaoStatus(String idLeilao) async {
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

      final dynamic response = await requestsWebServices.sendPostRequest(
          Links.STATUS_OPEN_LEILAO, body);

      final decodedResponse = jsonDecode(response);
      if (decodedResponse != null) {
        final darLike = decodedResponse;
        String status = darLike["status"];
        if (status == "01") {
          setState(() {
            statusParticipar = status;
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AuctionDetails(
                        leilao: widget.leilao,
                        lat: _currentPosition!
                            .latitude
                            .toString(),
                        long: _currentPosition!
                            .longitude
                            .toString(),
                      )));
          _timer.cancel();
        } else if (status == "02") {
          setState(() {
            statusParticipar = status;
            isLoading = false;
          });
        } else {
          setState(() {
            statusParticipar = status;
          });
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
    participarLeilaoStatus(widget.idLeilao);
    _getCurrentPosition();
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      participarLeilaoStatus(widget.idLeilao);
      print('Função chamada a cada 3 segundos');
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
        statusParticipar != "04" ? Container(
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
                        child: statusParticipar == "03"
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
                        child: statusParticipar == "03"
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
                      if (statusParticipar == "03") {
                        setState(() {
                          isLoading = true;
                        });
                        participarLeilao(widget.idLeilao);
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                            ModalRoute.withName("/ui/home"));
                      }
                    },
                    child: !isLoading
                        ? statusParticipar != "03"
                            ? Text("Voltar",
                                style: Styles().styleDefaultTextButton)
                            : Text("Solicitar",
                                style: Styles().styleDefaultTextButton)
                        : const SizedBox(
                            width: Dimens.buttonIndicatorWidth,
                            height: Dimens.buttonIndicatorHeight,
                            child: CircularProgressIndicator(
                              color: OwnerColors.colorAccent,
                              strokeWidth: Dimens.buttonIndicatorStrokes,
                            )),
                  ),
                ),
                SizedBox(height: 40),
              ],
            )) : const Center(
              child: SizedBox(
              width: Dimens.buttonIndicatorWidth,
              height: Dimens.buttonIndicatorHeight,
              child: CircularProgressIndicator(
                color: OwnerColors.colorAccent,
                strokeWidth: Dimens.buttonIndicatorStrokes,
              )),
            )
      ]),
    );
  }

  void _showModalBottomSheet(BuildContext context, String msg) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Atenção",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimens.textSize6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: OwnerColors.darkGrey,
                  fontSize: Dimens.textSize6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Fecha a Bottom Sheet
                    },
                    child: Text('Fechar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
