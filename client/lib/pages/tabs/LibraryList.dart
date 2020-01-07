import 'package:flutter/material.dart';

class LibraryList extends StatefulWidget {
  LibraryList({Key key}) : super(key: key);

  @override
  _LibraryListState createState() => _LibraryListState();
}

class _LibraryListState extends State<LibraryList> {
  bool expand = false;
  String val = 'University Of Toronto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          ),
        ));
  }
}
