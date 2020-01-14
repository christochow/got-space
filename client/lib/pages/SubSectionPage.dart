import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/FloorBloc.dart';
import 'package:got_space/bloc/InputBloc.dart';
import 'package:got_space/bloc/SubSectionBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/BlocState.dart';
import 'package:got_space/models/InputEvent.dart';
import 'package:got_space/widgets/InputDialog.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.subSecBloc.close();
    super.dispose();
  }

  _showInputDialog(String path, BuildContext rootContext) {
    Size size = MediaQuery.of(rootContext).size;
    double height = size.height;
    double width = size.width;
    return showDialog(
        context: context,
        builder: (parentCtx) {
          return InputDialog(
            path: path,
            formKey: _formKey,
            height: height*0.25,
            width: width*0.75,
            rootContext: rootContext,
          );
        });
  }

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
            body: Builder(
                builder: (context) => ListView(
                      children: <Widget>[
                        Center(
                          child: Text('Rating: ' +
                              num.parse(snapshot.data['rating'].toString())
                                  .toStringAsFixed(1)),
                        ),
                        FlatButton(
                          child: Text('Submit a rating'),
                          onPressed: () => _showInputDialog(
                              snapshot.reference.path, context),
                        )
                      ],
                    )));
      },
    );
  }
}
