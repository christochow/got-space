import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/models/BlocEvent.dart';
import 'package:got_space/models/BlocEventType.dart';
import 'package:got_space/models/BlocState.dart';

class FloorBloc extends Bloc<BlocEvent, BlocState> {
  FirebaseRepository _firebaseRepository;
  StreamSubscription _subscription2;

  FloorBloc(FirebaseRepository repo, String id, String path, bool hasChild) {
    _firebaseRepository = repo;
    if (hasChild == true) {
      _subscribeToSub(path, id);
    }
  }

  void _subscribeToSub(String path, String id) {
    _subscription2 = _firebaseRepository
        .getCollectionFromPath(path, id + '/subsections')
        .listen((snapshot) {
      this.add(BlocEvent(BlocEventType.SUB, null, snapshot.documents, false));
    });
    _subscription2
        .onError((e) => this.add(BlocEvent(BlocEventType.SUB, null, [], true)));
  }

  @override
  BlocState get initialState => BlocState(null, [], false);

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event.type == BlocEventType.ADD) {
      yield BlocState(event.snapshot, state.subSections, event.hasError);
    } else if (event.type == BlocEventType.SUB) {
      yield BlocState(state.snapshot, event.subSections, event.hasError);
    }
  }

  @override
  Future<void> close() {
    _subscription2?.cancel();
    return super.close();
  }
}
