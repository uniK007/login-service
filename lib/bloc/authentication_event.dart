part of 'authentication_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticateEvent extends AuthEvent {
  final String email;
  final String password;
  final UserType? userType;

  const AuthenticateEvent({
    required this.email,
    required this.password,
    this.userType = UserType.guest,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthSuccessEvent extends AuthEvent {
  final User user;

  const AuthSuccessEvent({required this.user});
}

class AuthLogOutEvent extends AuthEvent {}
