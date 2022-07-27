import 'package:brabrabra_manager/bloc/login_bloc.dart';
import 'package:brabrabra_manager/common/theme.dart';
import 'package:brabrabra_manager/services/manager_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/manager.dart';
import 'catalog.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(managerRepository: ManagerRepository()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: brabrabraBackgroundColor,
        appBar: AppBar(
          title: const Text('brabrabra'),
          centerTitle: true,
        ),
        body: Body(),
      ),
    );
  }
}

// ignore: must_be_immutable
class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  Manager manager = Manager();
  bool _showProgressBar = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previusState, currentState) {
        return previusState != currentState;
      },
      listener: ((context, state) {
        if (state is LoginedState) {
          manager = state.manager;

          final snackBar = SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(
              (manager.isFired)
                  ? 'Не вдалося авторизуватися!'
                  : 'Приввіт!\n${manager.name}',
              textAlign: TextAlign.center,
            ),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          if (!manager.isFired) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CatalogView(
                  manager: manager,
                ),
              ),
            );
          }
        }

        _showProgressBar = (state is LoginingState);
      }),
      buildWhen: (previusState, currentState) {
        return previusState != currentState;
      },
      builder: (context, state) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome brabrabra :)',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                  ),
                  obscureText: true,
                  onChanged: (String? value) {
                    BlocProvider.of<LoginBloc>(context)
                        .add(LoginEditEvent(value.toString()));
                  },
                  onFieldSubmitted: (String? value) {
                    BlocProvider.of<LoginBloc>(context)
                        .add(LoginButtonTappedEvent());
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context)
                            .add(LoginButtonTappedEvent());
                      },
                      child: const Text("АВТОРИЗАЦІЯ"),
                    ),
                  ],
                ),
                if (_showProgressBar) const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
