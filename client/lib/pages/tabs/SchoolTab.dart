import 'package:flutter/material.dart';
import 'package:got_space/pages/tabs/LibraryList.dart';

class SchoolTab extends StatefulWidget {
  SchoolTab({Key key}) : super(key: key);

  @override
  _SchoolTabState createState() => _SchoolTabState();
}

class _SchoolTabState extends State<SchoolTab> {
  bool expand = false;
  String val = 'University Of Toronto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: LibraryList()
          ),
        );
  }
}
