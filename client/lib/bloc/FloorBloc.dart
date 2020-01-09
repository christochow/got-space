import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:got_space/Repositories/FirebaseRepository.dart';
import 'package:got_space/models/BlocEvent.dart';
import 'package:got_space/models/BlocEventType.dart';
import 'package:got_space/models/BlocState.dart';

class FloorBloc extends Bloc<BlocEvent, BlocState>{

  FirebaseRepository _firebaseRepository;
  StreamSubscription _subscription;
  String _id;

  FloorBloc(FirebaseRepository repo, String id){
    _firebaseRepository = repo;
    _id = id;
    _subscription = _firebaseRepository.getDataFromPath(_id).listen((snapshot){
      this.add(BlocEvent(BlocEventType.ADD, snapshot));
    });
  }

  StreamSubscription get subscription => _subscription;

  @override
  BlocState get initialState => null;

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async*{
    if(event.type==BlocEventType.ADD){
      yield BlocState(event.snapshot);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

