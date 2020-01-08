import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:got_space/client/FirebaseClient.dart';

class FirebaseRepository {
  FirebaseClient firebaseClient;

  FirebaseRepository(FirebaseClient client){
    firebaseClient = client;
  }

  Future<List<String>> getSchools() async {
    QuerySnapshot snapshot =  await firebaseClient.getSchools();
    var a =  snapshot.documents.map((e)=>e.documentID).toList();
    print(a);
    return a;
  }
}
