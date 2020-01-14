import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/bloc/FloorBloc.dart';
import 'package:got_space/bloc/SubSectionBloc.dart';
import 'package:got_space/models/BlocState.dart';

class SubSectionPage extends StatefulWidget {
  SubSectionPage({Key key, this.subSecBloc, this.floorBloc, this.id})
      : super(key: key);
  final SubSectionBloc subSecBloc;
  final FloorBloc floorBloc;
  final String id;

  @override
  _SubSectionPageState createState() => _SubSectionPageState();
}

class _SubSectionPageState extends State<SubSectionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.subSecBloc.close();
    super.dispose();
  }

  _showInputDialog() {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloorBloc, BlocState>(
      bloc: widget.floorBloc,
      builder: (BuildContext context, BlocState state) {
        DocumentSnapshot snapshot =
            state.subSections.firstWhere((e) => e.documentID == widget.id);
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
              children: <Widget>[
                Center(
                  child: Text('Rating: ' +
                      num.parse(snapshot.data['rating'].toString())
                          .toStringAsFixed(1)),
                ),
                FlatButton(
                  child: Text('Submit a rating'),
                  onPressed: _showInputDialog,
                )
              ],
            ));
      },
    );
  }
}
