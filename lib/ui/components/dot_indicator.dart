import 'package:flutter/material.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';


class DotIndicator extends StatelessWidget {

  final bool isActive;
  final Color color;

  const DotIndicator({Key? key, this.isActive = false, required this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 24, 2, 24),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isActive ? 6 : 6,
          width: isActive ? 14 : 6,
          decoration: BoxDecoration(
              color: isActive ? color : Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(12)))),
    );
  }
}