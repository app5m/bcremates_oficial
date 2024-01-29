import 'package:flutter/material.dart';

import '../../res/dimens.dart';

class SucessAlertDialog extends StatefulWidget {
  Container btnConfirm;
  String? content;

  SucessAlertDialog({
    Key? key,
    required this.btnConfirm,
    this.content,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<SucessAlertDialog> createState() => _SucessAlertDialogState();
}

class _SucessAlertDialogState extends State<SucessAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 300,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.paddingApplication),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      child: Image.asset(
                    fit: BoxFit.fitWidth,
                    'images/success.png',
                    height: 100,
                  )),
                  SizedBox(height: Dimens.marginApplication),
                  Text(
                    widget.content!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimens.textSize5,
                        color: Colors.black),
                  ),
                  SizedBox(height: Dimens.marginApplication),
                  widget.btnConfirm,
                ],
              ),
            ),
          ]),
    );
  }
}
