import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/pages/tabs/LibraryList.dart';

class SchoolTab extends StatefulWidget {
  SchoolTab({Key key}) : super(key: key);

  @override
  _SchoolTabState createState() => _SchoolTabState();
}

class _SchoolTabState extends State<SchoolTab> {
  bool expand = false;
  String val = 'University Of Toronto';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SchoolBloc(FirebaseRepository(FirebaseClient())),
      child: LibraryList(),
    );
  }
}
