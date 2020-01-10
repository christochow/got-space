import 'package:cloud_firestore/cloud_firestore.dart';

class BlocState {
  DocumentSnapshot _snapshot;
  List<DocumentSnapshot> _subSections;

  BlocState(DocumentSnapshot snapshot, List<DocumentSnapshot> subSections) {
    _snapshot = snapshot;
    _subSections = subSections;
  }

  DocumentSnapshot get snapshot => _snapshot;

  List<DocumentSnapshot> get subSections => _subSections;
}
