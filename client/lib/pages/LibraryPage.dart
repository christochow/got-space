import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/FloorBloc.dart';
import 'package:got_space/bloc/LibraryBloc.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/bloc/SubSectionBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/BlocState.dart';
import 'package:got_space/pages/FloorPage.dart';

class LibraryPage extends StatefulWidget {
  LibraryPage({Key key, this.libBloc, this.path}) : super(key: key);
  final LibraryBloc libBloc;
  final String path;

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Stream<BlocState> _stream;

  @override
  void initState() {
    _stream = widget.libBloc.asBroadcastStream();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot<BlocState> state) {
        if (state.data == null) {
          return Center(
            child: Text('Loading'),
          );
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(state.data.snapshot.documentID),
            ),
            body: ListView(
              children: [
                [
                  Text('Rating: ' +
                      state.data.snapshot.data['rating'].toString())
                ],
                state.data.subSections.map((e) {
                  FloorBloc _floorBloc = FloorBloc(
                      FirebaseRepository(FirebaseClient()),
                      e.documentID,
                      widget.path);
                  return BlocProvider<FloorBloc>(
                    create: (context) => _floorBloc,
                    child: FlatButton(
                      child: Text(e.documentID + ':' + e.data['rating']),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FloorPage(
                                      floorBloc: _floorBloc,
                                  path: widget.path + '/' + e.documentID + '/subsections',
                                    )));
                      },
                    ),
                  );
                }).toList()
              ].expand((e) => e).toList(),
            ));
      },
    );
  }
}
