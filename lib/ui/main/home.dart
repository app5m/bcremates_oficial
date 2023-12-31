import 'dart:convert';
import 'dart:io';

import 'package:bc_remates/model/auction.dart';
import 'package:bc_remates/ui/components/alert_dialog_filter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

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
import '../components/alert_dialog_generic.dart';
import '../components/alert_dialog_get_out.dart';
import '../components/custom_app_bar.dart';
import '../components/dot_indicator.dart';
import 'bids.dart';
import 'main_menu.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    var widgetItems = <Widget>[];

    widgetItems.add(ContainerHome());
    widgetItems.add(Bids());
    widgetItems.add(MainMenu());

    List<Widget> _widgetOptions = widgetItems;

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar:
          BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}

class ContainerHome extends StatefulWidget {
  const ContainerHome({Key? key}) : super(key: key);

  @override
  State<ContainerHome> createState() => _ContainerHomeState();
}

GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomNavBar({this.currentIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBarItems = <BottomNavigationBarItem>[];

    bottomNavigationBarItems.add(BottomNavigationBarItem(
      icon: Image.asset(
        'images/house.png',
        height: 24,
        width: 24,
      ),
      activeIcon: Image.asset(
        'images/house.png',
        height: 24,
        width: 24,
        color: OwnerColors.colorPrimaryDark,
      ),
      label: Strings.home,
    ));
    bottomNavigationBarItems.add(BottomNavigationBarItem(
      icon: Image.asset(
        'images/receipt_item.png',
        height: 24,
        width: 24,
      ),
      activeIcon: Image.asset(
        'images/receipt_item.png',
        height: 24,
        width: 24,
        color: OwnerColors.colorPrimaryDark,
      ),
      label: Strings.orders,
    ));
    bottomNavigationBarItems.add(BottomNavigationBarItem(
      icon: Image.asset(
        'images/profile_circle.png',
        height: 24,
        width: 24,
      ),
      activeIcon: Image.asset(
        'images/profile_circle.png',
        height: 24,
        width: 24,
        color: OwnerColors.colorPrimaryDark,
      ),
      label: Strings.menu,
    ));
    return BottomNavigationBar(
        key: globalKey,
        elevation: Dimens.elevationApplication,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: OwnerColors.colorPrimaryDark,
        unselectedItemColor: OwnerColors.colorAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: bottomNavigationBarItems);
  }
}

class _ContainerHomeState extends State<ContainerHome> {
  bool _isLoading = false;
  bool _isLoadingDialog = false;

  int _pageIndex = 0;

  late Validator validator;
  final postRequest = PostRequest();

  Position? _currentPosition;

