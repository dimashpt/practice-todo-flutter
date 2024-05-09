import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertodo/components/layout.dart';
import 'package:fluttertodo/screens/home.dart';
import 'package:fluttertodo/screens/settings.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellHomeNavigator = GlobalKey<NavigatorState>(debugLabel: 'homeShell');
final _shellSettingsNavigator =
    GlobalKey<NavigatorState>(debugLabel: 'settingsShell');

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) =>
          MainLayout(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellHomeNavigator,
          routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellSettingsNavigator,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, __) => SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
