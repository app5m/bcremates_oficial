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

class AuctionDetails extends StatefulWidget {
  const AuctionDetails({Key? key}) : super(key: key);

  @override
  State<AuctionDetails> createState() => _AuctionDetailsState();
}

class _AuctionDetailsState extends State<AuctionDetails> {
  bool _isLoading = false;
  bool _isLoadingDialog = false;

  int _pageIndex = 0;

  late Validator validator;
  final postRequest = PostRequest();

  User? _profileResponse;

  @override
  void initState() {
    super.initState();
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
        appBar: CustomAppBar(title: "Detalhes do leilão", isVisibleBackButton: false),
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
                                      fontFamily: 'Inter',
                                      fontSize: Dimens.textSize6,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                // Text(
                                //   "Ver mais",
                                //   style: TextStyle(
                                //     fontFamily: 'Inter',
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
                                  fontFamily: 'Inter',
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black54,
                                ),
                              )),
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
                                                                fontFamily:
                                                                    'Inter',
                                                                fontSize: Dimens
                                                                    .textSize6,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize: Dimens
                                                                      .textSize5,
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
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize: Dimens
                                                                      .textSize5,
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
                                                                fontFamily:
                                                                    'Inter',
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
                                            color: OwnerColors.colorPrimaryDark,
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
                                                      fontFamily: 'Inter',
                                                      fontSize:
                                                          Dimens.textSize6,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      color: Colors.white,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          Container(
                                            height: 140,
                                            child: Row(children: [
                                              Expanded(
                                                  child: Image.network(
                                                "",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context,
                                                        exception,
                                                        stackTrack) =>
                                                    Image.asset(
                                                  'images/main_logo_1.png',
                                                ),
                                              )),
                                              SizedBox(width: Dimens.marginApplication,),
                                              Expanded(
                                                  child: Container (margin: EdgeInsets.only(left: Dimens.marginApplication),
                                                      child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                                                children: [

                                                      Text("Dados",
                                                      style:
                                                      TextStyle(
                                                        fontFamily:
                                                        'Inter',
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
                                                    "teste",
                                                    style:
                                                    TextStyle(
                                                      fontFamily:
                                                      'Inter',
                                                      fontSize: Dimens
                                                          .textSize6,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: OwnerColors.colorPrimaryDark,
                                                    )),

                                                  SizedBox(height: Dimens.marginApplication),
                                                      Text("Dados",
                                                          style:
                                                          TextStyle(
                                                            fontFamily:
                                                            'Inter',
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
                                                        "teste",
                                                        style:
                                                        TextStyle(
                                                          fontFamily:
                                                          'Inter',
                                                          fontSize: Dimens
                                                              .textSize5,
                                                          color: Colors
                                                              .black54,
                                                        )),
                                                ],
                                              )),

                                          ),])),
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
                                                              Text("Dados",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Inter',
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
                                                                  fontFamily:
                                                                      'Inter',
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
                                                              Text("Dados",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Inter',
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
                                                                  fontFamily:
                                                                      'Inter',
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
                                                              Text("Dados",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Inter',
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
                                                                  fontFamily:
                                                                      'Inter',
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
                                                              Text("Dados",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Inter',
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
                                                                  fontFamily:
                                                                      'Inter',
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
