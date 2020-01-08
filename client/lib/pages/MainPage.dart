import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/bloc/MainBloc.dart';
import 'package:got_space/pages/tabs/SchoolTab.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool expand = false;
  List<String> schools = ['University Of Toronto'];
  List<Widget> widgets = [SchoolTab()];
  int index = 0;

  Widget dropDown(List<String> schools) => Column(
    children: schools.map<Container>((String value) {
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
              index = schools.indexOf(value);
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
    return BlocBuilder<MainBloc, List<String>>(
      builder: (context, state){
        widgets = state.map((e)=>SchoolTab()).toList();
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Padding(
                  padding: EdgeInsets.only(left:35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(state[index]),
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
            body: ListView(
              children: <Widget>[
                Visibility(
                  child: dropDown(state),
                  visible: expand,
                ),
                widgets[index]
              ],
            )
        );
      });
  }
}
