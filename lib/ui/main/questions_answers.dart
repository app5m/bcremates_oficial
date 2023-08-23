import 'package:bc_remates/res/strings.dart';
import 'package:bc_remates/ui/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';

class QuestionsAnswers extends StatefulWidget {
  const QuestionsAnswers({Key? key}) : super(key: key);

  @override
  State<QuestionsAnswers> createState() => _QuestionsAnswersState();
}

class _QuestionsAnswersState extends State<QuestionsAnswers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Dúvidas frequentes", isVisibleBackButton: true),
      body: Container(child:
      ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          // final response =
          // Product.fromJson(snapshot.data![index]);

          return InkWell(
              child: Container(
                child: Column (children: [
                  Container(padding: EdgeInsets.all(Dimens.paddingApplication), child:
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.littleLoremIpsum,
                              style: TextStyle(
                                  fontSize: Dimens.textSize5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5
                              ),
                            ),

                          ],
                        ),
                      ),
                      Icon(
                        size: 36,
                        Icons.keyboard_arrow_down,
                        color: Colors.black54,
                      ),

                    ],
                  )),

                  Styles().div_horizontal
                ],)
              ),
              onTap: () {

              });
        },
      )
      ),
    );
  }
}
