import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RowWidget extends StatelessWidget {
  RowWidget({Key key, this.e}) : super(key: key);
  final DocumentSnapshot e;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
        child: SizedBox(
          width: double.infinity,
          child: Text(
                  e.documentID +
                  '\'s vacancy rating: ' +
                  num.parse(e.data['rating'].toString()).toStringAsFixed(1),
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15)),
        ));
  }
}
