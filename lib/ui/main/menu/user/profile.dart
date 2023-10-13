import 'dart:convert';
import 'dart:io';

import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../config/application_messages.dart';
import '../../../../../../config/masks.dart';
import '../../../../../../config/preferences.dart';
import '../../../../../../config/validator.dart';
import '../../../../../../global/application_constant.dart';
import '../../../../../../model/user.dart';
import '../../../../../../res/dimens.dart';
import '../../../../../../res/owner_colors.dart';
import '../../../../../../web_service/links.dart';
import '../../../../../../web_service/service_response.dart';
import '../../../../res/styles.dart';
import '../../../components/alert_dialog_pick_files.dart';
import '../../../components/alert_dialog_pick_images.dart';
import '../../../components/custom_app_bar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late bool _passwordVisible;
  late bool _passwordVisible2;

  bool hasPasswordCoPassword = false;
  bool hasUppercase = false;
  bool hasMinLength = false;
  bool visibileOne = false;
  bool visibileTwo = false;

  bool _isLoading = false;
  late Validator validator;
  User? _profileResponse;

  late TabController _tabController;
  final postRequest = PostRequest();

  @override
  void initState() {
    // loadProfileRequest();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    _passwordVisible = false;
    _passwordVisible2 = false;

    validator = Validator(context: context);
    super.initState();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController coPasswordController = TextEditingController();
  final TextEditingController socialReasonController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController nbhController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    coPasswordController.dispose();
    socialReasonController.dispose();
    documentController.dispose();
    cellphoneController.dispose();

    nameController.dispose();
    cepController.dispose();
    cityController.dispose();
    stateController.dispose();
    nbhController.dispose();
    addressController.dispose();
    numberController.dispose();
    complementController.dispose();

    _tabController.dispose();
    super.dispose();
  }

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);

      sendPhoto(imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);

      sendPhoto(imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> sendPhoto(File image) async {
    try {
      final json = await postRequest.sendPostRequestMultiPart(
          Links.UPDATE_AVATAR,
          image,
          await Preferences.getUserData()!.id.toString());

      List<Map<String, dynamic>> _map = [];
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> loadProfileRequest() async {
    try {
      final body = {
        "id_user": /*await Preferences.getUserData()!.id */ "1015",
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PROFILE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);

      _profileResponse = response;

      nameController.text = _profileResponse!.nome.toString();
      emailController.text = _profileResponse!.email.toString();
      documentController.text = _profileResponse!.documento.toString();
      cellphoneController.text = _profileResponse!.celular.toString();

      cepController.text = _profileResponse!.cep.toString();
      stateController.text = _profileResponse!.estado.toString();
      cityController.text = _profileResponse!.cidade.toString();
      addressController.text = _profileResponse!.endereco.toString();
      nbhController.text = _profileResponse!.bairro.toString();
      numberController.text = _profileResponse!.numero.toString();
      complementController.text = _profileResponse!.complemento.toString();

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> updateUserDataRequest(
      String name,
      String document,
      String cellphone,
      String email,
      String birth,) async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "nome": name,
        "documento": document,
        "celular": cellphone,
        "data_nascimento": birth,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.UPDATE_USER_DATA, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {});
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> updatePasswordRequest(String password) async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "password": password,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.UPDATE_PASSWORD, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {
          _profileResponse = response;

          passwordController.text = "";
          coPasswordController.text = "";
        });

        // loadProfileRequest();
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> getCepInfo(String cep) async {
    try {
      final json = await postRequest.getCepRequest("$cep/json/");

      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = User.fromJson(parsedResponse);

      // setState(() {
      // cityController.text = response.localidade;
      // stateController.text = response.uf;
      // nbhController.text = response.bairro;
      // addressController.text = response.logradouro;
      // });
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:
            CustomAppBar(title: "Edição de Perfil", isVisibleBackButton: true),
        body: Container(
            child: Container(
                child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
                child: FutureBuilder<Map<String, dynamic>>(
              future: loadProfileRequest(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final response = User.fromJson(snapshot.data!);

                  return Container(
                    child: Column(
                      children: [
                        // Expanded(

                        Material(
                            elevation: Dimens.elevationApplication,
                            child: Container(
                              padding:
                                  EdgeInsets.all(Dimens.maxPaddingApplication),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                      height: 84,
                                      width: 84,
                                      margin: EdgeInsets.only(
                                          right: Dimens.marginApplication),
                                      child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipOval(
                                              child: SizedBox.fromSize(
                                                size: Size.fromRadius(42),
                                                // Image radius
                                                child: Image.network(
                                                    ApplicationConstant
                                                            .URL_AVATAR +
                                                        response.avatar
                                                            .toString(),
                                                    fit: BoxFit.cover,
                                                    /*fit: BoxFit.cover*/
                                                    errorBuilder: (context,
                                                            exception,
                                                            stackTrack) =>
                                                        Image.asset(
                                                          'images/person.jpg',
                                                        )),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: FloatingActionButton(
                                                mini: true,
                                                child: Image.asset(
                                                  'images/edit.png',
                                                  width: 18,
                                                  height: 18,
                                                ),
                                                backgroundColor: Colors.white,
                                                onPressed: () {
                                                  showModalBottomSheet<dynamic>(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      shape: Styles()
                                                          .styleShapeBottomSheet,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      builder: (BuildContext
                                                          context) {
                                                        return PickImageAlertDialog(
                                                            iconCamera:
                                                                Container(
                                                                    child: Image
                                                                        .asset(
                                                              "images/2.png",
                                                              width: 100,
                                                              height: 110,
                                                            )),
                                                            iconGallery:
                                                                Container(
                                                                    child: Image
                                                                        .asset(
                                                              "images/1.png",
                                                              width: 100,
                                                              height: 140,
                                                            )));
                                                      });
                                                },
                                              ),
                                            )
                                          ])),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          response.nome,
                                          style: TextStyle(
                                            fontSize: Dimens.textSize6,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimens.minMarginApplication),
                                        Text(
                                          response.email,
                                          style: TextStyle(
                                            fontSize: Dimens.textSize5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),

                        Container(
                          height: 60,
                          child: TabBar(
                            tabs: [
                              Container(
                                child: Text(
                                  "Pessoal",
                                  style: TextStyle(
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Container(
                                  child: Text(
                                "Endereço",
                                style: TextStyle(
                                  fontSize: Dimens.textSize6,
                                  fontWeight: FontWeight.w900,
                                ),
                              ))
                            ],
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: OwnerColors.colorPrimary,
                            labelColor: Colors.black,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 2.0,
                            isScrollable: false,
                            controller: _tabController,
                            onTap: (value) {
                              setState(() {
                                // if (value == 0) {
                                //   _isChanged = false;
                                // } else {
                                //   _isChanged = true;
                                // }
                              });

                              print(value);
                            },
                          ),
                        ),
                        Container(
                          child: AutoScaleTabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(
                                        Dimens.paddingApplication),
                                    height: 700,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  Dimens.minMarginApplication),
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
                                                  color:
                                                      OwnerColors.colorPrimary,
                                                  width: 1.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                            hintText: 'Ex: José Pereira',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.radiusApplication),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.all(Dimens
                                                .textFieldPaddingApplication),
                                          ),
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Dimens.textSize5,
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimens.marginApplication),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  Dimens.minMarginApplication),
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
                                          controller: documentController,
                                          inputFormatters: [Masks().cpfMask()],
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      OwnerColors.colorPrimary,
                                                  width: 1.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                            hintText: '000.000.000-00',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.radiusApplication),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.all(Dimens
                                                .textFieldPaddingApplication),
                                          ),
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Dimens.textSize5,
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimens.marginApplication),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  Dimens.minMarginApplication),
                                          child: Text(
                                            "Telefone",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: Dimens.textSize5,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          controller: cellphoneController,
                                          inputFormatters: [
                                            Masks().cellphoneMask()
                                          ],
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      OwnerColors.colorPrimary,
                                                  width: 1.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                            hintText: '(##)#####-####',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.radiusApplication),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.all(Dimens
                                                .textFieldPaddingApplication),
                                          ),
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Dimens.textSize5,
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimens.marginApplication),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  Dimens.minMarginApplication),
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
                                                  color:
                                                      OwnerColors.colorPrimary,
                                                  width: 1.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                            hintText: 'exemplo@email.com',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.radiusApplication),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.all(Dimens
                                                .textFieldPaddingApplication),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Dimens.textSize5,
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimens.marginApplication),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: Dimens.marginApplication,
                                              bottom: Dimens.marginApplication),
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style:
                                                Styles().styleAlternativeButton,
                                            onPressed: _isLoading
                                                ? null
                                                : () async {

                                                    // if (!validator.validateEmail(emailController.text))
                                                    //   return;
                                                    // if (!validator.validateCNPJ(documentController.text))
                                                    //   return;
                                                    if (!validator
                                                        .validateCellphone(
                                                            cellphoneController
                                                                .text)) return;


                                                    setState(() {
                                                      _isLoading = true;
                                                    });

                                                    await updateUserDataRequest(
                                                        nameController
                                                            .text,
                                                        documentController.text,
                                                        cellphoneController
                                                            .text,
                                                        emailController.text, "");

                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  },
                                            child: (_isLoading)
                                                ? const SizedBox(
                                                    width: Dimens
                                                        .buttonIndicatorWidth,
                                                    height: Dimens
                                                        .buttonIndicatorHeight,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: OwnerColors
                                                          .colorAccent,
                                                      strokeWidth: Dimens
                                                          .buttonIndicatorStrokes,
                                                    ))
                                                : Text("Alterar",
                                                    style: Styles()
                                                        .styleDefaultTextButton),
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                  padding:
                                      EdgeInsets.all(Dimens.paddingApplication),
                                  height: /*_hasSchedule ? */ 700 /*: 236*/,
                                  child: Column(children: [
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          bottom: Dimens.minMarginApplication),
                                      child: Text(
                                        "CEP",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (value) {
                                        if (value.length > 8) {
                                          getCepInfo(value);
                                        }
                                      },
                                      controller: cepController,
                                      inputFormatters: [Masks().cepMask()],
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.only(
                                                  bottom: Dimens
                                                      .minMarginApplication),
                                              child: Text(
                                                "Cidade",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: Dimens.textSize5,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            TextField(
                                              readOnly: true,
                                              controller: cityController,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: OwnerColors
                                                          .colorPrimary,
                                                      width: 1.5),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                ),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimens
                                                          .radiusApplication),
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding: EdgeInsets.all(
                                                    Dimens
                                                        .textFieldPaddingApplication),
                                              ),
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Dimens.textSize5,
                                              ),
                                            ),
                                          ],
                                        )),
                                        SizedBox(
                                            width: Dimens.marginApplication),
                                        Expanded(
                                            child: Column(children: [
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                                bottom: Dimens
                                                    .minMarginApplication),
                                            child: Text(
                                              "Estado",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: Dimens.textSize5,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          TextField(
                                            readOnly: true,
                                            controller: stateController,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: OwnerColors
                                                        .colorPrimary,
                                                    width: 1.5),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(Dimens
                                                        .radiusApplication),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: EdgeInsets.all(Dimens
                                                  .textFieldPaddingApplication),
                                            ),
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: Dimens.textSize5,
                                            ),
                                          ),
                                        ])),
                                      ],
                                    ),
                                    SizedBox(height: Dimens.marginApplication),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          bottom: Dimens.minMarginApplication),
                                      child: Text(
                                        "Endereço",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: addressController,
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(children: [
                                            Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.only(
                                                  bottom: Dimens
                                                      .minMarginApplication),
                                              child: Text(
                                                "Bairro",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: Dimens.textSize5,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            TextField(
                                              controller: nbhController,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: OwnerColors
                                                          .colorPrimary,
                                                      width: 1.5),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                ),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimens
                                                          .radiusApplication),
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding: EdgeInsets.all(
                                                    Dimens
                                                        .textFieldPaddingApplication),
                                              ),
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Dimens.textSize5,
                                              ),
                                            )
                                          ]),
                                        ),
                                        SizedBox(
                                            width: Dimens.marginApplication),
                                        Expanded(
                                          child: Column(children: [
                                            Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.only(
                                                  bottom: Dimens
                                                      .minMarginApplication),
                                              child: Text(
                                                "Número",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: Dimens.textSize5,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            TextField(
                                              controller: numberController,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: OwnerColors
                                                          .colorPrimary,
                                                      width: 1.5),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                ),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(Dimens
                                                          .radiusApplication),
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding: EdgeInsets.all(
                                                    Dimens
                                                        .textFieldPaddingApplication),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Dimens.textSize5,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimens.marginApplication),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          bottom: Dimens.minMarginApplication),
                                      child: Text(
                                        "Complemento",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: complementController,
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                      margin: EdgeInsets.only(
                                          top: Dimens.marginApplication,
                                          bottom: Dimens.marginApplication),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: Styles().styleAlternativeButton,
                                        onPressed: _isLoading
                                            ? null
                                            : () async {
                                                if (!validator.validateCEP(
                                                    cepController.text)) return;
                                                if (!validator
                                                    .validateGenericTextField(
                                                        cityController.text,
                                                        "Cidade")) return;
                                                if (!validator
                                                    .validateGenericTextField(
                                                        stateController.text,
                                                        "Estado")) return;
                                                if (!validator
                                                    .validateGenericTextField(
                                                        addressController.text,
                                                        "Endereço")) return;
                                                if (!validator
                                                    .validateGenericTextField(
                                                        nbhController.text,
                                                        "Bairro")) return;
                                                if (!validator
                                                    .validateGenericTextField(
                                                        numberController.text,
                                                        "Número")) return;

                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                // await updateAddressRequest(
                                                //     cepController.text.toString(),
                                                //     stateController.text.toString(),
                                                //     cityController.text.toString(),
                                                //     addressController.text.toString(),
                                                //     nbhController.text.toString(),
                                                //     numberController.text.toString(),
                                                //     complementController.text.toString());

                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                        child: (_isLoading)
                                            ? const SizedBox(
                                                width: Dimens.buttonIndicatorWidth,
                                                height:
                                                    Dimens.buttonIndicatorHeight,
                                                child: CircularProgressIndicator(
                                                  color: OwnerColors.colorAccent,
                                                  strokeWidth:
                                                      Dimens.buttonIndicatorStrokes,
                                                ))
                                            : Text("Atualizar endereço",
                                                style: Styles()
                                                    .styleDefaultTextButton),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.marginApplication),
                                  ]),
                                )
                              ]),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Styles().defaultLoading;
              },
            )),
          )
        ]))));
  }
}
