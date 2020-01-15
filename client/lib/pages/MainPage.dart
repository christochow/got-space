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
    setState(() {
      defaultSchool = school;
    });
  }

  goToQAndA(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => QuestionsAndAnswersPage()));
  }

  goToDefaultSchool(context, state) async {
    String school = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DefaultSchoolPage(
                  schools: state,
                  school: defaultSchool == null ? state[0] : defaultSchool,
                )));
    if (state.contains(school) && school != defaultSchool) {
      setSharedPrefs(school);
    }
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
      } else if (index != -1) {
        i = index;
      } else if (defaultSchool == null) {
        setSharedPrefs(state[0]);
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
                onSelected: (option) {
                  if (option.toString() == 'Q&A') {
                    goToQAndA(context);
                  } else {
                    goToDefaultSchool(context, state);
                  }
                },
                child: Padding(
                  child: Icon(Icons.more_horiz),
                  padding: EdgeInsets.only(right: 10),
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'Change Default School',
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Change Default School')),
                    ),
                    PopupMenuItem(
                      value: 'Q&A',
                      child: Align(
                          alignment: Alignment.centerLeft, child: Text('Q&A')),
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
