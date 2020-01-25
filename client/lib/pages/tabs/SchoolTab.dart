import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/widgets/LibraryList.dart';

class SchoolTab extends StatefulWidget {
  SchoolTab({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _SchoolTabState createState() => _SchoolTabState();
}

class _SchoolTabState extends State<SchoolTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolBloc>(
      create: (BuildContext context) => SchoolBloc(
          FirebaseRepository(FirebaseClient()), widget.id, 'ratings'),
      child: LibraryList(path: 'ratings/' + widget.id + '/libraries'),
    );
  }
}
