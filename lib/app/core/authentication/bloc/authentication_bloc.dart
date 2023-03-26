import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cimat/app/core/models/user_model.dart';

import '../../../data/b4a/b4a_exception.dart';
import '../../../data/b4a/init_back4app.dart';
import '../../repositories/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    // on<_AuthenticationEventStatusChanged>(_onAuthenticationEventStatusChanged);
    on<AuthenticationEventInitial>(_onAuthenticationEventInitial);
    on<AuthenticationEventLoginRequested>(_onAuthenticationEventLoginRequested);
    on<AuthenticationEventLogoutRequested>(
        _onAuthenticationEventLogoutRequested);
    on<AuthenticationEventUpdateUserProfile>(
        _onAuthenticationEventUpdateUserProfile);
  }

  FutureOr<void> _onAuthenticationEventLogoutRequested(
      AuthenticationEventLogoutRequested event,
      Emitter<AuthenticationState> emit) async {
    try {
      bool logout = await _userRepository.logout();
      if (logout) {
        emit(const AuthenticationState.unauthenticated());
      }
      emit(const AuthenticationState.unauthenticated());
    } catch (_) {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  FutureOr<void> _onAuthenticationEventLoginRequested(
      AuthenticationEventLoginRequested event,
      Emitter<AuthenticationState> emit) {
    print('onAuthenticationEventReceiveUser');
    emit(AuthenticationState.authenticated(event.user));
  }

  FutureOr<void> _onAuthenticationEventInitial(AuthenticationEventInitial event,
      Emitter<AuthenticationState> emit) async {
    InitBack4app initBack4app = InitBack4app();
    try {
      bool initParse = await initBack4app.init();
      if (initParse) {
        print('+++ AuthenticationEventInitial.1');
        final user = await _userRepository.hasUserLogged();
        print('+++ AuthenticationEventInitial.2');
        if (user != null) {
          print('+++ AuthenticationEventInitial.3');
          if (user.userProfile?.isActive == true) {
            print('+++ AuthenticationEventInitial.4');
            emit(AuthenticationState.authenticated(user));
          } else {
            print('+++ AuthenticationEventInitial.5');
            emit(state.copyWith(
                status: AuthenticationStatus.unauthenticated,
                error:
                    'Sua conta ainda esta em análise. Tente login mais tarde'));
            add(AuthenticationEventLogoutRequested());
          }
          print('+++ AuthenticationEventInitial.6');
          // emit(AuthenticationState.authenticated(user));
        } else {
          print('+++ AuthenticationEventInitial.7');
          // await Future.delayed(const Duration(seconds: 2));
          emit(state.copyWith(
              status: AuthenticationStatus.unauthenticated,
              error: 'Faça login novamente'));
        }
        print('+++ AuthenticationEventInitial.8');
      }
    } on B4aException catch (e) {
      print('+++ _onAuthenticationEventInitial');
      print(e);
      emit(state.copyWith(
          status: AuthenticationStatus.databaseError, error: e.toString()));
    } catch (e) {
      print('+++ _onAuthenticationEventInitial');
      print(e);
      emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          error: 'Erro desconhecido na inicialização'));
    }
  }

  FutureOr<void> _onAuthenticationEventUpdateUserProfile(
      AuthenticationEventUpdateUserProfile event,
      Emitter<AuthenticationState> emit) {
    emit(state.copyWith(user: event.user));
  }
}
