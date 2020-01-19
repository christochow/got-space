import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  AppBarWidget({Key key, this.header}) : super(key: key);
  final String header;

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      bottom: PreferredSize(
          child: Divider(color: Theme.of(context).backgroundColor),
          preferredSize: Size.fromHeight(1.0)),
      title: Text(header),
      centerTitle: true,
    );
  }
}
