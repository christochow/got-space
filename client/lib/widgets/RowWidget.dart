import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RowWidget extends StatelessWidget {
  RowWidget({Key key, this.e, this.i}) : super(key: key);
  final DocumentSnapshot e;
  final int i;

  String _constructDate(DateTime time) {
    return time.year.toString() +
        '-' +
        time.month.toString() +
        '-' +
        time.day.toString() +
        ' ' +
        time.hour.toString() +
        ':' +
        time.minute.toString();
  }

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
