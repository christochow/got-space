import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:got_space/models/BlocEventType.dart';

class BlocEvent {
  BlocEventType _type;
  DocumentSnapshot _snapshot;
  List<DocumentSnapshot> _subSections;
  bool _hasError;

  BlocEvent(BlocEventType type, DocumentSnapshot snapshot,
      List<DocumentSnapshot> list, bool hasError) {
    _type = type;
    _snapshot = snapshot;
    _subSections = list;
    _hasError = hasError;
  }

  BlocEventType get type => _type;

  DocumentSnapshot get snapshot => _snapshot;

  List<DocumentSnapshot> get subSections => _subSections;

  bool get hasError => _hasError;
}