  @override
  void initState() {
    validator = Validator(context: context);
    saveFcm();

    super.initState();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    categoryController.dispose();
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> saveFcm() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    try {
      await Preferences.init();
      String? savedFcmToken = await Preferences.getInstanceTokenFcm();
      String? currentFcmToken = await _firebaseMessaging.getToken();
      if (savedFcmToken != null && savedFcmToken == currentFcmToken) {
        print('FCM: não salvou');
        return;
      }

      var _type = "";

      if (Platform.isAndroid) {
        _type = ApplicationConstant.FCM_TYPE_ANDROID;
      } else if (Platform.isIOS) {
        _type = ApplicationConstant.FCM_TYPE_IOS;
      } else {
        return;
      }

      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "type": _type,
        "registration_id": currentFcmToken,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_FCM, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        await Preferences.saveInstanceTokenFcm("token", currentFcmToken!);
        setState(() {});
      } else {}
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listBanners() async {
    try {
      final body = {"token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_BANNERS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listCategories() async {
    try {
      final body = {"token": ApplicationConstant.TOKEN};

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

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> runSimpleFilter(String name, String lat, String long) async {
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

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      ApplicationMessages(context: context).showMessage(Strings.disable_gps_description);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ApplicationMessages(context: context).showMessage(Strings.disable_gps_forever);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ApplicationMessages(context: context).showMessage(Strings.disable_gps_forever);
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
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
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Início",
        ),
        body: Container(
            height: double.infinity,
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: SingleChildScrollView(
                    child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: OwnerColors.lightGrey),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    Dimens.minRadiusApplication)),
                              ),
                              margin: EdgeInsets.all(Dimens.marginApplication),
                              child: IntrinsicHeight(
                                  child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {

                                        await _getCurrentPosition();

                                        await runSimpleFilter(searchController.text,
                                            _currentPosition!.latitude.toString(),
                                            _currentPosition!.longitude.toString());
                                        
                                      },
                                      icon: Image.asset('images/search.png',
                                          width: 20, height: 20)),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Pesquisar...',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        filled: false,
                                        border: InputBorder.none,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.all(
                                            Dimens.textFieldPaddingApplication),
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: Dimens.textSize5,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: Colors.black12,
                                    width: 2,
                                    thickness: 1.5,
                                    indent: 6,
                                    endIndent: 6,
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        final result =
                                            await showModalBottomSheet<dynamic>(
                                                isScrollControlled: true,
                                                context: context,
                                                shape: Styles()
                                                    .styleShapeBottomSheet,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                builder:
                                                    (BuildContext context) {
                                                  return FilterAlertDialog();
                                                });
                                        // if (result == true) {
                                        //   Navigator.popUntil(
                                        //     context,
                                        //     ModalRoute.withName('/ui/home'),
                                        //   );
                                        //   Navigator.pushNamed(
                                        //       context, "/ui/user_addresses");
                                        // }
                                      },
                                      icon: Image.asset('images/filter.png',
                                          width: 20, height: 20)),
                                ],
                              )))),
                      Expanded(
                          flex: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: OwnerColors.lightGrey),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.minRadiusApplication)),
                            ),
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.only(
                                right: Dimens.marginApplication),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/ui/notifications");
                                },
                                icon: Image.asset('images/notification.png',
                                    width: 20, height: 20)),
                          ))
                    ],
                  ),
                  SizedBox(height: Dimens.marginApplication),
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimens.marginApplication,
                        right: Dimens.marginApplication),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Categorias",
                            style: TextStyle(
                              fontSize: Dimens.textSize5,
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
                  SizedBox(
                    height: Dimens.marginApplication,
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: listCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var gridItems = <Widget>[];

                          for (var i = 0; i < 3; i++) {
                            final response = Auction.fromJson(snapshot.data![i]);

                            gridItems.add(InkWell(
                                onTap: () => {
                                      // Navigator.pushNamed(
                                      //     context, "/ui/subcategories",
                                      //     arguments: {
                                      //       "id_category": response.id,
                                      //     })
                                    },
                                child: Container(
                                    margin: EdgeInsets.all(
                                        Dimens.minMarginApplication),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: OwnerColors.lightGrey),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(36)),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            response.url,
                                            width: 24,
                                            height: 24,
                                            color: OwnerColors.colorPrimary,
                                          ),
                                          SizedBox(
                                            width: Dimens.minMarginApplication,
                                          ),
                                          Text(
                                            response.nome,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: Dimens.textSize5,
                                            ),
                                          ),
                                        ]))));
                          }

                          return Container(
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: GridView.count(
                              childAspectRatio: 2.0,
                              primary: false,
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              children: gridItems,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return Center(
                            /*child: CircularProgressIndicator()*/
                            );
                      }),
                  SizedBox(height: Dimens.marginApplication),
                  SizedBox(height: Dimens.marginApplication),
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: listCategories(),
                      builder: (context, snapshot) {
                        var bannerList = <Widget>[];

                        for (var i = 0; i < snapshot.data!.length; i++) {
                          final response = User.fromJson(snapshot.data![i]);

                          bannerList.add(Scaffold(
                            body: Container(
                              padding: EdgeInsets.all(23),
                              margin: EdgeInsets.only(right: 6, left: 6),
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        OwnerColors.gradientFirstColor,
                                        OwnerColors.gradientSecondaryColor,
                                        OwnerColors.gradientThirdColor
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius: BorderRadius.circular(
                                      Dimens.minRadiusApplication)),
                              /*width: MediaQuery.of(context).size.width * 0.90,*/
                              child: Image.network(
                                ApplicationConstant.URL_BANNER + response.url,
                              ),
                            ),
                          ));
                        }

                        return CarouselSlider(
                          items: bannerList,
                          options: CarouselOptions(
                            height: 100,
                            autoPlay: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _pageIndex = index;
                              });
                            },
                          ),
                        );
                      }),
                  SizedBox(height: Dimens.marginApplication),
                  SizedBox(height: Dimens.marginApplication),
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimens.marginApplication,
                        right: Dimens.marginApplication),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Assista agora!",
                            style: TextStyle(
                              fontSize: Dimens.textSize5,
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
                  /*FutureBuilder<List<Map<String, dynamic>>>(
                          future: listProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return */
                  /*ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: 1,
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
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                side: BorderSide(
                                    color: OwnerColors.lightGrey, width: 1.0)),
                            child: Container(
                              child: Column(
                                children: [
                              ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimens.minRadiusApplication), topRight: Radius.circular(Dimens.minRadiusApplication)),
                            child: Image.network(
                                    "",
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, exception, stackTrack) =>
                                            Image.asset(
                                      'images/leilao.png',
                                      width: double.infinity,
                                              fit: BoxFit.cover,
                                      height: 140,
                                    ),
                                  )),
                                  Container(
                                      padding: EdgeInsets.all(
                                          Dimens.paddingApplication),
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
                                              height:
                                                  Dimens.minMarginApplication),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
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
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Dimens
                                                                .marginApplication),
                                                        Row(children: [
                                                          Text(
                                                            "Data: ",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "00/00/0000",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ]),
                                                        SizedBox(
                                                            height: Dimens
                                                                .marginApplication),
                                                        Row(children: [
                                                          Text(
                                                            "Lotes: ",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "3",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ]),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),

                                          Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Cuiabá - MT",
                                                      style: TextStyle(
                                                        fontSize:
                                                            Dimens.textSize5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Dimens
                                                        .marginApplication),
                                                Icon(
                                                  Icons.access_time,
                                                  color: OwnerColors.darkGrey,
                                                )
                                              ])
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ));
                    },
                  )*/ /*;
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Center(*/ /*child: CircularProgressIndicator()*/ /*);
                          }),*/
                  SizedBox(height: Dimens.marginApplication),
                  InkWell(
                      onTap: () async {
                        final result = await showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            context: context,
                            shape: Styles().styleShapeBottomSheet,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (BuildContext context) {
                              return GetOutAlertDialog();
                            });
                        if (result == true) {
                          Navigator.pushNamed(
                            context,
                            "/ui/wait",
                            /*   arguments: {
                                      "id_product": response.id,
                                    }*/
                          );
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.all(Dimens.marginApplication),
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.minRadiusApplication)),
                              child: Image.network(
                                "",
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, exception, stackTrack) =>
                                        Image.asset(
                                  'images/leilo.png',
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              )))),
                  SizedBox(height: Dimens.marginApplication),
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimens.marginApplication,
                        right: Dimens.marginApplication),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Leilão atual",
                            style: TextStyle(
                              fontSize: Dimens.textSize5,
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
                  /*FutureBuilder<List<Map<String, dynamic>>>(
                          future: listProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return */
                  SizedBox(height: Dimens.marginApplication),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      // final response =
                      // Product.fromJson(snapshot.data![index]);

                      return InkWell(
                          onTap: () => {
                                Navigator.pushNamed(
                                  context,
                                  "/ui/auction_details",
                                  /*   arguments: {
                                      "id_product": response.id,
                                    }*/
                                )
                              },
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                side: BorderSide(
                                    color: OwnerColors.lightGrey, width: 1.0)),
                            child: Container(
                              child: Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              Dimens.minRadiusApplication),
                                          topRight: Radius.circular(
                                              Dimens.minRadiusApplication)),
                                      child: Image.network(
                                        "",
                                        height: 140,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, exception, stackTrack) =>
                                                Image.asset(
                                          'images/leilao2.png',
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          height: 140,
                                        ),
                                      )),
                                  Container(
                                      padding: EdgeInsets.all(
                                          Dimens.paddingApplication),
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
                                              height:
                                                  Dimens.minMarginApplication),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
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
                                                                FontWeight.w900,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Dimens
                                                                .marginApplication),
                                                        Row(children: [
                                                          Text(
                                                            "Data: ",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "00/00/0000",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ]),
                                                        SizedBox(
                                                            height: Dimens
                                                                .marginApplication),
                                                        Row(children: [
                                                          Text(
                                                            "Lotes: ",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "3",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ]),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),

                                          Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Cuiabá - MT",
                                                      style: TextStyle(
                                                        fontSize:
                                                            Dimens.textSize4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 32),
                                                Image.asset(
                                                  'images/arrow_square_right.png',
                                                  width: 28,
                                                  height: 28,
                                                )
                                              ])
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                  /*;
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Center(*/ /*child: CircularProgressIndicator()*/ /*);
                          }),*/

                  /*FutureBuilder<List<Map<String, dynamic>>>(
                          future: listProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return */
                  SizedBox(height: Dimens.marginApplication),
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimens.marginApplication,
                        right: Dimens.marginApplication),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Próximos leilões",
                            style: TextStyle(
                              fontSize: Dimens.textSize5,
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
                  SizedBox(height: Dimens.marginApplication),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      // final response =
                      // Product.fromJson(snapshot.data![index]);

                      var source = 'images/terra.png';

                      if (index == 0) {
                        source = 'images/terra.png';
                      } else if (index == 1) {
                        source = 'images/gado.png';
                      } else {
                        source = 'images/leilao2.png';
                      }

                      return InkWell(
                          onTap: () => {
                                Navigator.pushNamed(
                                  context,
                                  "/ui/auction_details",
                                  /*   arguments: {
                                      "id_product": response.id,
                                    }*/
                                )
                              },
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.all(Dimens.minMarginApplication),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                side: BorderSide(
                                    color: OwnerColors.lightGrey, width: 1.0)),
                            child: Container(
                              child: Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              Dimens.minRadiusApplication),
                                          topRight: Radius.circular(
                                              Dimens.minRadiusApplication)),
                                      child: Image.network(
                                        "",
                                        height: 140,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, exception, stackTrack) =>
                                                Image.asset(
                                          source,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          height: 140,
                                        ),
                                      )),
                                  Container(
                                      padding: EdgeInsets.all(
                                          Dimens.paddingApplication),
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
                                              height:
                                                  Dimens.minMarginApplication),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
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
                                                                FontWeight.w900,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Dimens
                                                                .marginApplication),
                                                        Row(children: [
                                                          Text(
                                                            "Data: ",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "00/00/0000",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ]),
                                                        SizedBox(
                                                            height: Dimens
                                                                .marginApplication),
                                                        Row(children: [
                                                          Text(
                                                            "Lotes: ",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "3",
                                                            style: TextStyle(
                                                              fontSize: Dimens
                                                                  .textSize5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ]),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),

                                          Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Cuiabá - MT",
                                                      style: TextStyle(
                                                        fontSize:
                                                            Dimens.textSize4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 32),
                                                Icon(
                                                  Icons.access_time,
                                                  color: OwnerColors.darkGrey,
                                                )
                                              ])
                                        ],
                                      )),
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

class CarouselItemBuilder extends StatelessWidget {
  final String image;

  const CarouselItemBuilder({Key? key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(23),
        margin: EdgeInsets.only(right: 6, left: 6),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              OwnerColors.gradientFirstColor,
              OwnerColors.gradientSecondaryColor,
              OwnerColors.gradientThirdColor
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(Dimens.minRadiusApplication)),
        /*width: MediaQuery.of(context).size.width * 0.90,*/
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}
