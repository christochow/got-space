import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/FloorBloc.dart';
import 'package:got_space/bloc/LibraryBloc.dart';
import 'package:got_space/bloc/SubSectionBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/BlocState.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.floorBloc.close();
    super.dispose();
  }

  _showInputDialog() {}

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
              body: ListView(
                children: [
                  [
                    Center(
                      child:
                          Text('Rating: ' + snapshot.data['rating'].toString()),
                    )
                  ],
                  snapshot.data['hasChild'] == false
                      ? [
                          FlatButton(
                            child: Text('Submit a rating'),
                            onPressed: _showInputDialog,
                          )
                        ]
                      : [],
                  state.subSections.map((e) {
                    SubSectionBloc _bloc = SubSectionBloc(
                        FirebaseRepository(FirebaseClient()),
                        e.documentID,
                        widget.path);
                    return BlocProvider<SubSectionBloc>(
                      create: (context) => _bloc,
                      child: FlatButton(
                        child: Text(
                            e.documentID + ':' + e.data['rating'].toString()),
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
              ));
        },
      ),
    );
  }
}
