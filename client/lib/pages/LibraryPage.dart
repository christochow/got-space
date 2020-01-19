import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/FloorBloc.dart';
import 'package:got_space/bloc/LibraryBloc.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/BlocState.dart';
import 'package:got_space/pages/FloorPage.dart';
import 'package:got_space/widgets/AppBarWidget.dart';
import 'package:got_space/widgets/Heading.dart';
import 'package:got_space/widgets/RatingWidget.dart';
import 'package:got_space/widgets/RowWidget.dart';

class LibraryPage extends StatefulWidget {
  LibraryPage({Key key, this.libBloc, this.path, this.schoolBloc, this.id})
      : super(key: key);
  final SchoolBloc schoolBloc;
  final LibraryBloc libBloc;
  final String path;
  final String id;

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.libBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolBloc, BlocState>(
        bloc: widget.schoolBloc,
        builder: (BuildContext context, BlocState parentState) =>
            BlocBuilder<LibraryBloc, BlocState>(
              bloc: widget.libBloc,
              builder: (BuildContext context, BlocState state) {
                DocumentSnapshot snapshot = parentState.subSections
                    .firstWhere((e) => e.documentID == widget.id);
                if (snapshot == null) {
                  return Center(
                    child: Text('Loading'),
                  );
                }
                return Scaffold(
                    appBar: AppBarWidget(header: snapshot.documentID,),
                    body: ListView(
                      children: [
                        [
                          RatingWidget(e: snapshot),
                          Divider(
                            color: Theme.of(context).backgroundColor,
                          ),
                          Heading(
                            header: 'Floors',
                          )
                        ],
                        state.subSections.map((e) {
                          FloorBloc _floorBloc = FloorBloc(
                              FirebaseRepository(FirebaseClient()),
                              e.documentID,
                              widget.path,
                              e.data['hasChild']);
                          return BlocProvider<FloorBloc>(
                              create: (context) => _floorBloc,
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
                                            builder: (context) => FloorPage(
                                                  floorBloc: _floorBloc,
                                                  libraryBloc: widget.libBloc,
                                                  id: e.documentID,
                                                  path: widget.path +
                                                      '/' +
                                                      e.documentID +
                                                      '/subsections',
                                                )));
                                  },
                                ),
                              ));
                        }).toList()
                      ].expand((e) => e).toList(),
                    ));
              },
            ));
  }
}
