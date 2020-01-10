import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/LibraryBloc.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/BlocState.dart';
import 'package:got_space/pages/LibraryPage.dart';

class LibraryList extends StatefulWidget {
  LibraryList({Key key, this.path}) : super(key: key);
  final String path;

  @override
  _LibraryListState createState() => _LibraryListState();
}

class _LibraryListState extends State<LibraryList> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolBloc, BlocState>(
      builder: (context, state) {
        if (state.snapshot == null) {
          return Text('Loading');
        }
        return ListView(
          shrinkWrap: true,
          children: state.subSections.map((e) {
            LibraryBloc _bloc = LibraryBloc(FirebaseRepository(FirebaseClient()),
                e.documentID, widget.path);
            return BlocProvider<LibraryBloc>(
              create: (context) => _bloc,
              child: FlatButton(
                child: Text(e.documentID + ':' + e.data['rating'].toString()),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LibraryPage(
                              libBloc: _bloc,
                              path: widget.path + '/' + e.documentID)));
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
