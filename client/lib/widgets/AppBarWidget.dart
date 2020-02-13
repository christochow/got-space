import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget({Key key, this.header}) : super(key: key);
  final String header;

  _showDialog(BuildContext rootContext) {
    showDialog(
        context: rootContext,
        builder: (parentCtx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(24.0),
            ),
            title: Text('What do the ratings mean?'),
            content: Container(
                child: Text(
                  'Ratings are scaled from 0 to 10, where ' +
                      '0 means there are no one in the area, ' +
                      '10 means the area is full.',
                )),
            actions: <Widget>[
              FlatButton(
                  child: new Text('Got it'),
                  onPressed: () {
                    Navigator.of(parentCtx).pop();
                  })
            ],
          );
        });
  }

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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.home, color: Theme.of(context).backgroundColor),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        IconButton(
          icon: Icon(Icons.help_outline,
              color: Theme.of(context).backgroundColor),
          onPressed: () => _showDialog(context),
        ),
      ],
    );
  }
}
