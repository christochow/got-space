import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';

class LibraryList extends StatefulWidget {
  LibraryList({Key key}) : super(key: key);

  @override
  _LibraryListState createState() => _LibraryListState();
}

class _LibraryListState extends State<LibraryList> {
  bool expand = false;
  String val = 'University Of Toronto';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('1');
  }
}
