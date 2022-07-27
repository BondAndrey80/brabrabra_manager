import 'package:brabrabra_manager/models/manager.dart';
import 'package:brabrabra_manager/services/manager_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ManagerRepository managerRepository;
  String key = '';
  LoginBloc({required this.managerRepository}) : super(LoginInitial()) {
    on<LoginEditEvent>(
      (event, emit) {
        key = event.key;
        emit(LoginEditedState());
      },
    );
    on<LoginButtonTappedEvent>(
      (event, emit) async {
        emit(LoginingState());
        var manager = await managerRepository.getManagerByKey(key);
        emit(LoginedState(manager: manager));
      },
    );
  }
}
