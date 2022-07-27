part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginEditEvent extends LoginEvent {
  String key;
  LoginEditEvent(this.key);
}

class LoginButtonTappedEvent extends LoginEvent {}
