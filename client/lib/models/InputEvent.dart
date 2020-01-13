import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:got_space/models/BlocEventType.dart';

class InputEvent {
  String _path;
  int _rating;

  InputEvent(String path, int rating) {
    _path = path;
    _rating = rating;
  }

  String get path => _path;

  int get rating => _rating;
}
