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
  final TextEditingController fantasyNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();

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
    fantasyNameController.dispose();
    ownerNameController.dispose();

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

  Future<List<Map<String, dynamic>>> loadProfileRequest() async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOAD_PROFILE, body);
      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);
      //
      // if (response.status == "01") {
      // setState(() {
      _profileResponse = response;

      ownerNameController.text = _profileResponse!.nome.toString();
      fantasyNameController.text = _profileResponse!.nome_fantasia.toString();
      socialReasonController.text = _profileResponse!.razao_social.toString();
      emailController.text = _profileResponse!.email.toString();
      documentController.text = Preferences.getUserData()!.tipo == 2
          ? _profileResponse!.cpf.toString()
          : _profileResponse!.cnpj.toString();
      cellphoneController.text = _profileResponse!.celular.toString();

      // cepController.text = _profileResponse!.cep;
      // cityController.text = _profileResponse!.cidade;
      // stateController.text = _profileResponse!.estado;
      // addressController.text = _profileResponse!.endereco;
      // nbhController.text = _profileResponse!.bairro;
      // numberController.text = _profileResponse!.numero;
      // complementController.text = _profileResponse!.complemento;
      // });
      // } else {}

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> updateUserDataRequest(
      String name,
      String document,
      String cellphone,
      String email,
      String fantasyName,
      String socialReason) async {
    try {
      final body = {
        "id": await Preferences.getUserData()!.id,
        "nome": name,
        // "cpf": document,
        "celular": cellphone,
        "email": email,
        "tipo": Preferences.getUserData()!.tipo,
        "nome_fantasia": fantasyName,
        "razao_social": socialReason,
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
              child: Container(
                child: Column(
                  children: [
                    // Expanded(
/*                FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadProfileRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final response = User.fromJson(snapshot.data![0]);

                      return */
                    Material(
                        elevation: Dimens.elevationApplication,
                        child: Container(
                          padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    right: Dimens.marginApplication),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(42),
                                    // Image radius
                                    child: Image.network(
                                        ApplicationConstant
                                            .URL_AVATAR /*+
                                              response.avatar.toString()*/
                                        ,
                                        fit: BoxFit.cover,
                                        /*fit: BoxFit.cover*/
                                        errorBuilder:
                                            (context, exception, stackTrack) =>
                                                Image.asset(
                                                  'images/person.jpg',
                                                )),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      /*response.nome*/
                                      "Nome teste",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens.textSize6,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                        height: Dimens.minMarginApplication),
                                    Text(
                                      /*response.email*/
                                      "email@email.com",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
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
                    /*;
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),*/
                    Container(
                      height: 60,
                      child: TabBar(
                        tabs: [
                          Container(
                            child: Text(
                              "Pessoal",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                              child: Text(
                            "Endereço",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: Dimens.textSize6,
                              fontWeight: FontWeight.w500,
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
                                padding:
                                    EdgeInsets.all(Dimens.paddingApplication),
                                height: 700,
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
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      // controller: nameController,
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
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          bottom: Dimens.minMarginApplication),
                                      child: Text(
                                        "CPF",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: Dimens.textSize5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      // controller: cpfController,
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
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          bottom: Dimens.minMarginApplication),
                                      child: Text(
                                        "Telefone",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
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
                                              color: OwnerColors.colorPrimary,
                                              width: 1.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        hintText: '(##)#####-####',
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
                                      keyboardType: TextInputType.emailAddress,
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
                                                if (!validator
                                                    .validateGenericTextField(
                                                        ownerNameController
                                                            .text,
                                                        "Nome resposável"))
                                                  return;

                                                // if (!validator.validateEmail(emailController.text))
                                                //   return;
                                                // if (!validator.validateCNPJ(documentController.text))
                                                //   return;
                                                if (!validator
                                                    .validateCellphone(
                                                        cellphoneController
                                                            .text)) return;

                                                if (Preferences.getUserData()!
                                                        .tipo ==
                                                    1) {
                                                  if (!validator
                                                      .validateGenericTextField(
                                                          fantasyNameController
                                                              .text,
                                                          "Nome fantasia"))
                                                    return;
                                                  if (!validator
                                                      .validateGenericTextField(
                                                          socialReasonController
                                                              .text,
                                                          "Razão social"))
                                                    return;
                                                }

                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                await updateUserDataRequest(
                                                    ownerNameController.text,
                                                    documentController.text,
                                                    cellphoneController.text,
                                                    emailController.text,
                                                    fantasyNameController.text,
                                                    socialReasonController
                                                        .text);

                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                        child: (_isLoading)
                                            ? const SizedBox(
                                                width:
                                                    Dimens.buttonIndicatorWidth,
                                                height: Dimens
                                                    .buttonIndicatorHeight,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      OwnerColors.colorAccent,
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
                                      fontFamily: 'Inter',
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
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  Dimens.minMarginApplication),
                                          child: Text(
                                            "Cidade",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: Dimens.textSize5,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          readOnly: true,
                                          controller: cityController,
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
                                      ],
                                    )),
                                    SizedBox(width: Dimens.marginApplication),
                                    Expanded(
                                        child: Column(children: [
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            bottom:
                                                Dimens.minMarginApplication),
                                        child: Text(
                                          "Estado",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
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
                                      bottom:
                                      Dimens.minMarginApplication),
                                  child: Text(
                                    "Endereço",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                        Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            bottom:
                                            Dimens.minMarginApplication),
                                        child: Text(
                                          "Bairro",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize5,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        controller: nbhController,
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
                                          contentPadding: EdgeInsets.all(Dimens
                                              .textFieldPaddingApplication),
                                        ),
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Dimens.textSize5,
                                        ),
                                      )]),
                                    ),
                                    SizedBox(width: Dimens.marginApplication),
                                    Expanded(
                                      child: Column(
                                        children: [
                                        Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            bottom:
                                            Dimens.minMarginApplication),
                                        child: Text(
                                          "Número",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize5,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        controller: numberController,
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
                                          contentPadding: EdgeInsets.all(Dimens
                                              .textFieldPaddingApplication),
                                        ),
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Dimens.textSize5,
                                        ),
                                      )]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimens.marginApplication),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      bottom:
                                      Dimens.minMarginApplication),
                                  child: Text(
                                    "Complemento",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
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
                                // Container(
                                //   margin: EdgeInsets.only(
                                //       top: Dimens.marginApplication,
                                //       bottom: Dimens.marginApplication),
                                //   width: double.infinity,
                                //   child: ElevatedButton(
                                //     style: Styles().styleDefaultButton,
                                //     onPressed: _isLoading
                                //         ? null
                                //         : () async {
                                //             if (!validator.validateCEP(
                                //                 cepController.text)) return;
                                //             if (!validator
                                //                 .validateGenericTextField(
                                //                     cityController.text,
                                //                     "Cidade")) return;
                                //             if (!validator
                                //                 .validateGenericTextField(
                                //                     stateController.text,
                                //                     "Estado")) return;
                                //             if (!validator
                                //                 .validateGenericTextField(
                                //                     addressController.text,
                                //                     "Endereço")) return;
                                //             if (!validator
                                //                 .validateGenericTextField(
                                //                     nbhController.text,
                                //                     "Bairro")) return;
                                //             if (!validator
                                //                 .validateGenericTextField(
                                //                     numberController.text,
                                //                     "Número")) return;
                                //
                                //             setState(() {
                                //               _isLoading = true;
                                //             });
                                //
                                //             // await updateAddressRequest(
                                //             //     cepController.text.toString(),
                                //             //     stateController.text.toString(),
                                //             //     cityController.text.toString(),
                                //             //     addressController.text.toString(),
                                //             //     nbhController.text.toString(),
                                //             //     numberController.text.toString(),
                                //             //     complementController.text.toString());
                                //
                                //             setState(() {
                                //               _isLoading = false;
                                //             });
                                //           },
                                //     child: (_isLoading)
                                //         ? const SizedBox(
                                //             width: Dimens.buttonIndicatorWidth,
                                //             height:
                                //                 Dimens.buttonIndicatorHeight,
                                //             child: CircularProgressIndicator(
                                //               color: OwnerColors.colorAccent,
                                //               strokeWidth:
                                //                   Dimens.buttonIndicatorStrokes,
                                //             ))
                                //         : Text("Atualizar endereço",
                                //             style: Styles()
                                //                 .styleDefaultTextButton),
                                //   ),
                                // ),
                                SizedBox(height: Dimens.marginApplication),
                              ]),
                            )
                          ]),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   margin: EdgeInsets.only(bottom: Dimens.marginApplication),
                    //   child: Text(
                    //     "Meus dados",
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       fontFamily: 'Inter',
                    //       fontSize: Dimens.textSize6,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    // TextField(
                    //   controller: ownerNameController,
                    //   decoration: InputDecoration(
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           color: OwnerColors.colorPrimary, width: 1.5),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Colors.grey, width: 1.0),
                    //     ),
                    //     hintText: 'Nome responsável',
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     border: OutlineInputBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(Dimens.radiusApplication),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     contentPadding:
                    //         EdgeInsets.all(Dimens.textFieldPaddingApplication),
                    //   ),
                    //   keyboardType: TextInputType.text,
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: Dimens.textSize5,
                    //   ),
                    // ),
                    // SizedBox(height: Dimens.marginApplication),
                    // TextField(
                    //   readOnly: true,
                    //   controller: emailController,
                    //   decoration: InputDecoration(
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           color: OwnerColors.colorPrimary, width: 1.5),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Colors.grey, width: 1.0),
                    //     ),
                    //     hintText: 'E-mail',
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     border: OutlineInputBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(Dimens.radiusApplication),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     contentPadding:
                    //         EdgeInsets.all(Dimens.textFieldPaddingApplication),
                    //   ),
                    //   keyboardType: TextInputType.emailAddress,
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: Dimens.textSize5,
                    //   ),
                    // ),
                    // SizedBox(height: Dimens.marginApplication),
                    // TextField(
                    //   readOnly: true,
                    //   controller: documentController,
                    //   // inputFormatters: [Masks().cnpjMask()],
                    //   decoration: InputDecoration(
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           color: OwnerColors.colorPrimary, width: 1.5),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide:
                    //       BorderSide(color: Colors.grey, width: 1.0),
                    //     ),
                    //     hintText: 'Documento',
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     border: OutlineInputBorder(
                    //       borderRadius:
                    //       BorderRadius.circular(Dimens.radiusApplication),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     contentPadding:
                    //     EdgeInsets.all(Dimens.textFieldPaddingApplication),
                    //   ),
                    //   keyboardType: TextInputType.number,
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: Dimens.textSize5,
                    //   ),
                    // ),
                    // SizedBox(height: Dimens.marginApplication),
                    // TextField(
                    //   controller: cellphoneController,
                    //   inputFormatters: [Masks().cellphoneMask()],
                    //   decoration: InputDecoration(
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           color: OwnerColors.colorPrimary, width: 1.5),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Colors.grey, width: 1.0),
                    //     ),
                    //     hintText: 'Celular',
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     border: OutlineInputBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(Dimens.radiusApplication),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     contentPadding:
                    //         EdgeInsets.all(Dimens.textFieldPaddingApplication),
                    //   ),
                    //   keyboardType: TextInputType.number,
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: Dimens.textSize5,
                    //   ),
                    // ),
                    // SizedBox(height: Dimens.marginApplication),
                    // Visibility(
                    //     visible: Preferences.getUserData()!.tipo == 1,
                    //     child: Column(children: [
                    //       TextField(
                    //         controller: fantasyNameController,
                    //         decoration: InputDecoration(
                    //           focusedBorder: OutlineInputBorder(
                    //             borderSide: BorderSide(
                    //                 color: OwnerColors.colorPrimary,
                    //                 width: 1.5),
                    //           ),
                    //           enabledBorder: OutlineInputBorder(
                    //             borderSide:
                    //                 BorderSide(color: Colors.grey, width: 1.0),
                    //           ),
                    //           hintText: 'Nome fantasia',
                    //           hintStyle: TextStyle(color: Colors.grey),
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(
                    //                 Dimens.radiusApplication),
                    //             borderSide: BorderSide.none,
                    //           ),
                    //           filled: true,
                    //           fillColor: Colors.white,
                    //           contentPadding: EdgeInsets.all(
                    //               Dimens.textFieldPaddingApplication),
                    //         ),
                    //         keyboardType: TextInputType.text,
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //           fontSize: Dimens.textSize5,
                    //         ),
                    //       ),
                    //       SizedBox(height: Dimens.marginApplication),
                    //     ])),
                    // Visibility(
                    //     visible: Preferences.getUserData()!.tipo == 1,
                    //     child: Column(
                    //       children: [
                    //         TextField(
                    //           controller: socialReasonController,
                    //           decoration: InputDecoration(
                    //             focusedBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: OwnerColors.colorPrimary,
                    //                   width: 1.5),
                    //             ),
                    //             enabledBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: Colors.grey, width: 1.0),
                    //             ),
                    //             hintText: 'Razão Social',
                    //             hintStyle: TextStyle(color: Colors.grey),
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(
                    //                   Dimens.radiusApplication),
                    //               borderSide: BorderSide.none,
                    //             ),
                    //             filled: true,
                    //             fillColor: Colors.white,
                    //             contentPadding: EdgeInsets.all(
                    //                 Dimens.textFieldPaddingApplication),
                    //           ),
                    //           keyboardType: TextInputType.text,
                    //           style: TextStyle(
                    //             color: Colors.grey,
                    //             fontSize: Dimens.textSize5,
                    //           ),
                    //         ),
                    //         SizedBox(height: Dimens.marginApplication),
                    //       ],
                    //     )),

                    // Container(
                    //   width: double.infinity,
                    //   margin: EdgeInsets.only(bottom: Dimens.marginApplication),
                    //   child: Text(
                    //     "Alterar Senha",
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       fontFamily: 'Inter',
                    //       fontSize: Dimens.textSize6,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    // TextField(
                    //   onChanged: (value) {
                    //     setState(() {
                    //       hasPasswordCoPassword = false;
                    //       visibileOne = true;
                    //       hasMinLength = passwordController.text.length >= 8;
                    //       hasUppercase = passwordController.text
                    //           .contains(RegExp(r'[A-Z]'));
                    //
                    //       hasPasswordCoPassword = coPasswordController.text ==
                    //           passwordController.text;
                    //
                    //       if (hasMinLength && hasUppercase) {
                    //         visibileOne = false;
                    //       }
                    //     });
                    //   },
                    //   controller: passwordController,
                    //   decoration: InputDecoration(
                    //     suffixIcon: IconButton(
                    //         icon: Icon(
                    //           // Based on passwordVisible state choose the icon
                    //           _passwordVisible
                    //               ? Icons.visibility
                    //               : Icons.visibility_off,
                    //           color: OwnerColors.colorPrimary,
                    //         ),
                    //         onPressed: () {
                    //           // Update the state i.e. toogle the state of passwordVisible variable
                    //           setState(() {
                    //             _passwordVisible = !_passwordVisible;
                    //           });
                    //         }),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           color: OwnerColors.colorPrimary, width: 1.5),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Colors.grey, width: 1.0),
                    //     ),
                    //     hintText: 'Senha',
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     border: OutlineInputBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(Dimens.radiusApplication),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     contentPadding:
                    //         EdgeInsets.all(Dimens.textFieldPaddingApplication),
                    //   ),
                    //   keyboardType: TextInputType.visiblePassword,
                    //   obscureText: !_passwordVisible,
                    //   enableSuggestions: false,
                    //   autocorrect: false,
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: Dimens.textSize5,
                    //   ),
                    // ),
                    // SizedBox(height: 4),
                    // Visibility(
                    //   visible: passwordController.text.isNotEmpty,
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         hasMinLength
                    //             ? Icons.check_circle
                    //             : Icons.check_circle,
                    //         color: hasMinLength
                    //             ? Colors.green
                    //             : OwnerColors.lightGrey,
                    //       ),
                    //       Text(
                    //         'Deve ter no mínimo 8 carácteres',
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Visibility(
                    //   visible: passwordController.text.isNotEmpty,
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         hasUppercase
                    //             ? Icons.check_circle
                    //             : Icons.check_circle,
                    //         color: hasUppercase
                    //             ? Colors.green
                    //             : OwnerColors.lightGrey,
                    //       ),
                    //       Text(
                    //         'Deve ter uma letra maiúscula',
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: Dimens.marginApplication),
                    // TextField(
                    //   onChanged: (value) {
                    //     setState(() {
                    //       visibileTwo = true;
                    //       hasPasswordCoPassword = coPasswordController.text ==
                    //           passwordController.text;
                    //
                    //       if (hasPasswordCoPassword) {
                    //         visibileTwo = false;
                    //       }
                    //     });
                    //   },
                    //   controller: coPasswordController,
                    //   decoration: InputDecoration(
                    //     suffixIcon: IconButton(
                    //         icon: Icon(
                    //           // Based on passwordVisible state choose the icon
                    //           _passwordVisible2
                    //               ? Icons.visibility
                    //               : Icons.visibility_off,
                    //           color: OwnerColors.colorPrimary,
                    //         ),
                    //         onPressed: () {
                    //           // Update the state i.e. toogle the state of passwordVisible variable
                    //           setState(() {
                    //             _passwordVisible2 = !_passwordVisible2;
                    //           });
                    //         }),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           color: OwnerColors.colorPrimary, width: 1.5),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Colors.grey, width: 1.0),
                    //     ),
                    //     hintText: 'Confirmar Senha',
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     border: OutlineInputBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(Dimens.radiusApplication),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     contentPadding:
                    //         EdgeInsets.all(Dimens.textFieldPaddingApplication),
                    //   ),
                    //   keyboardType: TextInputType.visiblePassword,
                    //   obscureText: !_passwordVisible2,
                    //   enableSuggestions: false,
                    //   autocorrect: false,
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: Dimens.textSize5,
                    //   ),
                    // ),
                    // SizedBox(height: 4),
                    // Visibility(
                    //   visible: coPasswordController.text.isNotEmpty,
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         hasPasswordCoPassword
                    //             ? Icons.check_circle
                    //             : Icons.check_circle,
                    //         color: hasPasswordCoPassword
                    //             ? Colors.green
                    //             : OwnerColors.lightGrey,
                    //       ),
                    //       Text(
                    //         'As senhas fornecidas são idênticas',
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: Dimens.marginApplication),
                    // Container(
                    //   margin: EdgeInsets.only(top: Dimens.marginApplication),
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     style: Styles().styleDefaultButton,
                    //     onPressed: _isLoading
                    //         ? null
                    //         : () async {
                    //             if (!validator.validatePassword(
                    //                 passwordController.text)) return;
                    //             if (!validator.validateCoPassword(
                    //                 passwordController.text,
                    //                 coPasswordController.text)) return;
                    //
                    //             setState(() {
                    //               _isLoading = true;
                    //             });
                    //
                    //             await updatePasswordRequest(
                    //                 passwordController.text);
                    //
                    //             setState(() {
                    //               _isLoading = false;
                    //             });
                    //           },
                    //     child: (_isLoading)
                    //         ? const SizedBox(
                    //             width: Dimens.buttonIndicatorWidth,
                    //             height: Dimens.buttonIndicatorHeight,
                    //             child: CircularProgressIndicator(
                    //               color: OwnerColors.colorAccent,
                    //               strokeWidth: Dimens.buttonIndicatorStrokes,
                    //             ))
                    //         : Text("Atualizar senha",
                    //             style: Styles().styleDefaultTextButton),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )),
          ]),
        )));
  }
}
