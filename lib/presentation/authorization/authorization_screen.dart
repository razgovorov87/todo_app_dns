import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/domain/bloc/authorization/authorization_bloc.dart';

import '../design/custom_text_field.dart';

@RoutePage()
class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthorizationBloc, AuthorizationState>(
      listener: (context, state) => state.whenOrNull(
        error: _showToast,
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Авторизация',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _loginController,
                label: 'Логин',
                hintText: 'Введите логин',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                label: 'Пароль',
                hintText: 'Введите пароль',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthorizationBloc, AuthorizationState>(
                builder: (context, state) => InkWell(
                  onTap: () {
                    context.read<AuthorizationBloc>().add(
                          AuthorizationEvent.login(
                            login: _loginController.text,
                            password: _passwordController.text,
                          ),
                        );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF1D2041),
                    ),
                    child: state.maybeWhen(
                      waiting: () => const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 24,
                      ),
                      orElse: () => const Text(
                        'Войти',
                        style: TextStyle(
                          fontSize: 20,
                          height: 24 / 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(String msg) {
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.red.withOpacity(0.15),
      ),
      child: Text(
        msg,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.red,
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
