import 'package:flutter/cupertino.dart';

class Heading extends StatelessWidget {
  Heading({Key key, this.header}) : super(key: key);
  final String header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Text(
          header,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
