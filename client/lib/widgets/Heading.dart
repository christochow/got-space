import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  Heading({Key key, this.header}) : super(key: key);
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return this.header.contains("Library")
        ? Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
              header,
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: Icon(
                Icons.help_outline,
                color: Theme.of(context).backgroundColor,
              ),
              onPressed: () => _showDialog(context),
            ),
          ]))
        : Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
                child: Text(
              header,
              style: TextStyle(fontSize: 18),
            )),
          );
  }
}
