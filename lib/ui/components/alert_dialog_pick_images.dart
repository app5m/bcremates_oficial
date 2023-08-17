import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../res/dimens.dart';

class PickImageAlertDialog extends StatefulWidget {
  Container? iconCamera;
  Container? iconGallery;

  PickImageAlertDialog({
    Key? key,
    this.iconCamera,
    this.iconGallery,
  });

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<PickImageAlertDialog> createState() => _PickImageAlertDialogState();
}

class _PickImageAlertDialogState extends State<PickImageAlertDialog> {

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
              padding: const EdgeInsets.all(Dimens.paddingApplication),
              child: Column(children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    widget.iconCamera!,
                    widget.iconGallery!,
                  ],
                ),
              ])),
        ]);
  }
}
