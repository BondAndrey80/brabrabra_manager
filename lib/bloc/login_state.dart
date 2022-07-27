part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginEditedState extends LoginState {}

//process ask for rest api
class LoginingState extends LoginState {}

class LoginedState extends LoginState {
  Manager manager;
  LoginedState({required this.manager});
}
