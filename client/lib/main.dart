import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/bloc/MainBloc.dart';
import 'package:got_space/client/FirebaseClient.dart';
import 'package:got_space/pages/MainPage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Got Space?',
      theme:
          ThemeData(primaryColor: Colors.indigo, backgroundColor: Colors.white),
      home: BlocProvider(
        create: (context) => MainBloc(FirebaseRepository(FirebaseClient())),
        child: MainPage(),
      ),
    );
  }
}
