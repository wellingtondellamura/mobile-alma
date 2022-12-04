import 'dart:async';

import 'package:alma/src/models/models.dart';
import 'package:alma/src/services/application_service.dart';
import 'package:alma/src/services/user_service.dart';
import 'package:alma/src/utils/shared_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_event.dart';
part 'application_state.dart';
part 'application_bloc.freezed.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc({
    required this.applicationService,
    required this.userService,
  }) : super(ApplicationState()) {
    on<ApplicationEvent>(_onEvent);
  }

  final ApplicationService applicationService;
  final UserService userService;

  int currentBlockIndex = 0;

  Future<void> _onEvent(ApplicationEvent event, Emitter<ApplicationState> emit) async {
    if (event is Initialise) {
      await _mapInitialiseToState(event, emit);
    } else if (event is Fetch) {
      await _mapFetchToState(event, emit);
    } else if (event is Logout) {
      userService.logout();
    }
  }

  Future<void> _mapInitialiseToState(Initialise event, Emitter<ApplicationState> emit) async {
    final hasToken = await SharedPref().constain('token');
    if (!hasToken) {
      emit(state.copyWith(isInitialised: hasToken));
      return;
    }

    final currentUser = userService.getCurrentUser();
    final block = await applicationService.fetchClasses(currentUser.id!, currentBlockIndex);

    emit(state.copyWith(isInitialised: hasToken, currentUser: currentUser, currentBlock: block));
  }

  Future<void> _mapFetchToState(Fetch event, Emitter<ApplicationState> emit) async {
    final block = await applicationService.fetchClasses(event.userId, currentBlockIndex);
    emit(state.copyWith(currentBlock: block));
  }
}
