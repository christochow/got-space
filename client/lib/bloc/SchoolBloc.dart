import 'package:bloc/bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';

class SchoolBloc extends Bloc<String, String>{

  FirebaseRepository _firebaseRepository;

  SchoolBloc(FirebaseRepository repo){
    _firebaseRepository = repo;
  }

  @override
  String get initialState => '';

  @override
  Stream<String> mapEventToState(String event) async*{
    yield 'null';
  }
}
