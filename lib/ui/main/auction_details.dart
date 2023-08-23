import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  var isVisible = false;
  var oldIndex = 99999999999;

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
        // appBar: CustomAppBar(title: "Detalhes do leilão", isVisibleBackButton: false),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                child: RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                "",
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, exception, stackTrack) =>
                                        Image.asset(
                                  'images/leilao2.png',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                              Align(
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
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        } else {
                                          SystemNavigator.pop();
                                        }
                                      },
                                    )),
                              ),
                            ],
                          ),
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
                                                "Nome do leilão",
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
                                            "Cuiabá - MT",
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
                                            "00/00 ás 00:00",
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
                                  right: Dimens.marginApplication),
                              child: Styles().div_horizontal),
                          SizedBox(
                            height: Dimens.marginApplication,
                          ),
                          Card(
                            elevation: 0,
                            margin: EdgeInsets.all(Dimens.marginApplication),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                side: BorderSide(
                                    color: OwnerColors.lightGrey, width: 1.0)),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                Dimens.minRadiusApplication),
                                            topRight: Radius.circular(
                                                Dimens.minRadiusApplication)),
                                        color: OwnerColors.colorPrimary),
                                    padding: EdgeInsets.all(
                                        Dimens.paddingApplication),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Lote atual (20)",
                                            style: TextStyle(
                                              fontSize: Dimens.textSize6,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Row(children: [
                                    Expanded(
                                        child: Image.network(
                                      "",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, exception, stackTrack) =>
                                              Image.asset(
                                        'images/leilao.png',
                                        fit: BoxFit.cover,
                                        height: 140,
                                      ),
                                    )),
                                    SizedBox(
                                      width: Dimens.marginApplication,
                                    ),
                                    Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: Dimens.marginApplication),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Lance atual",
                                                  style: TextStyle(
                                                    fontSize: Dimens.textSize6,
                                                    fontWeight: FontWeight.bold,
                                                    color: OwnerColors
                                                        .colorPrimaryDark,
                                                  )),
                                              SizedBox(height: 2),
                                              Text("R\$ 700,00",
                                                  style: TextStyle(
                                                    fontSize: Dimens.textSize6,
                                                    fontWeight: FontWeight.bold,
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
                                          left: Dimens.paddingApplication,
                                          right: Dimens.paddingApplication,
                                          top: Dimens.minPaddingApplication),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                  padding: EdgeInsets.all(Dimens
                                                      .minPaddingApplication),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Número",
                                                          style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize6,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          )),
                                                      Text(
                                                        "teste",
                                                        style: TextStyle(
                                                          fontSize:
                                                              Dimens.textSize5,
                                                          color: OwnerColors
                                                              .colorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ))),
                                          Expanded(
                                              child: Container(
                                                  padding: EdgeInsets.all(Dimens
                                                      .minPaddingApplication),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Categoria",
                                                          style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize6,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          )),
                                                      Text(
                                                        "teste",
                                                        style: TextStyle(
                                                          fontSize:
                                                              Dimens.textSize5,
                                                          color: OwnerColors
                                                              .colorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  )))
                                        ],
                                      )),
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: Dimens.paddingApplication,
                                          right: Dimens.paddingApplication,
                                          top: Dimens.minPaddingApplication,
                                          bottom: Dimens.minPaddingApplication),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                  padding: EdgeInsets.all(Dimens
                                                      .minPaddingApplication),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Peso",
                                                          style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize6,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          )),
                                                      Text(
                                                        "teste",
                                                        style: TextStyle(
                                                          fontSize:
                                                              Dimens.textSize5,
                                                          color: OwnerColors
                                                              .colorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ))),
                                          Expanded(
                                              child: Container(
                                                  padding: EdgeInsets.all(Dimens
                                                      .minPaddingApplication),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Raça",
                                                          style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize6,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          )),
                                                      Text(
                                                        "teste",
                                                        style: TextStyle(
                                                          fontSize:
                                                              Dimens.textSize5,
                                                          color: OwnerColors
                                                              .colorPrimary,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  Dimens.minRadiusApplication)),
                                          color: OwnerColors.colorPrimaryDark),
                                      margin: EdgeInsets.all(
                                          Dimens.marginApplication),
                                      child: IntrinsicHeight(
                                          child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Digitar',
                                                hintStyle: TextStyle(
                                                    color: Colors.white60),
                                                filled: false,
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                contentPadding: EdgeInsets.all(
                                                    Dimens
                                                        .textFieldPaddingApplication),
                                              ),
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.textSize5,
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
                                              onPressed: () async {},
                                              icon: Image.asset(
                                                  'images/gavel.png',
                                                  width: 24,
                                                  height: 24)),
                                        ],
                                      ))),
                                  Text(
                                    "Lance atual: R\$700,00",
                                    style: TextStyle(
                                      fontSize: Dimens.textSize4,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
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
                                        fontSize: Dimens.textSize5,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  Dimens.minRadiusApplication)),
                                          color: OwnerColors.colorPrimaryDark),
                                      margin: EdgeInsets.all(
                                          Dimens.marginApplication),
                                      child: IntrinsicHeight(
                                          child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Digitar',
                                                hintStyle: TextStyle(
                                                    color: Colors.white60),
                                                filled: false,
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                contentPadding: EdgeInsets.all(
                                                    Dimens
                                                        .textFieldPaddingApplication),
                                              ),
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.textSize5,
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
                                              onPressed: () async {},
                                              icon: Image.asset(
                                                  'images/gavel.png',
                                                  width: 24,
                                                  height: 24)),
                                        ],
                                      ))),
                                  Text(
                                    "Lance atual: R\$700,00",
                                    style: TextStyle(
                                      fontSize: Dimens.textSize4,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),

                          /*FutureBuilder<List<Map<String, dynamic>>>(
                          future: listProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return */
                          Container(
                              margin: EdgeInsets.all(Dimens.marginApplication),
                              child: ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: 7,
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.minRadiusApplication),
                                            side: BorderSide(
                                                color: OwnerColors.lightGrey, width: 1.0)),
                                        margin: EdgeInsets.only(
                                            top: Dimens.minMarginApplication,
                                            bottom:
                                                Dimens.minMarginApplication),
                                        child: Column(children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: OwnerColors.colorAccent,
                                                  borderRadius: !isVisible || oldIndex != index ? BorderRadius.all(
                                                      Radius.circular(Dimens
                                                          .minRadiusApplication)) : BorderRadius.only(topLeft: Radius.circular(Dimens.minRadiusApplication),
                                                      topRight: Radius.circular(Dimens.minRadiusApplication))),
                                              padding: EdgeInsets.only(
                                                  left:
                                                      Dimens.paddingApplication,
                                                  right: Dimens
                                                      .paddingApplication),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Lote 20",
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
                                                              Text("Dados",
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
                                                              Text("teste",
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
                                                              Text("Dados",
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
                                                              Text("teste",
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
                                                                          "Dados",
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
                                                                        "teste",
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
                                                                          "Dados",
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
                                                                        "teste",
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
                                                                          "Dados",
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
                                                                        "teste",
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
                                                                          "Dados",
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
                                                                        "teste",
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
                              )) /*;
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Center(*/ /*child: CircularProgressIndicator()*/ /*);
                          }),*/
                        ])))));
  }
}
