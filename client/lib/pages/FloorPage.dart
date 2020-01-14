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

  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _showInputDialog(String path, BuildContext rootContext) {
    return showDialog(
        context: context,
        builder: (parentCtx) {
          return BlocProvider<InputBloc>(
              create: (context) =>
                  InputBloc(FirebaseRepository(FirebaseClient())),
              child: BlocBuilder<InputBloc, String>(
                builder: (BuildContext context, String state) {
                  InputBloc _bloc = BlocProvider.of<InputBloc>(context);
                  return AlertDialog(
                    title: Text('Submit a rating'),
                    content: Form(
                      key: _formKey,
                      child: TextFormField(
                          initialValue: '1',
                          validator: (value) {
                            if(value.isEmpty){
                              return 'Field must not be empty!';
                            }
                            var n = num.parse(value);
                            if(n<1 || n>10){
                              return 'Input must be between 1 to 10!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _bloc.add(InputEvent(path, num.parse(value)));
                            Navigator.of(parentCtx).pop();
                            _bloc.asBroadcastStream().listen((String state) {
                              if(state!=''){
                                _bloc.close();
                                _formKey.currentState?.reset();
                                _displaySnackBar(rootContext, state);
                              }
                            });
                          },
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          decoration: InputDecoration(),
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ]),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          child: new Text('Cancel'),
                          onPressed: () {
                            _bloc.close();
                            _formKey.currentState.reset();
                            Navigator.of(parentCtx).pop();
                          }),
                      FlatButton(
                        child: new Text('Submit'),
                        onPressed: () {
                          List<String> pathList = path.split('/');
                          pathList[0] = 'records';
                          pathList.add('records');
                          path = pathList.join('/');
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                          }
                        },
                      )
                    ],
                  );
                },
              ));
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
          return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.documentID),
              ),
              body: Builder(
                builder: (context) => ListView(
                  children: [
                    [
                      Center(
                        child: Text('Rating: ' +
                            num.parse(snapshot.data['rating'].toString())
                                .toStringAsFixed(1)),
                      ),
                      Visibility(
                        visible: !snapshot.data['hasChild'],
                        child: FlatButton(
                          child: Text('Submit a rating'),
                          onPressed: () {
                            _showInputDialog(snapshot.reference.path, context);
                          },
                        ),
                      )
                    ],
                    state.subSections.map((e) {
                      SubSectionBloc _bloc = SubSectionBloc(
                          FirebaseRepository(FirebaseClient()),
                          e.documentID,
                          widget.path);
                      return BlocProvider<SubSectionBloc>(
                        create: (context) => _bloc,
                        child: FlatButton(
                          child: Text(e.documentID +
                              ':' +
                              num.parse(e.data['rating'].toString())
                                  .toStringAsFixed(1)),
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
                      );
                    }).toList()
                  ].expand((e) => e).toList(),
                ),
              ));
        },
      ),
    );
  }
}
