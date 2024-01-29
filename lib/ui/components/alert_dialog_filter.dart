import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bc_remates/model/city.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
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

class FilterAlertDialog extends StatefulWidget {
  final Function(String, String, String, String) onContainer;

  FilterAlertDialog({Key? key, required this.onContainer});

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<FilterAlertDialog> createState() => _FilterAlertDialog();
}

class _FilterAlertDialog extends State<FilterAlertDialog> {
  String? _currentAddress;
  Position? _currentPosition;

  List<String> _cities = [];

  final postRequest = PostRequest();

  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  @override
  void initState() {
    _handleLocationPermission();

    searchCities("");
    super.initState();
  }

  @override
  void dispose() {
    dateFromController.dispose();
    dateToController.dispose();
    nameController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> runAdvancedFilter(String name, String idAuction, String city,
      String dateFrom, String dateTo, String lat, String long) async {
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

  Future<void> searchCities(String city) async {
    try {
      final body = {"cidade": city, "token": ApplicationConstant.TOKEN};

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SEARCH_CITIES, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      //
      // if (response.status == "01") {
      //
      // } else {}
      // ApplicationMessages(context: context).showMessage(response.msg);

      _cities.clear();
      for (var i = 0; i < _map.length; i += 1) {
        final response = City.fromJson(_map[i]);

        _cities.add(response.cidade);
        print(i);
      }
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.paddingApplication,
                Dimens.paddingApplication,
                Dimens.paddingApplication,
                MediaQuery.of(context).viewInsets.bottom +
                    Dimens.paddingApplication),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
                SizedBox(height: Dimens.minMarginApplication),
                Text(
                  "Filtro Avançado",
                  style: TextStyle(
                    fontSize: Dimens.textSize6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: Dimens.minMarginApplication),
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
                          color: OwnerColors.colorPrimary, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'Ex: José Pereira',
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
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Dimens.textSize5,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: Dimens.minMarginApplication),
                  child: Text(
                    "Cidade / Estado",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: Dimens.textSize5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SimpleAutoCompleteTextField(
                  key: key,
                  suggestions: _cities,
                  controller: cityController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: OwnerColors.colorPrimary, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
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
                              bottom: Dimens.minMarginApplication),
                          child: Text(
                            "Data",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: Dimens.textSize5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        TextField(
                          controller: dateFromController,
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              dateFormat: 'dd MMMM yyyy',
                              initialDateTime: DateTime.now(),
                              minDateTime: DateTime(2000),
                              maxDateTime: DateTime(3000),
                              pickerTheme: DateTimePickerTheme(confirm: Text("CONFIRMAR")),
                              onMonthChangeStartWithFirstDate: true,
                              onConfirm: (dateTime, List<int> index) {
                                DateTime selectdate = dateTime;
                                final selIOS =
                                    DateFormat('dd/MM/yyyy').format(selectdate);
                                print(selIOS);

                                setState(() {
                                  dateFromController.text = selIOS;
                                });
                              },
                            );
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: OwnerColors.colorPrimary, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            hintText: '00/00/0000',
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
                      ],
                    )),
                    SizedBox(width: Dimens.minMarginApplication),
                    Expanded(
                        flex: 0,
                        child: Container(
                          margin:
                              EdgeInsets.only(top: Dimens.marginApplication),
                          child: Text(
                            "Até",
                            style: TextStyle(
                              fontSize: Dimens.textSize4,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )),
                    SizedBox(width: Dimens.minMarginApplication),
                    Expanded(
                        child: Column(children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            bottom: Dimens.minMarginApplication),
                        child: Text(
                          "",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: Dimens.textSize5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      TextField(
                        controller: dateToController,
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            dateFormat: 'dd MMMM yyyy',
                            initialDateTime: DateTime.now(),
                            minDateTime: DateTime(2000),
                            maxDateTime: DateTime(3000),
                            pickerTheme: DateTimePickerTheme(confirm: Text("CONFIRMAR")),
                            onMonthChangeStartWithFirstDate: true,
                            onConfirm: (dateTime, List<int> index) {
                              DateTime selectdate = dateTime;
                              final selIOS =
                                  DateFormat('dd/MM/yyyy').format(selectdate);
                              print(selIOS);

                              setState(() {
                                dateToController.text = selIOS;
                              });
                            },
                          );
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: OwnerColors.colorPrimary, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintText: '00/00/0000',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.radiusApplication),
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
                    ])),
                  ],
                ),
                SizedBox(height: 80),
                Container(
                  margin: EdgeInsets.only(top: Dimens.marginApplication),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: Styles().styleDefaultButton,
                    onPressed: () async {
                      widget.onContainer(
                          nameController.text,
                          cityController.text,
                          dateFromController.text,
                          dateToController.text);
                      Navigator.pop(context);
                    },
                    child: /* (_isLoading)
                                  ? const SizedBox(
                                  width: Dimens.buttonIndicatorWidth,
                                  height: Dimens.buttonIndicatorHeight,
                                  child: CircularProgressIndicator(
                                    color: OwnerColors.colorAccent,
                                    strokeWidth: Dimens.buttonIndicatorStrokes,
                                  ))
                                  :*/
                        Text("Aplicar", style: Styles().styleDefaultTextButton),
                  ),
                ),
                SizedBox(width: Dimens.minMarginApplication),
                Container(
                  margin: EdgeInsets.only(top: Dimens.marginApplication),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: Styles().styleOutlinedButton,
                    onPressed: () async {
                      setState(() {
                        nameController.text = "";
                        cityController.text = "";
                        dateFromController.text = "";
                        dateToController.text = "";
                      });
                    },
                    child: /* (_isLoading)
                                  ? const SizedBox(
                                  width: Dimens.buttonIndicatorWidth,
                                  height: Dimens.buttonIndicatorHeight,
                                  child: CircularProgressIndicator(
                                    color: OwnerColors.colorAccent,
                                    strokeWidth: Dimens.buttonIndicatorStrokes,
                                  ))
                                  :*/
                        Text("Limpar", style: Styles().styleBlackTextButton),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
