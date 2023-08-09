import 'package:business_card_ui/src/models/Customer.dart';
import 'package:business_card_ui/src/pages/connect_list.dart';
import 'package:business_card_ui/src/pages/home.dart';
import 'package:business_card_ui/src/pages/welcome.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final routerList = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyHomePage(title: '${Provider.of<Customer>(context).displayName} - Business Card'),
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
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/connect',
      builder: (context, state) => const ConnectListPage(),
    ),
  ],
);