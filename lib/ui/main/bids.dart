import 'dart:convert';

import 'package:flutter/material.dart';

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

class Bids extends StatefulWidget {
  const Bids({Key? key}) : super(key: key);

  @override
  State<Bids> createState() => _BidsState();
}

class _BidsState extends State<Bids> {
  bool _isLoading = false;
  bool _isLoadingDialog = false;

  int _pageIndex = 0;


  var isVisible = false;
  var oldIndex = 99999999999;

  late Validator validator;
  final postRequest = PostRequest();

  User? _profileResponse;

  @override
  void initState() {
    super.initState();
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

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listHighlightsRequest();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Meus Lances", isVisibleBackButton: false),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                child: RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimens.marginApplication,
                                left: Dimens.marginApplication,
                                right: Dimens.marginApplication),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Histórico",
                                    style: TextStyle(
                                      fontSize: Dimens.textSize6,
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
                                  top: Dimens.minMarginApplication,
                                  left: Dimens.marginApplication,
                                  right: Dimens.marginApplication),
                              child: Text(
                                "Acompanhe seu histórico de lances",
                                style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black54,
                                ),
                              )),
                          SizedBox(height: Dimens.marginApplication,),
                          /*FutureBuilder<List<Map<String, dynamic>>>(
                          future: listProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return */
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              // final response =
                              // Product.fromJson(snapshot.data![index]);



                              return InkWell(
                                  onTap: () => {
                                        // Navigator.pushNamed(
                                        //     context, "/ui/product_detail",
                                        //     arguments: {
                                        //       "id_product": response.id,
                                        //     })
                                      },
                                  child: Card(
                                    elevation: 0,
                                    margin: EdgeInsets.all(
                                        Dimens.minMarginApplication),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimens.minRadiusApplication),
                                        side: BorderSide(
                                            color: OwnerColors.lightGrey,
                                            width: 1.0)),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top:
                                                      Dimens.paddingApplication,
                                                  left:
                                                      Dimens.paddingApplication,
                                                  right: Dimens
                                                      .paddingApplication),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Container(
                                                  //     margin: EdgeInsets.only(
                                                  //         right: Dimens.minMarginApplication),
                                                  //     child: ClipRRect(
                                                  //         borderRadius: BorderRadius.circular(
                                                  //             Dimens.minRadiusApplication),
                                                  //         child: Image.asset(
                                                  //           'images/person.jpg',
                                                  //           height: 90,
                                                  //           width: 90,
                                                  //         ))),
                                                  SizedBox(
                                                      height: Dimens
                                                          .minMarginApplication),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Nome teste",
                                                              style: TextStyle(
                                                                fontSize: Dimens
                                                                    .textSize6,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: Dimens
                                                                    .marginApplication),
                                                            Row(children: [
                                                              Text(
                                                                "Data: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: Dimens
                                                                      .textSize4,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                "00/00/0000",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: Dimens
                                                                      .textSize4,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ]),
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                  ),

                                                  Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Cuiabá - MT",
                                                              style: TextStyle(
                                                                fontSize: Dimens
                                                                    .textSize5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ])
                                                ],
                                              )),
                                          SizedBox(
                                              height: Dimens.marginApplication),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: OwnerColors.colorPrimaryDark,
                                              borderRadius: !isVisible || oldIndex != index ? BorderRadius.only(bottomLeft: Radius.circular(Dimens.minRadiusApplication),
                                                  bottomRight: Radius.circular(Dimens.minRadiusApplication)) : null),
                                            padding: EdgeInsets.only(
                                                left: 16,
                                                top: 4,
                                                bottom: 4,
                                                right: 6),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Lote 20 | ganhou",
                                                    style: TextStyle(
                                                      fontSize:
                                                          Dimens.textSize6,
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

                                                          if (index != oldIndex) {

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
                                            ),
                                          ),
                                          Visibility(visible: isVisible && oldIndex == index, child: Column(children: [
                                            SizedBox(height: 1),
                                            Row(children: [
                                              Expanded(

                                                  child: Image.network(
                                                    "",
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        exception,
                                                        stackTrack) =>
                                                        Image.asset(
                                                          'images/leilao.png',
                                                          fit: BoxFit.cover,
                                                          height: 140,
                                                        ),
                                                  )),
                                              SizedBox(width: Dimens.marginApplication,),
                                              Expanded(
                                                child: Container (margin: EdgeInsets.only(left: Dimens.marginApplication),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [

                                                        Text("Resultado",
                                                            style:
                                                            TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize6,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w900,
                                                              color: Colors
                                                                  .black,
                                                            )),
                                                        SizedBox(height: 2),
                                                        Text(
                                                            "Ganhou",
                                                            style:
                                                            TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize6,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: OwnerColors.colorPrimaryDark,
                                                            )),

                                                        SizedBox(height: Dimens.marginApplication),
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
                                                        SizedBox(height: 2),
                                                        Text(
                                                            "R\$ 700,00",
                                                            style:
                                                            TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color: Colors
                                                                  .black54,
                                                            )),
                                                      ],
                                                    )),

                                              ),]),
                                            Styles().div_horizontal,
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left:
                                                    Dimens.paddingApplication,
                                                    right:
                                                    Dimens.paddingApplication,
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
                                                                Text("Lotes",
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
                                                                Text(
                                                                  "20",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize5,
                                                                    color: Colors
                                                                        .black54,
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
                                                                Text("Categoria",
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
                                                                Text(
                                                                  "Lorem",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize5,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            )))
                                                  ],
                                                )),
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left:
                                                    Dimens.paddingApplication,
                                                    right:
                                                    Dimens.paddingApplication,
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
                                                                Text("Peso",
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
                                                                Text(
                                                                  "10 kg",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize5,
                                                                    color: Colors
                                                                        .black54,
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
                                                                Text("Raça",
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
                                                                Text(
                                                                  "teste",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize: Dimens
                                                                        .textSize5,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            )))
                                                  ],
                                                ))
                                          ],))

                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ) /*;
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Center(*/ /*child: CircularProgressIndicator()*/ /*);
                          }),*/
                        ])))));
  }
}
