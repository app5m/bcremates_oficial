import 'dart:convert';
import 'dart:ffi';

import 'package:bc_remates/ui/auth/register/success.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import '../../main/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool _passwordVisible;
  late bool _isLoading = false;

  late Validator validator;
  final postRequest = PostRequest();
  User? _loginResponse;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    validator = Validator(context: context);

    _passwordVisible = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginRequest(String email, String password) async {
    try {
      final body = {
        "email": email,
        "password": password,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOGIN, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        _loginResponse = response;

        await Preferences.setUserData(_loginResponse);
        await Preferences.setLogin(true);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            ModalRoute.withName("/ui/home"));
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(isVisibleIcon: true),
        body: Stack(fit: StackFit.expand, children: [
          Expanded(
            child: Image.asset(
              'images/bg_main.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
              child: SafeArea(
                  child: Container(
            margin: EdgeInsets.all(Dimens.marginApplication),
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize8,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.minMarginApplication),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Insira seus dados para login." /*? "Insira seus dados pessoais." : "Cadastre seu e-mail e senha."*/,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize5,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          bottom: Dimens.minMarginApplication),
                      child: Text(
                        "E-mail",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
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
                          fontFamily: 'Inter',
                          fontSize: Dimens.textSize5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    TextField(
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
                              color: OwnerColors.colorPrimary, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Dimens.radiusApplication),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.all(Dimens.textFieldPaddingApplication),
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
                    SizedBox(height: Dimens.minMarginApplication),
                    Container(
                        width: double.infinity,
                        child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: Dimens.textSize5,
                              fontFamily: 'Inter',
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Esqueceu sua senha? '),
                              TextSpan(
                                  text: 'Entre aqui',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: Dimens.textSize5,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, "/ui/recover_password");
                                    }),
                            ],
                          ),
                        )),
                    SizedBox(height: 48),
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () async {

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              ModalRoute.withName("/ui/home"));

                          if (!validator.validateEmail(emailController.text))
                            return;

                          setState(() {
                            _isLoading = true;
                          });
                          // if (!validator.validatePassword(passwordController.text)) return;
                          await Preferences.init();
                          await loginRequest(
                              emailController.text, passwordController.text);

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: (_isLoading)
                            ? const SizedBox(
                                width: Dimens.buttonIndicatorWidth,
                                height: Dimens.buttonIndicatorHeight,
                                child: CircularProgressIndicator(
                                  color: OwnerColors.colorAccent,
                                  strokeWidth: Dimens.buttonIndicatorStrokes,
                                ))
                            : Text("Entrar",
                                style: Styles().styleDefaultTextButton),
                      ),
                    ),
                    Spacer(),
                    SizedBox(height: Dimens.marginApplication),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Dimens.textSize5,
                          fontFamily: 'Inter',
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Ainda não possui uma conta? '),
                          TextSpan(
                              text: 'Entre aqui',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: Dimens.textSize5,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, "/ui/register");
                                }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
          )))
        ]));
  }
}
