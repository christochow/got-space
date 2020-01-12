import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/models/BlocEvent.dart';
import 'package:got_space/models/BlocEventType.dart';
import 'package:got_space/models/BlocState.dart';

class SubSectionBloc extends Bloc<BlocEvent, BlocState> {
  FirebaseRepository _firebaseRepository;

  SubSectionBloc(FirebaseRepository repo, String id, String path) {
    _firebaseRepository = repo;
  }


  @override
  BlocState get initialState => BlocState(null, []);

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event.type == BlocEventType.ADD) {
      yield BlocState(event.snapshot, state.subSections);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
