import 'package:cloud_firestore/cloud_firestore.dart';

class BlocState{
  DocumentSnapshot _snapshot;

  BlocState(DocumentSnapshot snapshot){
    _snapshot = snapshot;
  }

  DocumentSnapshot get snapshot => _snapshot;
}
