
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isVisibleBackButton;
  bool isVisibleNotificationsButton;
  bool isVisibleIcon;

  CustomAppBar(
      {this.title = "",
      this.isVisibleBackButton = false,
      this.isVisibleNotificationsButton = false,
      this.isVisibleIcon = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: _returnFavoriteIcon(context),
      automaticallyImplyLeading: this.isVisibleBackButton,
      leading: _returnBackIcon(this.isVisibleBackButton, context),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 10,
      title: Row(
        children: [
          // Visibility(
          //     visible: isVisibleIcon,
          //     child: Container(
          //       margin: EdgeInsets.only(left: Dimens.minMarginApplication),
          //       child: Image.asset(
          //         'images/main_logo_1.png',
          //         height: AppBar().preferredSize.height * 0.60,
          //       ),
          //     )),
          Container(
            margin: EdgeInsets.only(left: Dimens.minMarginApplication),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: Dimens.textSize7,
                color: Colors.black,
                fontWeight: FontWeight.w900
              ),
            ),
          )
        ],
      ),
    );
  }

  Container? _returnBackIcon(bool isVisible, BuildContext context) {
    if (isVisible) {
      return Container(
          margin: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black54,
              size: 20,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                SystemNavigator.pop();
              }
            },
          ));
    }

    return null;
  }

  List<Widget> _returnFavoriteIcon(BuildContext context) {
    List<Widget> _widgetList = <Widget>[];

    if (isVisibleNotificationsButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.shopping_cart_outlined,
          color: OwnerColors.colorPrimary,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/ui/cart");
        },
      ));
    }

    if (isVisibleNotificationsButton) {
      _widgetList.add(IconButton(
        icon: Icon(
          Icons.notifications_none_sharp,
          color: OwnerColors.colorPrimary,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/ui/notifications");
        },
      ));
    }

    return _widgetList;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
