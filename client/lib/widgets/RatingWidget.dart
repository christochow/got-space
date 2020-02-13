import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RatingWidget extends StatelessWidget {
  RatingWidget({Key key, this.e}) : super(key: key);
  final DocumentSnapshot e;

  String _constructDate(DateTime time) {
    return time.year.toString() +
        '-' +
        _padZero(time.month) +
        '-' +
        _padZero(time.day) +
        ' ' +
        _padZero(time.hour) +
        ':' +
        _padZero(time.minute);
  }

  String _padZero(int num) {
    if (num < 10) {
      return '0' + num.toString();
    } else {
      return num.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
              'Crowdedness Rating : ' +
                  num.parse(e.data['rating'].toString()).toStringAsFixed(1),
              style: TextStyle(fontSize: 16)),
          Text(
            ' Last updated: ' +
                _constructDate(
                    DateTime.fromMillisecondsSinceEpoch(e.data['timestamp'])),
            style: TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }
}
