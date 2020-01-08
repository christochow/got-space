import 'package:bloc/bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';

class MainBloc extends Bloc<String, List<String>>{

  FirebaseRepository _firebaseRepository;

  MainBloc(FirebaseRepository repo){
    _firebaseRepository = repo;
    init();
  }

  void init(){
    this.add('event');
  }

  @override
  List<String> get initialState => [];

 @override
  Stream<List<String>> mapEventToState(String event) async*{
    yield await _firebaseRepository.getSchools();
  }
}
