import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:got_space/models/BlocEventType.dart';

class BlocEvent {
  BlocEventType _type;
  DocumentSnapshot _snapshot;
  List<DocumentSnapshot> _subSections;

  BlocEvent(BlocEventType type, DocumentSnapshot snapshot,
      List<DocumentSnapshot> list) {
    _type = type;
    _snapshot = snapshot;
    _subSections = list;
  }

  BlocEventType get type => _type;

  DocumentSnapshot get snapshot => _snapshot;

  List<DocumentSnapshot> get subSections => _subSections;
}
