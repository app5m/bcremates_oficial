import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../config/validator.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/user.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listNotifications() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_NOTIFICATIONS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveBid(String idAllotment, String idAuction, String value, String lat, String long) async {
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

      final json =
      await postRequest.sendPostRequest(Links.SAVE_BID, body);
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

  Future<void> listBids() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_BIDS, body);

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

  Future<void> listAllotmentDetails(String idAuction, String value, String lat, String long) async {
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

  Future<void> runSimpleFilter(String name, String value, String lat, String long) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "nome": name,
        "latitude": lat,
        "longitude": long,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_SIMPLE_FILTER, body);

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

  Future<void> runAdvancedFilter(String name, String idAuction, String city, String value, String dateFrom, String dateTo, String lat, String long) async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "id_leilao": idAuction,
        "nome": name,
        "cidade": city,
        "data_de": dateFrom,
        "data_ate": dateTo,
        "latitude": lat,
        "longitude": long,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_ADVANCED_FILTER, body);

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

  Future<void> listCategories() async {
    try {
      final body = {
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_CATEGORIES, body);

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

  Future<void> searchCities(String city) async {
    try {
      final body = {
        "cidade": city,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.SEARCH_CITIES, body);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Notificações", isVisibleBackButton: true),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: listNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final responseItem = User.fromJson(snapshot.data![0]);

                if (responseItem.rows != 0) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {


                      final response = User.fromJson(snapshot.data![index]);

                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.all(
                            Dimens.minMarginApplication),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(Dimens
                              .minRadiusApplication),
                          side: BorderSide(width: 1.0, color: OwnerColors.lightGrey)
                        ),
                        child: Container(
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      right: Dimens
                                          .minMarginApplication),
                                  child: ClipRRect(

                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimens.minRadiusApplication), bottomLeft: Radius.circular(Dimens.minRadiusApplication)),
                                      child: Image.network(
                                        ApplicationConstant
                                            .URL_PRODUCT,
                                        height: 100,
                                        width: 100,
                                        errorBuilder: (context,
                                            exception,
                                            stackTrack) =>
                                            Image.asset(
                                              'images/leilao.png',
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                      ))),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      response.titulo.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow
                                          .ellipsis,
                                      style: TextStyle(
                                        fontSize: Dimens
                                            .textSize5,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(
                                        height: Dimens
                                            .minMarginApplication),
                                    Text(response
                                            .descricao.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow
                                          .ellipsis,
                                      style: TextStyle(
                                        fontSize: Dimens
                                            .textSize4,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                        height: Dimens
                                            .marginApplication),
                                    Row(children: [

                                      Icon(Icons.calendar_month_outlined, color: OwnerColors.colorPrimary, size: 16),
                                      SizedBox(width: 4,),
                                      Text(
                                        response.data,
                                        style: TextStyle(
                                          fontSize: Dimens
                                              .textSize3,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],)

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context)
                              .size
                              .height /
                              20),
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Lottie.network(
                                    height: 160,
                                    'https://assets10.lottiefiles.com/packages/lf20_KZ1htY.json')),
                            SizedBox(
                                height: Dimens
                                    .marginApplication),
                            Text(
                              Strings.empty_list,
                              style: TextStyle(
                                fontSize: Dimens.textSize5,
                                color: Colors.black,
                              ),
                            ),
                          ]));
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listFavorites();
      _isLoading = false;
    });
  }
}
