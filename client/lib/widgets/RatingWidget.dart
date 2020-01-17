import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RatingWidget extends StatelessWidget {
  RatingWidget({Key key, this.e}) : super(key: key);
  final DocumentSnapshot e;

  String _constructDate(DateTime time){
    return time.year.toString()+'-'+time.month.toString()+'-'+time.day.toString()+
        ' '+time.hour.toString()+':'+time.minute.toString();
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
          Text('This area\'s rating is ' +
                  num.parse(e.data['rating'].toString()).toStringAsFixed(1),
              style: TextStyle(fontSize: 17)),
          Text(
            ' Last updated: ' +
                _constructDate(DateTime.fromMillisecondsSinceEpoch(e.data['timestamp'])),
            style: TextStyle(fontSize: 10),),
        ],
      ),
    );
  }
}
