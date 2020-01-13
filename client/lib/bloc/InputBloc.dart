import 'package:bloc/bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/models/InputEvent.dart';

class InputBloc extends Bloc<InputEvent, String> {

  FirebaseRepository _firebaseRepository;

  InputBloc(FirebaseRepository repo) {
    _firebaseRepository = repo;
  }


  @override
  String get initialState => '';

  @override
  Stream<String> mapEventToState(InputEvent event) async* {
    try{
    await _firebaseRepository.addToCollection(
        event.path, {
          'rating': event.rating,
          'timestamp':DateTime.now().millisecondsSinceEpoch
        });
    yield 'sucess';
    }catch(e){
      yield 'error';
    }
  }
}
