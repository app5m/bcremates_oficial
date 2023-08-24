import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../main/home.dart';

class SucessRegister extends StatefulWidget {
  const SucessRegister({Key? key}) : super(key: key);

  @override
  State<SucessRegister> createState() => _SucessRegisterState();
}

class _SucessRegisterState extends State<SucessRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        /*Expanded(
          child: */Image.asset(
          'images/bg_main.png',
          fit: BoxFit.fitWidth,
        ),
        // ),
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
                          "Cadastro Finalizado",
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
                          textAlign: TextAlign.center,
                          "Uma notificação será enviada no seu e-mail quando o cadastro for aprovado pelo administrador.",
                          style: TextStyle(
                            fontSize: Dimens.textSize5,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ])),
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
                    },
                    child: Text("Sair", style: Styles().styleDefaultTextButton),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ))
      ]),
    );
  }
}
