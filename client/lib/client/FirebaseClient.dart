import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  Future<QuerySnapshot> getSchools(){
    return Firestore.instance.collection('schools').getDocuments();
  }

   Stream<DocumentSnapshot> getSchoolRatingReference(String id){
    return Firestore.instance.collection('ratings').document(id).snapshots();
  }
}
