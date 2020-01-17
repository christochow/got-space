import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/InputBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/models/InputEvent.dart';

class InputDialog extends StatefulWidget {
  InputDialog(
      {Key key,
      this.path,
      this.formKey,
      this.height,
      this.width,
      this.rootContext})
      : super(key: key);
  final String path;
  final GlobalKey<FormState> formKey;
  final double height;
  final double width;
  final BuildContext rootContext;

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg),duration: Duration(seconds: 1),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext parentCtx) {
    return BlocProvider<InputBloc>(
        create: (context) => InputBloc(FirebaseRepository(FirebaseClient())),
        child: BlocBuilder<InputBloc, String>(
          builder: (BuildContext context, String state) {
            InputBloc _bloc = BlocProvider.of<InputBloc>(context);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.circular(24.0),),
              title: Text('Submit a rating'),
              content: Container(
                height: widget.height,
                width: widget.width,
                child: ListView(
                  children: <Widget>[
                    Text('Enter a number from 0 to 10\n0 means there ' +
                        'is no one in the area.\n10 means the area ' +
                        'is full'),
                    Form(
                      key: widget.formKey,
                      child: TextFormField(
                          initialValue: '0',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field must not be empty!';
                            }
                            var n = num.parse(value);
                            if (n < 0 || n > 10) {
                              return 'Input must be between 0 to 10!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            List<String> pathList = widget.path.split('/');
                            pathList[0] = 'records';
                            pathList.add('records');
                            String path = pathList.join('/');
                            _bloc.add(InputEvent(path, num.parse(value)));
                            Navigator.of(parentCtx).pop();
                            _bloc.asBroadcastStream().listen((String state) {
                              if (state != '') {
                                _bloc.close();
                                widget.formKey.currentState?.reset();
                                _displaySnackBar(widget.rootContext, state);
                              }
                            });
                          },
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          decoration: InputDecoration(),
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ]),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    child: new Text('Cancel'),
                    onPressed: () {
                      _bloc.close();
                      widget.formKey.currentState.reset();
                      Navigator.of(parentCtx).pop();
                    }),
                FlatButton(
                  child: new Text('Submit'),
                  onPressed: () {
                    if (widget.formKey.currentState.validate()) {
                      widget.formKey.currentState.save();
                    }
                  },
                )
              ],
            );
          },
        ));
  }
}
