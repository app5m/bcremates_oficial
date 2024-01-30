import 'dart:convert';
import 'dart:io';

import 'package:bc_remates/model/auction.dart';
import 'package:bc_remates/model/banner.dart';
import 'package:bc_remates/model/category.dart';
import 'package:bc_remates/model/leilao.dart';
import 'package:bc_remates/model/videoAPI.dart';
import 'package:bc_remates/model/videos.dart';
import 'package:bc_remates/ui/components/alert_dialog_filter.dart';
import 'package:bc_remates/ui/main/auction_details.dart';
import 'package:bc_remates/ui/main/openfailelailao.dart';
import 'package:bc_remates/ui/main/playVideo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../configJ/constants.dart';
import '../../configJ/requests.dart';
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
  bool isLoggedIn = false;
  final requestsWebServices = RequestsWebServices(WSConstantes.URLBASE);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  void initState() {
   getFCM();
    super.initState();
  }


  Future<String?> getFCM() async {
    await Preferences.init();
    bool logg = await Preferences.getLogin();
    setState(() {
      isLoggedIn = logg;
    });

    if (isLoggedIn) {
      String? savedFcmToken = await Preferences.getInstanceTokenFcm();
      //nameUser = (await Preferences.getUserData()!.name)!;
      String? currentFcmToken = await _firebaseMessaging.getToken();
      if (savedFcmToken != null && savedFcmToken == currentFcmToken) {
        print('FCM: não salvou');
        return savedFcmToken;
      }
      var _userId = await Preferences.getUserData()!.id;
      var _type = '';
      if (Platform.isAndroid) {
        _type = WSConstantes.FCM_TYPE_ANDROID;
      } else if (Platform.isIOS) {
        _type = WSConstantes.FCM_TYPE_IOS;
      }
      final body = {
        WSConstantes.ID_USER: _userId,
        WSConstantes.TYPE: _type,
        WSConstantes.REGIST_ID: currentFcmToken,
        WSConstantes.TOKENID: WSConstantes.TOKEN
      };
      final response = await requestsWebServices.sendPostRequest(
          WSConstantes.SAVE_FCM, body);

      print('FCM: $currentFcmToken');
      print('RESPOSTA: $response');

      // Salvamos o FCM atual nas preferências.
      await Preferences.saveInstanceTokenFcm("token", currentFcmToken!);

      return currentFcmToken;
    }
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

  late Validator validator;
  final postRequest = PostRequest();

  Position? _currentPosition;

  @override
  void initState() {
    _determinePositionAndNavigate();
    _getCurrentPosition();
    listCategories();
    listBanners();

    listAoVivo();

    super.initState();
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
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

  String getYoutubeVideoId(String youtubeLink) {
    List<String> parts = youtubeLink.split("/");
    return parts.last;
  }

  final requestsWebServices = RequestsWebServices(WSConstantes.URLBASE);
  VideoAPI videoAPI = VideoAPI();
  List<Leilao> leilaoNow = [];
  List<Leilao> leilaoNext = [];
  List<Banners> banners = [];
  List<Category> categorys = [];

  Future<List<Map<String, dynamic>>> listAoVivo() async {
    try {
      final body = {"token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_AO_VIVO, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      videoAPI = VideoAPI.fromJson(_map[0]);
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

  Future<void> _determinePositionAndNavigate() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show a message and return.
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle it accordingly.
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle it accordingly.
      print('Location permissions are permanently denied.');
      return;
    }

    // When we reach here, permissions are granted.
    final position = await Geolocator.getCurrentPosition();
    await Preferences.init();
    //await Preferences.setEnteringFirstTime(true);
    // Now navigate to the desired screen.
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      await Geolocator.checkPermission();
      Position? position = await Geolocator.getLastKnownPosition();

      print(
          "lat:  ${position!.latitude.toString()}, long: ${position.longitude.toString()}");
    } catch (e) {
      print("Erro ao obter localização: $e");
    }
  }

  Future<void> listLeilao({
    required String lat,
    required String long,
    String? name,
    String? idCategoria,
    String? cidade,
    String? dataDe,
    String? dataAte,
  }) async {
    setState(() {
      leilaoNow.clear();
      leilaoNext.clear();
    });
    try {
      await Preferences.init();
      int userId = Preferences.getUserData()!.id;
      final body = {
        'id_user': userId,
        'nome': name ?? '',
        'cidade': cidade ?? '',
        'data_de': dataDe ?? '',
        'data_ate': dataAte ?? '',
        'id_categoria': idCategoria ?? '',
        'latitude': lat,
        'longitude': long,
        "token": ApplicationConstant.TOKEN
      };

      final List<dynamic> decodedResponse = await requestsWebServices
          .sendPostRequestList(WSConstantes.LIST_ALL_FILTER, body);

      if (decodedResponse.isNotEmpty) {
        if (decodedResponse[0]['rows'] != 0) {
          for (final itens in decodedResponse) {
            if (itens['status'] == 1) {
              Leilao leilao = Leilao.fromJson(itens);
              setState(() {
                leilaoNow.add(leilao);
              });
            } else {
              Leilao leilao = Leilao.fromJson(itens);
              setState(() {
                leilaoNext.add(leilao);
              });
            }
          }
        }
      } else {
        print('NULO');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> listCategories() async {
    setState(() {
      categorys.clear();
    });
    try {
      final body = {"token": ApplicationConstant.TOKEN};

      final List<dynamic> decodedResponse = await requestsWebServices
          .sendPostRequestList(Links.LIST_CATEGORIES, body);

      if (decodedResponse.isNotEmpty) {
        if (decodedResponse[0]['rows'] != 0) {
          for (final itens in decodedResponse) {
            Category barnners = Category.fromJson(itens);
            setState(() {
              categorys.add(barnners);
            });
          }
        }
      } else {
        print('NULO');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> listBanners() async {
    setState(() {
      banners.clear();
    });
    try {
      final body = {"token": ApplicationConstant.TOKEN};

      final List<dynamic> decodedResponse = await requestsWebServices
          .sendPostRequestList(WSConstantes.LIST_BANNER, body);

      if (decodedResponse.isNotEmpty) {
        if (decodedResponse[0]['rows'] != 0) {
          for (final itens in decodedResponse) {
            Banners barnners = Banners.fromJson(itens);
            setState(() {
              banners.add(barnners);
            });
          }
        }
      } else {
        print('NULO');
      }
    } catch (e) {
      print(e);
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
    await  listLeilao(
        lat: _currentPosition!.latitude.toString(),
        long: _currentPosition!.longitude.toString());

  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listHighlightsRequest();
      _isLoading = false;
    });
    for (Category c in categorys) {
      setState(() {
        c.selecionado = false;
      });
    }
    await _getCurrentPosition();

    await listLeilao(
        lat: _currentPosition!.latitude.toString(),
        long: _currentPosition!.longitude.toString());
    listAoVivo();
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

                                        await listLeilao(
                                            name: searchController.text,
                                            lat: _currentPosition!.latitude
                                                .toString(),
                                            long: _currentPosition!.longitude
                                                .toString());
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
                                                  return FilterAlertDialog(
                                                    onContainer: (String name,
                                                        String cidade,
                                                        String dateIn,
                                                        String dateOut) async {
                                                      await _getCurrentPosition();

                                                      await listLeilao(
                                                          lat: _currentPosition!
                                                              .latitude
                                                              .toString(),
                                                          long:
                                                              _currentPosition!
                                                                  .longitude
                                                                  .toString(),
                                                          name: name,
                                                          cidade: cidade,
                                                          dataDe: dateIn,
                                                          dataAte: dateOut);
                                                    },
                                                  );
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
                  Container(
                    margin: EdgeInsets.only(right: 6, left: 6),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categorys.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              for (Category c in categorys) {
                                setState(() {
                                  c.selecionado = false;
                                });
                              }

                              setState(() {
                                categorys[index].selecionado = true;
                              });
                              print(categorys[index].id);

                              listLeilao(
                                  lat: _currentPosition!.latitude.toString(),
                                  long: _currentPosition!.longitude.toString(),
                                  idCategoria: categorys[index].id.toString());
                            },
                            child: Container(
                                margin:
                                    EdgeInsets.all(Dimens.minMarginApplication),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: categorys[index].selecionado == true
                                      ? OwnerColors.gradientFirstColor
                                      : Colors.transparent,
                                  border: Border.all(
                                      width: 1, color: OwnerColors.lightGrey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(36)),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        ApplicationConstant.URL_CATEGORYS +
                                            categorys[index].url!,
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(
                                        width: Dimens.minMarginApplication,
                                      ),
                                      Text(
                                        categorys[index].nome!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: Dimens.textSize5,
                                        ),
                                      ),
                                    ])),
                          );
                        }),
                  ),
                  SizedBox(height: Dimens.marginApplication),
                  SizedBox(height: Dimens.marginApplication),
                  Container(
                    margin: EdgeInsets.only(right: 6, left: 6),
                    width: 400,
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: banners.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              _launchUrl(banners[index].url!);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 6, left: 6),
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimens.minRadiusApplication),
                                child: Image.network(
                                  ApplicationConstant.URL_BANNER +
                                      banners[index].url!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: Dimens.marginApplication),
                  SizedBox(height: Dimens.marginApplication),
                  if (videoAPI.live != null)
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
                        ],
                      ),
                    ),
                  SizedBox(height: Dimens.marginApplication),
                  if (videoAPI.live != null)
                    InkWell(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return VideoPlayerScreen(
                                  video: videoAPI,
                                );
                              });
                        },
                        child: Container(
                            margin: EdgeInsets.all(Dimens.marginApplication),
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    Dimens.minRadiusApplication)),
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
                  leilaoNow.length != 0
                      ? Container(
                          height: 275 * leilaoNow.length.toDouble(),
                          child: ListView.builder(
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: leilaoNow.length,
                            itemBuilder: (context, index) {
                              // final response =
                              // Product.fromJson(snapshot.data![index]);

                              print(leilaoNow[index].nomeLeilao);

                              return InkWell(
                                  onTap: () {
                                    if (leilaoNow[index].statusParticipante ==
                                        1) {
                                      print("ID${leilaoNow[index].id}");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuctionDetails(
                                                    leilao: leilaoNow[index],
                                                    lat: _currentPosition!
                                                        .latitude
                                                        .toString(),
                                                    long: _currentPosition!
                                                        .longitude
                                                        .toString(),
                                                  )));
                                    } else {
                                      print("ID${leilaoNow[index].id}");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OpenFaileLeilao(
                                                    status: leilaoNow[index]
                                                        .statusParticipante!,
                                                    idLeilao: leilaoNow[index]
                                                        .id
                                                        .toString(), leilao: leilaoNow[index],
                                                  )));
                                    }
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
                                          ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(Dimens
                                                      .minRadiusApplication),
                                                  topRight: Radius.circular(Dimens
                                                      .minRadiusApplication)),
                                              child: Image.network(
                                                WSConstantes.URL_LEILAO + leilaoNow[index].urlLeilao!,
                                                height: 140,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context,
                                                        exception,
                                                        stackTrack) =>
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
                                                      height: Dimens
                                                          .minMarginApplication),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  leilaoNow[
                                                                          index]
                                                                      .nomeLeilao!,
                                                                  style:
                                                                      TextStyle(
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
                                                                      fontSize:
                                                                          Dimens
                                                                              .textSize5,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    leilaoNow[
                                                                            index]
                                                                        .dataInicio!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimens
                                                                              .textSize5,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ]),
                                                                SizedBox(
                                                                    height: Dimens
                                                                        .marginApplication),
                                                                Row(children: [
                                                                  Text(
                                                                    "Lotes: ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimens
                                                                              .textSize5,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    leilaoNow[
                                                                            index]
                                                                        .quantidadeLotes
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimens
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
                                                              "${leilaoNow[index].cidadeLeilao} - ${leilaoNow[index].estadoLeilao} ",
                                                              style: TextStyle(
                                                                fontSize: Dimens
                                                                    .textSize4,
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
                        )
                      : Container(
                          height: 275,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.hourglass_empty_rounded),
                              Text(
                                "Nenhum leilão atual encontrado.",
                                style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
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
                  leilaoNext.length != 0
                      ? Container(
                          height: 275 * leilaoNext.length.toDouble(),
                          child: ListView.builder(
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: leilaoNext.length,
                            itemBuilder: (context, index) {
                              // final response =
                              // Product.fromJson(snapshot.data![index]);

                              print(leilaoNext[index].nomeLeilao);

                              return InkWell(
                                  onTap: () {
                                    if (leilaoNext[index].statusParticipante ==
                                        1) {
                                      print(leilaoNext[index].id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuctionDetails(
                                                    leilao: leilaoNext[index],
                                                    lat: _currentPosition!
                                                        .latitude
                                                        .toString(),
                                                    long: _currentPosition!
                                                        .longitude
                                                        .toString(),
                                                  )));
                                    } else {
                                      print("ID${leilaoNext[index].id}");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OpenFaileLeilao(
                                                    status: leilaoNext[index]
                                                        .statusParticipante!,
                                                    idLeilao: leilaoNext[index]
                                                        .id
                                                        .toString(), leilao: leilaoNext[index],
                                                  )));
                                    }
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
                                          ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(Dimens
                                                      .minRadiusApplication),
                                                  topRight: Radius.circular(Dimens
                                                      .minRadiusApplication)),
                                              child: Image.network(
                                                  WSConstantes.URL_LEILAO + leilaoNext[index].urlLeilao!,
                                                height: 140,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context,
                                                        exception,
                                                        stackTrack) =>
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
                                                      height: Dimens
                                                          .minMarginApplication),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  leilaoNext[
                                                                          index]
                                                                      .nomeLeilao!,
                                                                  style:
                                                                      TextStyle(
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
                                                                      fontSize:
                                                                          Dimens
                                                                              .textSize5,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    leilaoNext[
                                                                            index]
                                                                        .dataInicio!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimens
                                                                              .textSize5,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ]),
                                                                SizedBox(
                                                                    height: Dimens
                                                                        .marginApplication),
                                                                Row(children: [
                                                                  Text(
                                                                    "Lotes: ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimens
                                                                              .textSize5,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    leilaoNext[
                                                                            index]
                                                                        .quantidadeLotes
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          Dimens
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
                                                              "${leilaoNext[index].cidadeLeilao} - ${leilaoNext[index].estadoLeilao} ",
                                                              style: TextStyle(
                                                                fontSize: Dimens
                                                                    .textSize4,
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
                        )
                      : Container(
                          height: 275,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.hourglass_empty_rounded),
                              Text(
                                "Nenhum próximo leilão encontrado.",
                                style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ), /*;
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
