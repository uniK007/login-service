part of 'authentication_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {
  final bool isLoading;

  const AuthLoadingState({required this.isLoading});
}

final class AuthSuccessState extends AuthState {
  final User user;

  const AuthSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthLogoutState extends AuthState {}

final class AuthFailureState extends AuthState {
  final String errorMessage;

  const AuthFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
