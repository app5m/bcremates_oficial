import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:bc_remates/configJ/requests.dart';
import 'package:bc_remates/res/strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/application_messages.dart';
import '../../../config/masks.dart';
import '../../../config/preferences.dart';
import '../../../config/validator.dart';
import '../../../configJ/constants.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/alert_dialog_sucess.dart';
import '../../components/custom_app_bar.dart';
import '../../components/dot_indicator.dart';
import '../../main/home.dart';
import 'package:geolocator/geolocator.dart';

class RegisterOwnerData extends StatefulWidget {
  const RegisterOwnerData({Key? key}) : super(key: key);

  @override
  State<RegisterOwnerData> createState() => _RegisterOwnerDataState();
}

class _RegisterOwnerDataState extends State<RegisterOwnerData> {
  late PageController _pageController;
  int _pageIndex = 0;

  String? _currentAddress;
  Position? _currentPosition;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController coPasswordController = TextEditingController();
  final TextEditingController socialReasonController = TextEditingController();

// final TextEditingController iEController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  late bool _passwordVisible;
  late bool _passwordVisible2;

  bool hasPasswordCoPassword = false;
  bool hasUppercase = false;
  bool hasMinLength = false;
  bool visibileOne = false;
  bool visibileTwo = false;

  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _passwordVisible = false;
    _passwordVisible2 = false;

