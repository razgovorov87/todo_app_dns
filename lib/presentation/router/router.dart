import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AdaptiveRoute(
          path: '/',
          page: AuthorizationRoute.page,
        ),
        AdaptiveRoute(
          path: '/main',
          page: HomeRoute.page,
        ),
        ..._dialogRoutes,
      ];
}

final List<CustomRoute> _dialogRoutes = <CustomRoute>[
  CustomRoute(
    path: '/todo_info',
    page: TodoInfoDialog.page,
    opaque: false,
    barrierColor: const Color(0x80000000),
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  ),
  CustomRoute(
    path: '/create',
    page: CreateNewTodoDialog.page,
    opaque: false,
    barrierColor: const Color(0x80000000),
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  ),
];
