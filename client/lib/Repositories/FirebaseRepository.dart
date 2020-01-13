import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:got_space/client/FirebaseClient.dart';

class FirebaseRepository {
  FirebaseClient _firebaseClient;

  FirebaseRepository(FirebaseClient client) {
    _firebaseClient = client;
  }

  Future<List<String>> getSchools() async {
    try {
      QuerySnapshot snapshot = await _firebaseClient.getSchools();
      return snapshot.documents.map((e) => e.documentID).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<DocumentSnapshot> getDataFromPath(String path, String id) {
    return _firebaseClient.getSchoolRatingReference(path, id);
  }

  Stream<QuerySnapshot> getCollectionFromPath(String path, String id) {
    return _firebaseClient.getSubSections(path + '/' + id);
  }

  Future<DocumentReference> addToCollection(String path, Map<String, dynamic> data){
    return _firebaseClient.addToCollection(path, data);
  }
}
