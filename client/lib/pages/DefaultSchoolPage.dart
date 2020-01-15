import 'package:flutter/material.dart';

class DefaultSchoolPage extends StatefulWidget {
  DefaultSchoolPage({Key key, this.schools}) : super(key: key);
  final List<String> schools;

  @override
  _DefaultSchoolPageState createState() => _DefaultSchoolPageState();
}

class _DefaultSchoolPageState extends State<DefaultSchoolPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Default School'),
      ),
      body: ListView(
        children: widget.schools
            .map((e) =>
            FlatButton(
              child: Text(e),
              onPressed: (){
                Navigator.pop(context, e);
              },
            ))
            .toList(),
      ),
    );
  }
}
