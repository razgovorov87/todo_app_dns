import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/domain/bloc/authorization/authorization_bloc.dart';
import 'package:todo_app/domain/bloc/authorization/authorization_cubit.dart';
import 'package:todo_app/get_it.dart';
import 'package:todo_app/presentation/application/application_listener.dart';
import 'package:todo_app/presentation/router/router.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late AuthorizationBloc _authorizationBloc;
  late AuthorizationCubit _authorizationCubit;

  @override
  void initState() {
    super.initState();
    _authorizationBloc = getIt.get<AuthorizationBloc>();
    _authorizationCubit = getIt.get<AuthorizationCubit>();
  }

  @override
  void dispose() {
    _authorizationBloc.close();
    _authorizationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authorizationBloc),
        BlocProvider.value(value: _authorizationCubit),
      ],
      child: AuthorizationListener(
        child: MaterialApp.router(
          builder: FToastBuilder(),
          debugShowCheckedModeBanner: false,
          routerConfig: getIt.get<AppRouter>().config(),
        ),
      ),
    );
  }
}
