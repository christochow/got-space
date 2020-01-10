import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:got_space/client/FirebaseClient.dart';

class FirebaseRepository {
  FirebaseClient firebaseClient;

  FirebaseRepository(FirebaseClient client) {
    firebaseClient = client;
  }

  Future<List<String>> getSchools() async {
    try {
      QuerySnapshot snapshot = await firebaseClient.getSchools();
      return snapshot.documents.map((e) => e.documentID).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<DocumentSnapshot> getDataFromPath(String path, String id) {
    return firebaseClient.getSchoolRatingReference(path, id);
  }

  Stream<QuerySnapshot> getCollectionFromPath(String path, String id) {
    return firebaseClient.getSubSections(path + '/' + id);
  }
}
