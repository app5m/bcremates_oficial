import 'dart:async';
import 'dart:convert';

import 'package:bc_remates/model/leilao.dart';
import 'package:bc_remates/ui/main/playVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../configJ/constants.dart';
import '../../configJ/mask.money.dart';
import '../../configJ/requests.dart';
import '../../global/application_constant.dart';
import '../../model/lotes.dart';
import '../../model/user.dart';
import '../../model/videoAPI.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../auth/login/login.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';
import 'home.dart';

class AuctionDetails extends StatefulWidget {
  Leilao leilao;
  String lat;
  String long;

  AuctionDetails(
      {Key? key, required this.leilao, required this.lat, required this.long})
      : super(key: key);

  @override
  State<AuctionDetails> createState() => _AuctionDetailsState();
}

class _AuctionDetailsState extends State<AuctionDetails> {
  bool _isLoading = false;
  bool _isLoadingDialog = false;
  final requestsWebServices = RequestsWebServices(WSConstantes.URLBASE);
  List<Lotes> lotesNow = [];
  List<Lotes> lotesNowFull = [];
  List<Lotes> lotesNextFull = [];
  List<Lotes> lotesNext = [];
  var isVisible = false;
  var oldIndex = 99999999999;
  Position? _currentPosition;
  late Validator validator;
  final postRequest = PostRequest();
  VideoAPI videoAPI = VideoAPI();
  User? _profileResponse;
  List<TextEditingController> textControllersAtual = [];
  List<TextEditingController> textControllersMeu = [];

  bool listEquals(List<Lotes> list1, List<Lotes> list2) {
    if (list1 == null && list2 == null) {
      print("Aqui 1");
      return true;
    }
    if (list1 == null || list2 == null) {
      print("Aqui 2");
      return false;
    }
    if (list1.length != list2.length) {
      print("Aqui 2.5 ${list1.length}");
      print("Aqui 2.6 ${list2.length}");
      return false;
    }


    for (int i = 0; i < list1.length; i++) {
      print(list1[i].maiorLance);
      print(list2[i].maiorLance);
      if (list1[i].maiorLance != list2[i].maiorLance) {
        print("Aqui 4");
        return false;
      }
    }
    return true;
  }


