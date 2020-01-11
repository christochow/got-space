import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/models/BlocEvent.dart';
import 'package:got_space/models/BlocEventType.dart';
import 'package:got_space/models/BlocState.dart';

class SubSectionBloc extends Bloc<BlocEvent, BlocState> {
  FirebaseRepository _firebaseRepository;
  StreamSubscription _subscription;
  StreamSubscription _subscription2;

  SubSectionBloc(FirebaseRepository repo, String id, String path) {
    _firebaseRepository = repo;
    _subscription =
        _firebaseRepository.getDataFromPath(path, id).listen((snapshot) {
      this.add(BlocEvent(BlocEventType.ADD, snapshot, null));
      if(snapshot.data['hasChildren']==true){
        _subscribetoSub(path, id);
      }
    });
  }

  void _subscribetoSub(String path, String id){
    _subscription2 = _firebaseRepository
        .getCollectionFromPath(path, id + '/subsections')
        .listen((snapshot) {
      this.add(BlocEvent(BlocEventType.SUB, null, snapshot.documents));
    });
  }

  StreamSubscription get subscription => _subscription;

  @override
  BlocState get initialState => BlocState(null, []);

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event.type == BlocEventType.ADD) {
      yield BlocState(event.snapshot, state.subSections);
    } else if (event.type == BlocEventType.SUB) {
      yield BlocState(state.snapshot, event.subSections);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription2?.cancel();
    return super.close();
  }
}
