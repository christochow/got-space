import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  Future<QuerySnapshot> getSchools() {
    return Firestore.instance.collection('schools').getDocuments();
  }

  Stream<DocumentSnapshot> getSchoolRatingReference(String path, String id) {
    return Firestore.instance.collection(path).document(id).snapshots();
  }

  Stream<QuerySnapshot> getSubSections(String id) {
    return Firestore.instance.collection(id).snapshots();
  }

  Future<DocumentReference> addToCollection(String path, Map<String, dynamic> data){
    return Firestore.instance.collection(path).add(data);
  }
}