  Future<List<Map<String, dynamic>>> listAoVivo() async {
    try {
      final body = {"token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_AO_VIVO, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      videoAPI = VideoAPI.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> listLeilao({
    required String lat,
    required String long,
    required String idLeilao,
  }) async {
    setState(() {
      lotesNowFull.clear();
      lotesNextFull.clear();
    });
    try {
      await Preferences.init();
      int userId = Preferences.getUserData()!.id;
      final body = {
        'id_user': userId,
        'id_leilao': idLeilao,
        'latitude': lat,
        'longitude': long,
        "token": ApplicationConstant.TOKEN
      };

      final List<dynamic> decodedResponse = await requestsWebServices
          .sendPostRequestList(WSConstantes.LIST_ALL_LOTES, body);

      if (decodedResponse.isNotEmpty) {
        if (decodedResponse[0]['rows'] != 0) {
          for (final itens in decodedResponse) {
            if (itens['status_lote'] == 1) {
              Lotes lotes = Lotes.fromJson(itens);
              setState(() {
                lotesNowFull.add(lotes);
              });
            }
            else {
              Lotes lotes = Lotes.fromJson(itens);
              setState(() {
                lotesNextFull.add(lotes);
              });

            }
          }
          if (!listEquals(lotesNowFull, lotesNow)) {
            setState(() {
              lotesNow.clear();
            });
            for(Lotes l in lotesNowFull ){
              setState(() {
                lotesNow.add(l);
              });
            }
            print('As listas são diferentes. lotesNow foi atualizado.');

            setState(() {
              textControllersAtual.clear();
              textControllersMeu.clear();
            });
            for (int i = 0; i < lotesNow.length; i++) {
              setState(() {
                textControllersAtual.add(TextEditingController());
                textControllersMeu.add(TextEditingController());
              });
            }

            for (int i = 0; i < lotesNow.length; i++) {
              setState(() {
                textControllersMeu[i].text =
                "${formatarValor(converterStringParaDouble(lotesNow[i].maiorLance!) + 50)}";
              });

            }
          } else {
            // Se forem iguais, não há necessidade de fazer nada
            print('As listas são iguais. Nenhuma atualização é necessária.');
          }
          if (!listEquals(lotesNextFull, lotesNext)) {
            // Se as listas forem diferentes, atualize lotesNow

            setState(() {
              lotesNext.clear();
            });
            for(Lotes l in lotesNextFull ){
              setState(() {
                lotesNext.add(l);
              });
            }
            setState(() {
              lotesNext = List.from(lotesNextFull);
            });
            print('As listas são diferentes. lotesNext foi atualizado.');
          } else {
            // Se forem iguais, não há necessidade de fazer nada
            print('As listas são iguais. Nenhuma atualização é necessária.');
          }




          print("Tamanho da lista de Lotes 1: ${lotesNow.length}");
          print("Tamanho da lista de Lotes 2: ${lotesNext.length}");
        }
      } else {
        print('NULO');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> darLance({
    required String lat,
    required String long,
    required String idLeilao,
    required String idLote,
    required String valor,
  }) async {
    try {
      await Preferences.init();
      int userId = Preferences.getUserData()!.id;
      final body = {
        'id_user': userId,
        'id_leilao': idLeilao,
        'id_lote': idLote,
        'valor': valor,
        'latitude': lat,
        'longitude': long,
        "token": ApplicationConstant.TOKEN
      };

      final dynamic decodedResponse = await requestsWebServices.sendPostRequest(
          WSConstantes.DAR_LANCE, body);
      final response = jsonDecode(decodedResponse);
      if (response.isNotEmpty) {
        if (response['status'] == "01") {
          setState(() {
            Fluttertoast.showToast(msg: response['msg']);
          });
          listLeilao(
              lat: widget.lat,
              long: widget.long,
              idLeilao: widget.leilao.id.toString());
        } else {
          setState(() {
            Fluttertoast.showToast(msg: response['msg']);
          });
        }
      } else {
        print('NULO');
      }
    } catch (e) {
      print(e);
    }
  }
  late Timer _timer;
  void startTimer() {
    setState(() {
      _timer = Timer.periodic(Duration(seconds: 4), (timer) {
        listLeilao(
            lat: widget.lat,
            long: widget.long,
            idLeilao: widget.leilao.id.toString());
        print('Função chamada a cada 2 segundos');
      });
    });

  }

  @override
  void initState() {
    listAoVivo();
    listLeilao(
        lat: widget.lat,
        long: widget.long,
        idLeilao: widget.leilao.id.toString());
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    // Dispose todos os controladores de texto para evitar vazamentos de memória
    for (var controller in textControllersAtual) {
      controller.dispose();
    }
    for (var controller in textControllersMeu) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> listAllotmentDetails(
      String idAuction, String value, String lat, String long) async {
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
          await postRequest.sendPostRequest(Links.LIST_ALLOTMENT_DETAILS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      // final response = User.fromJson(_map[0]);
      //
      // if (response.status == "01") {
      //
      // } else {}
      // ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveBid(String idAllotment, String idAuction, String value,
      String lat, String long) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_lote": idAllotment,
        "id_leilao": idAuction,
        "valor": value,
        "latitude": lat,
        "longitude": long,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_BID, body);
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

  String formatarValor(double valor) {
    NumberFormat realFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return realFormat.format(valor);
  }

  double converterStringParaDouble(String valorMonetario) {
    // Remove o símbolo 'R$' e '.' e substitui ',' por '' para poder fazer o parse corretamente
    String valorFormatado =
        valorMonetario.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');

    // Parse para double
    double valorConvertido = double.parse(valorFormatado);

    return valorConvertido;
  }

  String adicionarCinquentaReais(String valorAntigo) {
    // Remove o símbolo 'R$ ' e ',' da string e converte para double
    double valorNumerico =
        double.parse(valorAntigo.replaceAll(RegExp(r'[^\d]'), ''));

    // Adiciona 50 ao valor
    valorNumerico += 50;

    // Formata o valor de volta para o formato de moeda 'R$ x,xx'
    String novoValor = 'R\$ ${valorNumerico.toStringAsFixed(2)}';

    return novoValor;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listHighlightsRequest();
      _isLoading = false;
    });

    await listLeilao(
        lat: widget.lat,
        long: widget.long,
        idLeilao: widget.leilao.id.toString());
  }

  String formatarDataEHora(String data, String horario) {
    // Separar a data em dia, mês e ano
    List<String> partesData = data.split('/');
    int dia = int.parse(partesData[0]);
    int mes = int.parse(partesData[1]);
    // int ano = int.parse(partesData[2]); // Se precisar do ano por algum motivo

    // Separar o horário em horas e minutos
    List<String> partesHorario = horario.split(':');
    int horas = int.parse(partesHorario[0]);
    int minutos = int.parse(partesHorario[1]);

    // Formatar a data e hora no formato desejado
    String dataFormatada = '$dia/$mes';
    String horaFormatada = '$horas:$minutos';

    // Retornar a data e hora formatadas
    return '$dataFormatada às $horaFormatada';
  }

  double _top = 0.0;
  double _left = 0.0;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      videoAPI.live != null
                          ? Container(
                        width: double.infinity,
                        child: VideoPlayerScreen(
                          video: videoAPI,
                        ),
                      )
                          : Image.network(
                        WSConstantes.URL_LEILAO + widget.leilao.urlLeilao!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, exception, stackTrack) =>
                            Image.asset(
                              'images/leilao2.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                      ),
                      MediaQuery.of(context).orientation.name == "portrait" ?     Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(top: 36, left: 20),
                            child: FloatingActionButton(
                              elevation: Dimens.minElevationApplication,
                              mini: true,
                              child: Icon(Icons.arrow_back_ios_outlined,
                                  color: OwnerColors.colorPrimary),
                              backgroundColor: Colors.white,
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                    ModalRoute.withName("/ui/home"));
                              },
                            )),
                      ) : Container(),
                    ],
                  ),
                ),
                MediaQuery.of(context).orientation.name == "portrait" ? Container(
                  height: MediaQuery.of(context).size.height - 250,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Dimens.marginApplication,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: Dimens.marginApplication,
                                            right: Dimens.marginApplication),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                widget.leilao.nomeLeilao!,
                                                style: TextStyle(
                                                  fontSize: Dimens.textSize7,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            // Text(
                                            //   "Ver mais",
                                            //   style: TextStyle(
                                            //     fontSize: Dimens.textSize5,
                                            //     color: OwnerColors.colorPrimaryDark,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 4,
                                              left: Dimens.marginApplication,
                                              right: Dimens.marginApplication),
                                          child: Text(
                                            "${widget.leilao.cidadeLeilao} - ${widget.leilao.estadoLeilao}",
                                            style: TextStyle(
                                              fontSize: Dimens.textSize4,
                                              color: Colors.black87,
                                            ),
                                          ))
                                    ]),
                              ),
                              Expanded(
                                  flex: 0,
                                  child: Container(
                                      margin: EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_month_outlined,
                                              color: OwnerColors.colorPrimary,
                                              size: 16),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            formatarDataEHora(
                                                widget.leilao.dataInicio!,
                                                widget.leilao.hora!),
                                            style: TextStyle(
                                              fontSize: Dimens.textSize4,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimens.marginApplication),
                                        ],
                                      )))
                            ],
                          ),
                          SizedBox(
                            height: Dimens.marginApplication,
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                left: Dimens.marginApplication,
                                right: Dimens.marginApplication,
                              ),
                              child: Styles().div_horizontal),
                          SizedBox(
                            height: Dimens.marginApplication,
                          ),
                          // if (videoAPI.live != null)
                          //   Container(
                          //     margin: EdgeInsets.only(
                          //         left: Dimens.marginApplication,
                          //         right: Dimens.marginApplication),
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //           child: Text(
                          //             "Assista agora!",
                          //             style: TextStyle(
                          //               fontSize: Dimens.textSize5,
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.black,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // if (videoAPI.live != null)
                          //

                          RefreshIndicator(
                            onRefresh: _pullRefresh,
                            child: lotesNow.isNotEmpty ? Container(
                              height: 530 * lotesNow.length.toDouble(),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: lotesNow.length,
                                  itemBuilder: (context, index) {


                                    return Container(
                                      child: Column(
                                        children: [
                                          Card(
                                            elevation: 0,
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                Dimens.marginApplication,
                                                vertical: 8),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(Dimens
                                                    .minRadiusApplication),
                                                side: BorderSide(
                                                    color:
                                                    OwnerColors.lightGrey,
                                                    width: 1.0)),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(Dimens
                                                                .minRadiusApplication),
                                                            topRight: Radius
                                                                .circular(Dimens
                                                                .minRadiusApplication)),
                                                        color: OwnerColors
                                                            .colorPrimary),
                                                    padding: EdgeInsets.all(
                                                        Dimens
                                                            .paddingApplication),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Lote Ativo (${lotesNow[index].numeroLote})",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize6,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color:
                                                              Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Row(children: [
                                                    Expanded(
                                                        child: lotesNow[index]
                                                            .urlLote !=
                                                            null
                                                            ? Image.network(
                                                          WSConstantes
                                                              .URL_LEILAO +
                                                              lotesNow[
                                                              index]
                                                                  .urlLote!,
                                                          fit: BoxFit
                                                              .cover,
                                                          height: 140,
                                                        )
                                                            : Image.network(
                                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8lRbS7eKYzDq-Ftxc1p8G_TTw2unWBMEYUw&usqp=CAU",
                                                          fit: BoxFit
                                                              .cover,
                                                          height: 140,
                                                        )),
                                                    SizedBox(
                                                      width: Dimens
                                                          .marginApplication,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: Dimens
                                                                  .marginApplication),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Text(
                                                                  "Lance atual",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize6,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: OwnerColors
                                                                        .colorPrimaryDark,
                                                                  )),
                                                              SizedBox(
                                                                  height: 2),
                                                              Text(
                                                                  lotesNow[
                                                                  index]
                                                                      .maiorLance!,
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize6,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: OwnerColors
                                                                        .colorPrimary,
                                                                  )),
                                                            ],
                                                          )),
                                                    ),
                                                  ]),
                                                  Styles().div_horizontal,
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: Dimens
                                                              .paddingApplication,
                                                          right: Dimens
                                                              .paddingApplication,
                                                          top: Dimens
                                                              .minPaddingApplication),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                      .minPaddingApplication),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          "Número",
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Dimens.textSize6,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            Colors.black,
                                                                          )),
                                                                      Text(
                                                                        lotesNow[index]
                                                                            .qtdAnimais!
                                                                            .toString(),
                                                                        style:
                                                                        TextStyle(
                                                                          fontSize:
                                                                          Dimens.textSize5,
                                                                          color:
                                                                          OwnerColors.colorPrimary,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ))),
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                      .minPaddingApplication),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          "Categoria",
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Dimens.textSize6,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            Colors.black,
                                                                          )),
                                                                      Text(
                                                                        lotesNow[index]
                                                                            .categoriaLote!,
                                                                        style:
                                                                        TextStyle(
                                                                          fontSize:
                                                                          Dimens.textSize5,
                                                                          color:
                                                                          OwnerColors.colorPrimary,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )))
                                                        ],
                                                      )),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: Dimens
                                                              .paddingApplication,
                                                          right: Dimens
                                                              .paddingApplication,
                                                          top: Dimens
                                                              .minPaddingApplication,
                                                          bottom: Dimens
                                                              .minPaddingApplication),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                      .minPaddingApplication),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          "Peso",
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Dimens.textSize6,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            Colors.black,
                                                                          )),
                                                                      Text(
                                                                        lotesNow[index]
                                                                            .peso!,
                                                                        style:
                                                                        TextStyle(
                                                                          fontSize:
                                                                          Dimens.textSize5,
                                                                          color:
                                                                          OwnerColors.colorPrimary,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ))),
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                      .minPaddingApplication),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          "Raça",
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Dimens.textSize6,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            Colors.black,
                                                                          )),
                                                                      Text(
                                                                        lotesNow[index]
                                                                            .racaoPelo!,
                                                                        style:
                                                                        TextStyle(
                                                                          fontSize:
                                                                          Dimens.textSize5,
                                                                          color:
                                                                          OwnerColors.colorPrimary,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )))
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      Dimens
                                                                          .minRadiusApplication)),
                                                              color: OwnerColors
                                                                  .colorPrimaryDark),
                                                          margin: EdgeInsets.all(
                                                              Dimens
                                                                  .marginApplication),
                                                          child: IntrinsicHeight(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: TextField(
                                                                      controller:
                                                                      textControllersAtual[
                                                                      index],
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter
                                                                            .digitsOnly,
                                                                        CurrencyInputFormatter()
                                                                      ],
                                                                      keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                      decoration:
                                                                      InputDecoration(
                                                                        hintText:
                                                                        'Digitar',
                                                                        hintStyle: TextStyle(
                                                                            color: Colors
                                                                                .white60),
                                                                        filled: false,
                                                                        border:
                                                                        InputBorder
                                                                            .none,
                                                                        fillColor:
                                                                        Colors
                                                                            .white,
                                                                        contentPadding:
                                                                        EdgeInsets.all(
                                                                            Dimens
                                                                                .textFieldPaddingApplication),
                                                                      ),
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: Dimens
                                                                            .textSize5,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(
                                                                    color: Colors.white,
                                                                    width: 2,
                                                                    thickness: 1.5,
                                                                    indent: 6,
                                                                    endIndent: 6,
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        darLance(
                                                                          lat: widget
                                                                              .lat,
                                                                          long: widget
                                                                              .long,
                                                                          idLeilao: widget
                                                                              .leilao
                                                                              .id!
                                                                              .toString(),
                                                                          idLote: lotesNow[
                                                                          index]
                                                                              .idLote
                                                                              .toString(),
                                                                          valor: textControllersAtual[
                                                                          index]
                                                                              .text
                                                                              ,
                                                                        );
                                                                      },
                                                                      icon: Image.asset(
                                                                          'images/gavel.png',
                                                                          width: 24,
                                                                          height: 24)),
                                                                ],
                                                              ))),
                                                      Text(
                                                        "Lance atual: ${lotesNow[index].maiorLance}",
                                                        style: TextStyle(
                                                          fontSize:
                                                          Dimens.textSize4,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(
                                                  flex: 0,
                                                  child: Container(
                                                    child: Text(
                                                      "ou",
                                                      style: TextStyle(
                                                        fontSize:
                                                        Dimens.textSize5,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      Dimens
                                                                          .minRadiusApplication)),
                                                              color: OwnerColors
                                                                  .colorPrimaryDark),
                                                          margin: EdgeInsets.all(
                                                              Dimens
                                                                  .marginApplication),
                                                          child: IntrinsicHeight(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: TextField(
                                                                      controller:
                                                                      textControllersMeu[
                                                                      index],
                                                                      enabled: false,
                                                                      decoration:
                                                                      InputDecoration(
                                                                        hintText:
                                                                        'Digitar',
                                                                        hintStyle: TextStyle(
                                                                            color: Colors
                                                                                .white60),
                                                                        filled: false,
                                                                        border:
                                                                        InputBorder
                                                                            .none,
                                                                        fillColor:
                                                                        Colors
                                                                            .white,
                                                                        contentPadding:
                                                                        EdgeInsets.all(
                                                                            Dimens
                                                                                .textFieldPaddingApplication),
                                                                      ),
                                                                      keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: Dimens
                                                                            .textSize5,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(
                                                                    color: Colors.white,
                                                                    width: 2,
                                                                    thickness: 1.5,
                                                                    indent: 6,
                                                                    endIndent: 6,
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        darLance(
                                                                          lat: widget
                                                                              .lat,
                                                                          long: widget
                                                                              .long,
                                                                          idLeilao: widget
                                                                              .leilao
                                                                              .id!
                                                                              .toString(),
                                                                          idLote: lotesNow[
                                                                          index]
                                                                              .idLote
                                                                              .toString(),
                                                                          valor: textControllersMeu[
                                                                          index]
                                                                              .text,
                                                                        );
                                                                      },
                                                                      icon: Image.asset(
                                                                          'images/gavel.png',
                                                                          width: 24,
                                                                          height: 24)),
                                                                ],
                                                              ))),
                                                      Text(
                                                        "Atual + R\$ 50",
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize:
                                                          Dimens.textSize4,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                left: Dimens.marginApplication,
                                                right: Dimens.marginApplication,
                                              ),
                                              child: Styles().div_horizontal),
                                        ],
                                      ),
                                    );
                                  }),
                            ) : Center(child: CircularProgressIndicator(),),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.marginApplication),
                              child: ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: lotesNext.length,
                                itemBuilder: (context, index) {
                                  // final response =
                                  // Product.fromJson(snapshot.data![index]);

                                  return InkWell(
                                    onTap: () {},
                                    child: Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.minRadiusApplication),
                                            side: BorderSide(
                                                color: OwnerColors.lightGrey,
                                                width: 1.0)),
                                        child: Column(children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                  OwnerColors.colorAccent,
                                                  borderRadius: !isVisible ||
                                                      oldIndex != index
                                                      ? BorderRadius.all(
                                                      Radius.circular(Dimens
                                                          .minRadiusApplication))
                                                      : BorderRadius.only(
                                                      topLeft: Radius.circular(Dimens
                                                          .minRadiusApplication),
                                                      topRight: Radius.circular(
                                                          Dimens
                                                              .minRadiusApplication))),
                                              padding: EdgeInsets.only(
                                                  left: Dimens.paddingApplication,
                                                  right: Dimens.paddingApplication),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Lote ${lotesNext[index].numeroLote}",
                                                      style: TextStyle(
                                                        fontSize:
                                                        Dimens.textSize5,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (!isVisible) {
                                                            isVisible = true;

                                                            oldIndex = index;
                                                          } else {
                                                            if (index !=
                                                                oldIndex) {
                                                              oldIndex = index;
                                                            } else {
                                                              isVisible = false;
                                                            }
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_sharp,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )),
                                          Visibility(
                                              visible: isVisible &&
                                                  oldIndex == index,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 1),
                                                  Row(children: [
                                                    Expanded(
                                                        child: lotesNext[index]
                                                            .urlLote !=
                                                            null
                                                            ? Image.network(
                                                          WSConstantes
                                                              .URL_LEILAO +
                                                              lotesNext[
                                                              index]
                                                                  .urlLote!,
                                                          fit: BoxFit
                                                              .cover,
                                                          height: 140,
                                                        )
                                                            : Image.network(
                                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8lRbS7eKYzDq-Ftxc1p8G_TTw2unWBMEYUw&usqp=CAU",
                                                          fit: BoxFit
                                                              .cover,
                                                          height: 140,
                                                        )),
                                                    SizedBox(
                                                      width: Dimens
                                                          .marginApplication,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: Dimens
                                                                  .marginApplication),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Text("Lance",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize6,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                              SizedBox(
                                                                  height: 2),
                                                              Text(
                                                                  lotesNext[
                                                                  index]
                                                                      .maiorLance!,
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize6,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: OwnerColors
                                                                        .colorPrimaryDark,
                                                                  )),
                                                              SizedBox(
                                                                  height: Dimens
                                                                      .marginApplication),
                                                              Text(
                                                                  "Qtd de animais",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize6,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                              SizedBox(
                                                                  height: 2),
                                                              Text(
                                                                  lotesNext[
                                                                  index]
                                                                      .qtdAnimais!
                                                                      .toString(),
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize5,
                                                                    color: Colors
                                                                        .black54,
                                                                  )),
                                                            ],
                                                          )),
                                                    ),
                                                  ]),
                                                  Styles().div_horizontal,
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: Dimens
                                                              .paddingApplication,
                                                          right: Dimens
                                                              .paddingApplication,
                                                          top: Dimens
                                                              .minPaddingApplication),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                      .minPaddingApplication),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          "Número",
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Dimens.textSize6,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            Colors.black,
                                                                          )),
                                                                      Text(
                                                                        lotesNext[index]
                                                                            .qtdAnimais!
                                                                            .toString(),
                                                                        style:
                                                                        TextStyle(
                                                                          fontSize:
                                                                          Dimens.textSize5,
                                                                          color:
                                                                          Colors.black54,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ))),
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                      .minPaddingApplication),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          "Categoria",
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Dimens.textSize6,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            Colors.black,
                                                                          )),
                                                                      Text(
                                                                        lotesNext[index]
                                                                            .categoriaLote!,
                                                                        style:
                                                                        TextStyle(
                                                                          fontSize:
                                                                          Dimens.textSize5,
                                                                          color:
                                                                          Colors.black54,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )))
                                                        ],
                                                      )),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: Dimens
                                                              .paddingApplication,
                                                          right: Dimens
                                                              .paddingApplication,
                                                          top: Dimens
                                                              .minPaddingApplication,
                                                          bottom: Dimens
                                                              .minPaddingApplication),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                      .minPaddingApplication),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          "Peso",
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Dimens.textSize6,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            Colors.black,
                                                                          )),
                                                                      Text(
                                                                        lotesNext[index]
                                                                            .peso!,
                                                                        style:
                                                                        TextStyle(
                                                                          fontSize:
                                                                          Dimens.textSize5,
                                                                          color:
                                                                          Colors.black54,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ))),
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .all(Dimens
                                                                      .minPaddingApplication),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                          "Raça",
                                                                          style:
                                                                          TextStyle(
                                                                            fontSize:
                                                                            Dimens.textSize6,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color:
                                                                            Colors.black,
                                                                          )),
                                                                      Text(
                                                                        lotesNext[index]
                                                                            .racaoPelo!,
                                                                        style:
                                                                        TextStyle(
                                                                          fontSize:
                                                                          Dimens.textSize5,
                                                                          color:
                                                                          Colors.black54,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )))
                                                        ],
                                                      ))
                                                ],
                                              ))
                                        ])),
                                  );
                                },
                              ))
                        ]),
                  ),
                ) : Container(height: 0,),


              ],
            ),
          ),
        ));
  }
}
