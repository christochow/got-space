import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/LibraryBloc.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/BlocState.dart';
import 'package:got_space/pages/LibraryPage.dart';
import 'package:got_space/widgets/Heading.dart';
import 'package:got_space/widgets/RowWidget.dart';

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
  Widget build(BuildContext rootContext) {
    return BlocBuilder<SchoolBloc, BlocState>(
      builder: (context, state) {
        if (state.snapshot == null) {
          return Center(
            child: Text('Loading'),
          );
        }
        if (state.hasError) {
          return Center(
            child: Text('Something went wrong, please try again'),
          );
        }
        return ListView(
            shrinkWrap: true,
            children: [
              [
                Heading(
                  header: 'Library crowdedness ratings',
                )
              ],
              state.subSections.map((e) {
                LibraryBloc _bloc = LibraryBloc(
                    FirebaseRepository(FirebaseClient()),
                    e.documentID,
                    widget.path,
                    e.data['hasChild']);
                return BlocProvider<LibraryBloc>(
                  create: (context) => _bloc,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 0.4,
                                color: Theme.of(context).backgroundColor))),
                    child: FlatButton(
                      child: RowWidget(e: e),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LibraryPage(
                                    libBloc: _bloc,
                                    schoolBloc: BlocProvider.of<SchoolBloc>(
                                        rootContext),
                                    id: e.documentID,
                                    path: widget.path +
                                        '/' +
                                        e.documentID +
                                        '/floors')));
                      },
                    ),
                  ),
                );
              }).toList(),
            ].expand((e) => e).toList());
      },
    );
  }
}
