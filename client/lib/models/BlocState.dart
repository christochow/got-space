import 'package:cloud_firestore/cloud_firestore.dart';

class BlocState {
  DocumentSnapshot _snapshot;
  List<DocumentSnapshot> _subSections;
  bool _hasError;

  BlocState(DocumentSnapshot snapshot, List<DocumentSnapshot> subSections,
      bool hasError) {
    _snapshot = snapshot;
    _subSections = subSections;
    _hasError = hasError;
  }

  DocumentSnapshot get snapshot => _snapshot;

  List<DocumentSnapshot> get subSections => _subSections;

  bool get hasError => _hasError;
}
