import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/bloc/MainBloc.dart';
import 'package:got_space/pages/DefaultSchoolPage.dart';
import 'package:got_space/pages/QuestionsAndAnswersPage.dart';
import 'package:got_space/pages/tabs/SchoolTab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool expand;
  int index;
  String defaultSchool;

  @override
  initState() {
    expand = false;
    index = -1;
    getSharedPrefs();
    super.initState();
  }

  getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("default")) {
      setState(() {
        defaultSchool = prefs.getString("default");
      });
    }
  }

  setSharedPrefs(String school) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("default", school);
  }

  Widget dropDown(List<String> schools) => Column(
        children: schools.map<Container>((String value) {
          return Container(
            child: FlatButton(
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor, fontSize: 17),
                ),
              ),
              onPressed: () {
                setState(() {
                  index = schools.indexOf(value);
                  expand = false;
                });
              },
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          );
        }).toList(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, List<String>>(builder: (context, state) {
      if (state == null) {
        return Scaffold(
          body: Center(
            child: Text('Could not retrieve data'),
          ),
        );
      }
      if (state.length == 0) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      int i = 0;
      if (defaultSchool != null && index == -1) {
        i = state.indexOf(defaultSchool);
      } else if(index != -1){
        i = index;
      }
      List<Widget> widgets = state.map((e) => SchoolTab(id: e)).toList();
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Padding(
                padding: EdgeInsets.only(left: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(state[i]),
                    IconButton(
                      icon: Icon(
                        expand ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Theme.of(context).backgroundColor,
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
                      child: FlatButton(
                        child: Text("Change Default School"),
                        onPressed: () async{
                          String school = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DefaultSchoolPage(
                                        schools: state,
                                      )));
                          if(state.contains(school)){
                            setSharedPrefs(school);
                          }
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: FlatButton(
                        child: Text("Q&A"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QuestionsAndAnswersPage()));
                        },
                      ),
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
              widgets[i]
            ],
          ));
    });
  }
}
