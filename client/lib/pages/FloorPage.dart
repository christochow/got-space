import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/LibraryBloc.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/bloc/SubSectionBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/BlocState.dart';

class FloorPage extends StatefulWidget {
  FloorPage({Key key, this.subSecBloc, this.path}) : super(key: key);
  final SubSectionBloc subSecBloc;
  final String path;

  @override
  _FloorPageState createState() => _FloorPageState();
}

class _FloorPageState extends State<FloorPage> {
  Stream<BlocState> _stream;

  @override
  void initState() {
    _stream = widget.subSecBloc.asBroadcastStream();
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
                  return BlocProvider<SubSectionBloc>(
                    create: (context) =>
                        SubSectionBloc(
                            FirebaseRepository(FirebaseClient()),
                            e.documentID,
                            'widget.path' + '/floors/'),
                    child: FlatButton(
                      child: Text(e.documentID + ':' + e.data['rating']),
                      onPressed: () {
//                        Navigator.push(context,
//                            MaterialPageRoute(
//                                builder: (context) => ()));
                      },
                    ),
                  );
                }).toList()
              ].expand((e)=>e).toList(),
            ));
      },
    );
  }
}
