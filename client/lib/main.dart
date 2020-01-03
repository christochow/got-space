import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Got Space?',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool expand = false;
  String val='University Of Toronto';

  Widget dropDown() => Column(
        children: <String>['University Of Toronto']
            .map<Container>((String value) {
          return Container(
            child: FlatButton(
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              onPressed: () {
                setState(() {
                  val = value;
                  expand = false;
                });
              },
            ),
            decoration: BoxDecoration(color: Colors.indigo),
          );
        }).toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
            padding: EdgeInsets.only(left:35),
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(val),
            IconButton(
              icon: Icon(
                expand ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  expand = !expand;
                });
              },
            )
          ],
        )),
        actions: <Widget>[
          PopupMenuButton(
            child: Padding(
              child: Icon(Icons.more_horiz),
              padding: EdgeInsets.only(right: 10),
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Change Default School"),
                )
              ];
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Visibility(
            child: dropDown(),
            visible: expand,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              ],
            ),
          )
        ],
      )
    );
  }
}
