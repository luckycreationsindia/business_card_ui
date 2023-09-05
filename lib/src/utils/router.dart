import 'package:business_card_ui/src/pages/connect_list.dart';
import 'package:business_card_ui/src/pages/home.dart';
import 'package:go_router/go_router.dart';

final routerList = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/connect',
      builder: (context, state) => const ConnectListPage(),
    ),
  ],
);

final welcomeRouterList = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ConnectListPage(),
    ),
    GoRoute(
      path: '/connect',
      builder: (context, state) => const ConnectListPage(),
    ),
  ],
);
