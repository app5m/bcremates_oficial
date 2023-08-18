import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';

class FilterAlertDialog extends StatefulWidget {
  FilterAlertDialog({Key? key});

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<FilterAlertDialog> createState() => _FilterAlertDialog();
}

class _FilterAlertDialog extends State<FilterAlertDialog> {
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
                    fontFamily: 'Inter',
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
                      fontFamily: 'Inter',
                      fontSize: Dimens.textSize5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                TextField(
                  readOnly: true,
                  // controller: cityController,
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
                              fontFamily: 'Inter',
                              fontSize: Dimens.textSize5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        TextField(
                          // controller: cityController,
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              dateFormat:
                              'dd MMMM yyyy HH:mm',
                              initialDateTime:
                              DateTime.now(),
                              minDateTime: DateTime(2000),
                              maxDateTime: DateTime(3000),
                              onMonthChangeStartWithFirstDate:
                              true,
                              onConfirm: (dateTime,
                                  List<int> index) {
                                DateTime selectdate =
                                    dateTime;
                                final selIOS = DateFormat(
                                    'dd/MM/yyyy HH:mm')
                                    .format(selectdate);
                                print(selIOS);

                                // updateTask(
                                //     idTask:
                                //     _id.toString(),
                                //     idFleet: _idFleet
                                //         .toString(),
                                //     dateOut: selIOS);
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
                              fontFamily: 'Inter',
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
                            fontFamily: 'Inter',
                            fontSize: Dimens.textSize5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      TextField(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            dateFormat:
                            'dd MMMM yyyy HH:mm',
                            initialDateTime:
                            DateTime.now(),
                            minDateTime: DateTime(2000),
                            maxDateTime: DateTime(3000),
                            onMonthChangeStartWithFirstDate:
                            true,
                            onConfirm: (dateTime,
                                List<int> index) {
                              DateTime selectdate =
                                  dateTime;
                              final selIOS = DateFormat(
                                  'dd/MM/yyyy HH:mm')
                                  .format(selectdate);
                              print(selIOS);

                              // updateTask(
                              //     idTask:
                              //     _id.toString(),
                              //     idFleet: _idFleet
                              //         .toString(),
                              //     dateOut: selIOS);
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
                    onPressed: () async {},
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
                    onPressed: () async {},
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
