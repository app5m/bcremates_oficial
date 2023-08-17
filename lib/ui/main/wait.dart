import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';

class WaitAdmin extends StatefulWidget {
  const WaitAdmin({Key? key}) : super(key: key);

  @override
  State<WaitAdmin> createState() => _WaitAdminState();
}

class _WaitAdminState extends State<WaitAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Expanded(
          child: Image.asset(
            'images/bg_main.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
            padding: EdgeInsets.all(Dimens.paddingApplication),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Image.asset(
                        'images/fact_check.png',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: Dimens.minMarginApplication),
                      Container(
                        width: double.infinity,
                        child: Text(
                          textAlign: TextAlign.center,
                          "Aguarde...",
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
                          textAlign: TextAlign.center,
                          "Aguardando aceitaão do administrador.",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: Dimens.textSize5,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ])),
              ],
            ))
      ]),
    );
  }
}
