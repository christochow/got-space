import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/FloorBloc.dart';
import 'package:got_space/bloc/InputBloc.dart';
import 'package:got_space/bloc/LibraryBloc.dart';
import 'package:got_space/bloc/SubSectionBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/BlocState.dart';
import 'package:got_space/models/InputEvent.dart';
import 'package:got_space/pages/SubSectionPage.dart';
import 'package:got_space/widgets/AppBarWidget.dart';
import 'package:got_space/widgets/Heading.dart';
import 'package:got_space/widgets/InputDialog.dart';
import 'package:got_space/widgets/RatingWidget.dart';
import 'package:got_space/widgets/RowWidget.dart';

class FloorPage extends StatefulWidget {
  FloorPage({Key key, this.floorBloc, this.path, this.libraryBloc, this.id})
      : super(key: key);
  final FloorBloc floorBloc;
  final LibraryBloc libraryBloc;
  final String path;
  final String id;

  @override
  _FloorPageState createState() => _FloorPageState();
}

class _FloorPageState extends State<FloorPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.floorBloc.close();
    super.dispose();
  }

  _showInputDialog(String path, BuildContext rootContext) {
    Size size = MediaQuery.of(rootContext).size;
    double height = size.height;
    double width = size.width;
    return showDialog(
        context: context,
        builder: (parentCtx) {
          return InputDialog(
            path: path,
            formKey: _formKey,
            height: height * 0.25,
            width: width * 0.75,
            rootContext: rootContext,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, BlocState>(
      bloc: widget.libraryBloc,
      builder: (BuildContext context, BlocState parentState) =>
          BlocBuilder<FloorBloc, BlocState>(
        bloc: widget.floorBloc,
        builder: (BuildContext context, BlocState state) {
          DocumentSnapshot snapshot = parentState.subSections
              .firstWhere((e) => e.documentID == widget.id);
          if (snapshot == null) {
            return Center(
              child: Text('Loading'),
            );
          }
          if(state.hasError){
            return Center(
              child: Text('Something went wrong, please try again'),
            );
          }
          return Scaffold(
              appBar: AppBarWidget(header: snapshot.documentID,),
              body: Builder(
                builder: (context) => ListView(
                  children: [
                    [
                      RatingWidget(e: snapshot),
                      Divider(
                        color: Theme.of(context).backgroundColor,
                      ),
                      Visibility(
                        visible: !snapshot.data['hasChild'],
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: ButtonTheme(
                                buttonColor: Theme.of(context).primaryColor,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .backgroundColor)),
                                  child: Text(
                                    'Submit a rating',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).backgroundColor),
                                  ),
                                  onPressed: () {
                                    _showInputDialog(
                                        snapshot.reference.path, context);
                                  },
                                ))),
                      ),
                      Visibility(
                          visible: snapshot.data['hasChild'],
                          child: Heading(
                            header: 'Subsections',
                          )),
                    ],
                    state.subSections.map((e) {
                      SubSectionBloc _bloc = SubSectionBloc(
                          FirebaseRepository(FirebaseClient()),
                          e.documentID,
                          widget.path);
                      return BlocProvider<SubSectionBloc>(
                          create: (context) => _bloc,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.4,
                                        color: Theme.of(context)
                                            .backgroundColor))),
                            child: FlatButton(
                              child: RowWidget(e: e),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubSectionPage(
                                              subSecBloc: _bloc,
                                              floorBloc: widget.floorBloc,
                                              id: e.documentID,
                                            )));
                              },
                            ),
                          ));
                    }).toList()
                  ].expand((e) => e).toList(),
                ),
              ));
        },
      ),
    );
  }
}
