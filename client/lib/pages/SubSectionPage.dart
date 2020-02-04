import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/bloc/FloorBloc.dart';
import 'package:got_space/models/BlocState.dart';
import 'package:got_space/widgets/AppBarWidget.dart';
import 'package:got_space/widgets/InputDialog.dart';
import 'package:got_space/widgets/RatingWidget.dart';

class SubSectionPage extends StatefulWidget {
  SubSectionPage({Key key, this.floorBloc, this.id}) : super(key: key);
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
            height: height * 0.25,
            width: width * 0.75,
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
        if (state.hasError) {
          return Center(
            child: Text('Something went wrong, please try again'),
          );
        }
        return Scaffold(
            appBar: AppBarWidget(
              header: snapshot.documentID,
            ),
            body: Builder(
                builder: (context) => ListView(
                      children: <Widget>[
                        Center(
                            child: RatingWidget(
                          e: snapshot,
                        )),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: ButtonTheme(
                              buttonColor: Theme.of(context).primaryColor,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color:
                                            Theme.of(context).backgroundColor)),
                                child: Text(
                                  'Submit a rating',
                                  style: TextStyle(
                                      color: Theme.of(context).backgroundColor),
                                ),
                                onPressed: () => _showInputDialog(
                                    snapshot.reference.path, context),
                              )),
                        ),
                      ],
                    )));
      },
    );
  }
}
