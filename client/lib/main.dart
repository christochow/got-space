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
    TextTheme _textTheme = Theme.of(context).textTheme.apply(
          bodyColor: Color.fromRGBO(0, 0, 49, 1),
          displayColor: Color.fromRGBO(0, 0, 49, 1),
        );
    return MaterialApp(
      title: 'Got Space?',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 49, 1)),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
          textTheme: ButtonTextTheme.accent,
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(secondary: Color.fromRGBO(0, 0, 49, 1)), // Text color
        ),
        appBarTheme: AppBarTheme(textTheme: _textTheme),
        backgroundColor: Color.fromRGBO(0, 0, 49, 1),
        textTheme: _textTheme,
      ),
      home: BlocProvider(
        create: (context) => MainBloc(FirebaseRepository(FirebaseClient())),
        child: MainPage(),
      ),
    );
  }
}
