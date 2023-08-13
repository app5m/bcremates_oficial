import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/preferences.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {

      await Preferences.init();

      if (await Preferences.getLogin()) {
        Navigator.pushReplacementNamed(context, '/ui/home');
      } else {
        Navigator.pushReplacementNamed(context, '/ui/register');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align( alignment: Alignment.topRight ,child:
             Container(
                    height: MediaQuery.of(context).size.height *
                        0.30,
                    width: MediaQuery.of(context).size.height *
                        0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(MediaQuery.of(context).size.height *
                          0.30), bottomLeft: Radius.circular(MediaQuery.of(context).size.height *
                          0.30)
                      ),
                      color: OwnerColors.splashCircleColor
                      // gradient: LinearGradient(
                      //   begin: Alignment.topRight,
                      //   end: Alignment.bottomRight,
                      //   colors: [
                      //     Colors.purple,
                      //     Colors.pink,
                      //     Colors.orange,
                      //   ],
                      // ),
                    ),
                  )),
              Expanded(child:
              Center(
                child: Image.asset(
                  'images/main_logo_1.png',
                  height: 60,
                ),
              )),
              Align( alignment: Alignment.topLeft ,child:
              Container(
                height: MediaQuery.of(context).size.height *
                    0.30,
                width: MediaQuery.of(context).size.height *
                    0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(MediaQuery.of(context).size.height *
                        0.30), bottomRight: Radius.circular(MediaQuery.of(context).size.height *
                        0.30)
                    ),
                    color: OwnerColors.splashCircleColor
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Colors.purple,
                  //     Colors.pink,
                  //     Colors.orange,
                  //   ],
                  // ),
                ),
              )),
            ],
          )),
    );
  }
}
