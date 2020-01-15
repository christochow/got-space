import 'package:flutter/material.dart';

class DefaultSchoolPage extends StatefulWidget {
  DefaultSchoolPage({Key key, this.schools, this.school}) : super(key: key);
  final List<String> schools;
  final String school;

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
            .map((e) => FlatButton(
                  child:
                      Text(e + (e == widget.school ? " -- current default" : '')),
                  onPressed: () {
                    Navigator.pop(context, e);
                  },
                ))
            .toList(),
      ),
    );
  }
}