    _handleLocationPermission();
  }
  final requestsWebServices = RequestsWebServices(WSConstantes.URLBASE);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getFCM(String idUser) async {
    await Preferences.init();
    bool logg = await Preferences.getLogin();
    bool isLoggedIn = true;

    if (isLoggedIn) {
      String? savedFcmToken = await Preferences.getInstanceTokenFcm();
      //nameUser = (await Preferences.getUserData()!.name)!;
      String? currentFcmToken = await _firebaseMessaging.getToken();
      if (savedFcmToken != null && savedFcmToken == currentFcmToken) {
        print('FCM: não salvou');
        return savedFcmToken;
      }

      var _type = '';
      if (Platform.isAndroid) {
        _type = WSConstantes.FCM_TYPE_ANDROID;
      } else if (Platform.isIOS) {
        _type = WSConstantes.FCM_TYPE_IOS;
      }
      final body = {
        WSConstantes.ID_USER: idUser,
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    coPasswordController.dispose();
    socialReasonController.dispose();
    // iEController.dispose();
    cnpjController.dispose();
    cpfController.dispose();
    cellphoneController.dispose();
    nameController.dispose();

    _pageController.dispose();
    super.dispose();
  }

  late Validator validator;
  final postRequest = PostRequest();
  User? _registerResponse;

  Future<void> registerRequest(
      String name,
      String email,
      String cellphone,
      String document,
      String password,
      String latitude,
      String longitude) async {
    try {
      final body = {
        "nome": name,
        "email": email,
        "celular": cellphone,
        "documento": document,
        "password": password,
        "latitude": latitude,
        "longitude": longitude,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.REGISTER, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);


      if (response.status == "01") {

        getFCM(response.id.toString());

        Navigator.pushNamed(context, "/ui/sucess");
      } else {
        ApplicationMessages(context: context).showMessage(response.msg);
      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toJson();
    await prefs.setString('user', jsonEncode(userData));
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

  @override
  Widget build(BuildContext context) {
    validator = Validator(context: context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: CustomAppBar(isVisibleIcon: true, isVisibleBackButton: true),
      body: Stack(fit: StackFit.expand, children: [
        /*Expanded(
          child: */Image.asset(
            'images/bg_main.png',
            fit: BoxFit.fitWidth,
          ),
        // ),
    Container(
    child: SafeArea( child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(Dimens.marginApplication),
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Cadastro",
                        style: TextStyle(
                          fontSize: Dimens.textSize8,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.minMarginApplication),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Insira seus dados pessoais" /*? "Insira seus dados pessoais." : "Cadastre seu e-mail e senha."*/,
                        style: TextStyle(
                          fontSize: Dimens.textSize5,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                  ])),
              Expanded(
                  child: PageView.builder(
                itemCount: 2,
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                        margin: EdgeInsets.all(Dimens.marginApplication),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  bottom: Dimens.minMarginApplication),
                              child: Text(
                                "Nome completo",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: OwnerColors.colorPrimary,
                                      width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Ex: José Pereira',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimens.radiusApplication),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
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
                            SizedBox(height: Dimens.marginApplication),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  bottom: Dimens.minMarginApplication),
                              child: Text(
                                "CPF",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            TextField(
                              controller: cpfController,
                              inputFormatters: [Masks().cpfMask()],
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: OwnerColors.colorPrimary,
                                      width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: '000.000.000-00',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimens.radiusApplication),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(
                                    Dimens.textFieldPaddingApplication),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Dimens.textSize5,
                              ),
                            ),
                            SizedBox(height: Dimens.marginApplication),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  bottom: Dimens.minMarginApplication),
                              child: Text(
                                "Celular",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            TextField(
                              controller: cellphoneController,
                              inputFormatters: [Masks().cellphoneMask()],
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: OwnerColors.colorPrimary,
                                      width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: '(##) #####-####',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimens.radiusApplication),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(
                                    Dimens.textFieldPaddingApplication),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Dimens.textSize5,
                              ),
                            ),
                          ],
                        ));
                  } else {
                    return Container(
                        margin: EdgeInsets.all(Dimens.marginApplication),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
                                child: Text(
                                  "E-mail",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: OwnerColors.colorPrimary,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: 'exemplo@email.com',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
                                child: Text(
                                  "Senha",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    hasPasswordCoPassword = false;
                                    visibileOne = true;
                                    hasMinLength =
                                        passwordController.text.length >= 8;
                                    hasUppercase = passwordController.text
                                        .contains(RegExp(r'[A-Z]'));

                                    hasPasswordCoPassword =
                                        coPasswordController.text ==
                                            passwordController.text;

                                    if (hasMinLength && hasUppercase) {
                                      visibileOne = false;
                                    }
                                  });
                                },
                                controller: passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: OwnerColors.colorPrimary,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      }),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: OwnerColors.colorPrimary,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: '',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !_passwordVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Visibility(
                                visible: passwordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasMinLength
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasMinLength
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'Deve ter no mínimo 8 carácteres',
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: passwordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasUppercase
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasUppercase
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'Deve ter uma letra maiúscula',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
                                child: Text(
                                  "Confirmar Senha",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    visibileTwo = true;
                                    hasPasswordCoPassword =
                                        coPasswordController.text ==
                                            passwordController.text;

                                    if (hasPasswordCoPassword) {
                                      visibileTwo = false;
                                    }
                                  });
                                },
                                controller: coPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: OwnerColors.colorPrimary,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible2 = !_passwordVisible2;
                                        });
                                      }),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: OwnerColors.colorPrimary,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: '',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !_passwordVisible2,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Visibility(
                                visible: coPasswordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasPasswordCoPassword
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasPasswordCoPassword
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'As senhas fornecidas são idênticas',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dimens.marginApplication,
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: Dimens.textSize5,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            'Ao clicar no botão Criar conta, você aceita os'),
                                    TextSpan(
                                        text: ' Termos de uso',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: Dimens.textSize5,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                                context, "/ui/pdf_viewer");
                                          }),
                                    TextSpan(text: ' do aplicativo.'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  }
                },
              )),
              Padding(
                padding: EdgeInsets.only(bottom: Dimens.paddingApplication),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      2,
                      (index) => DotIndicator(
                        isActive: index == _pageIndex,
                        color: OwnerColors.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimens.marginApplication),
              Container(
                  margin: EdgeInsets.all(Dimens.marginApplication),
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () async {

                          if(_pageIndex == 0){
                            _getCurrentPosition();
                            if (!validator.validateGenericTextField(
                                nameController.text, "Nome")) return;

                            if (!validator.validateCPF(cpfController.text))
                              return;

                            if (!validator.validateCellphone(
                                cellphoneController.text)) return;
                            _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.linear);
                          }else{
                            if (!validator.validateEmail(emailController.text))
                              return;
                            if (!validator.validatePassword(
                                passwordController.text)) return;
                            if (!validator.validateCoPassword(
                                passwordController.text,
                                coPasswordController.text)) return;

                            setState(() {
                              _isLoading = true;
                            });

                            await registerRequest(
                                nameController.text,
                                emailController.text,
                                cellphoneController.text,
                                cpfController.text,
                                passwordController.text,
                                _currentPosition!.latitude.toString(),
                                _currentPosition!.longitude.toString());

                            setState(() {
                              _isLoading = false;
                            });
                          }





                        },
                        child: (_isLoading)
                            ? const SizedBox(
                                width: Dimens.buttonIndicatorWidth,
                                height: Dimens.buttonIndicatorHeight,
                                child: CircularProgressIndicator(
                                  color: OwnerColors.colorAccent,
                                  strokeWidth: Dimens.buttonIndicatorStrokes,
                                ))
                            : Text( _pageIndex == 0 ? "Próximo" :"Criar conta",
                                style: Styles().styleDefaultTextButton),
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Dimens.textSize5,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Já possui uma conta? '),
                          TextSpan(
                              text: 'Faça login',
                              style: TextStyle(
                                color: OwnerColors.colorPrimary,
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                }),
                        ],
                      ),
                    )
                  ]))
            ],
          ),
        )),
      ]),
    );
  }
}
