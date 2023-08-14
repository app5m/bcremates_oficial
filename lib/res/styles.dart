import 'dart:ui';

import 'package:bc_remates/res/strings.dart';
import 'package:flutter/material.dart';

import 'dimens.dart';
import 'owner_colors.dart';

class Styles {

  var styleDefaultButton = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.buttonPaddingApplication)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.colorPrimary),
  );

  var styleAlternativeButton = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.buttonPaddingApplication)),
    backgroundColor: MaterialStateProperty.all(Colors.black),
  );

  var styleOutlinedButton = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.buttonPaddingApplication)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.minRadiusApplication))),
      side: MaterialStateProperty.all(BorderSide(
          color: Colors.red,
          width: 1.0,
          style: BorderStyle.solid)),
    backgroundColor: MaterialStateProperty.all(Colors.white),
  );

  var styleDefaultTextButton = TextStyle(
      fontFamily: 'Inter',
      fontSize: Dimens.textSize7,
      color: Colors.white);

  var styleOutlinedTextButton = TextStyle(
      fontFamily: 'Inter',
      fontSize: Dimens.textSize6,
      color: Colors.red);

  var styleTitleText = TextStyle(
    fontFamily: 'Inter',
    fontSize: Dimens.textSize7,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  var styleShapeBottomSheet = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(Dimens.minRadiusApplication),
    ),
  );

  var styleDescriptionText = TextStyle(
    fontFamily: 'Inter',
    fontSize: Dimens.textSize5,
    color: Colors.white,
    letterSpacing: 0.5
  );

  var div_horizontal = Divider(
    color: Colors.black12,
    height: 2,
    thickness: 1.5,
  );

  var div_vertical = VerticalDivider(
    color: Colors.black12,
    width: 2,
    thickness: 1.5,
  );

  var defaultLoading = Center(child: CircularProgressIndicator());

  var defaultErrorRequest = Text(Strings.no_connection_description);
}
