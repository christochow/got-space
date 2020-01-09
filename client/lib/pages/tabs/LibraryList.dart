import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/bloc/SchoolBloc.dart';
import 'package:got_space/models/BlocState.dart';

class LibraryList extends StatefulWidget {
  LibraryList({Key key}) : super(key: key);

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
      builder: (context, state){
        if(state.snapshot==null){
          return Text('Loading');
        }
        return Text(state.snapshot.data['rating'].toString());
      },
    );
  }
}
