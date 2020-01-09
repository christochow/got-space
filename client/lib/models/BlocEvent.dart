import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:got_space/models/BlocEventType.dart';

class BlocEvent {
    BlocEventType _type;
    DocumentSnapshot _snapshot;

    BlocEvent(BlocEventType type, DocumentSnapshot snapshot){
      _type = type;
      _snapshot = snapshot;
    }

    BlocEventType get type => _type;
    DocumentSnapshot get snapshot => _snapshot;
}
