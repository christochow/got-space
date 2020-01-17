import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RowWidget extends StatelessWidget {
  RowWidget({Key key, this.e, this.i}) : super(key: key);
  final DocumentSnapshot e;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: SizedBox(
          width: double.infinity,
          child: Text(
              i.toString() +
                  '. ' +
                  e.documentID +
                  ': ' +
                  num.parse(e.data['rating'].toString()).toStringAsFixed(1),
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15)),
        ));
  }
}
