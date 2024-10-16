import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_service/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthenticationBloc({required this.authService}) : super(AuthInitialState()) {
    on<AuthenticateEvent>((event, emit) async {
      emit(const AuthLoadingState(isLoading: true));

      try {
        final user = await authService.authenticate(
          email: event.email,
          password: event.password,
          userType: event.userType!,
        );

        if (user != null) {
          emit(AuthSuccessState(user: user));
        }
      } catch (e) {
        emit(AuthFailureState(errorMessage: e.toString()));
        debugPrint(e.toString());
      }

      emit(const AuthLoadingState(isLoading: false));
    });

    on<AuthLogOutEvent>((event, emit) async {
      emit(const AuthLoadingState(isLoading: true));
      try {
        await authService.logOut();
        emit(AuthLogoutState());
        emit(AuthInitialState());
      } catch (e) {
        debugPrint(e.toString());
      }

      emit(const AuthLoadingState(isLoading: false));
    });
  }
}
