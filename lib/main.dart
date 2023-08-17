import 'package:business_card_ui/src/models/Customer.dart';
import 'package:business_card_ui/src/utils/router.dart';
import 'package:business_card_ui/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

late Customer customerData;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String env = "assets/.env";
  if (!kDebugMode) env = "assets/production.env";
  await dotenv.load(fileName: env);
  Consts.env = dotenv.env;
  setPathUrlStrategy();
  if (Consts.env.containsKey("API_ROOT")) {
    Consts.API_ROOT = Consts.env['API_ROOT']!;
  }
  var dio = Dio(BaseOptions(baseUrl: Consts.API_ROOT));
  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        var data = response.data;
        if (data['status'] == 'Success') {
          handler.next(Response(
              requestOptions: response.requestOptions, data: data['message']));
        } else {
          handler.reject(DioException(
            requestOptions: response.requestOptions,
            error: "Error Loading Data",
          ));
        }
      },
    ),
  );
  Consts.dio = dio;

  String id = Uri.base.queryParameters['id'] ?? "";
  if(id.isNotEmpty) {
    try {
      customerData = await CustomerRestClient(dio).loadCustomer(id);
    } catch (e) {}
  }
  runApp(MyApp(id: id));
}

class MyApp extends StatelessWidget {
  final String? id;

  const MyApp({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (id == null || id!.isEmpty) {
      return MaterialApp.router(
        title: 'Digital Business Card',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ).copyWith(
          textTheme: GoogleFonts.promptTextTheme(ThemeData().textTheme),
        ),
        routerConfig: welcomeRouterList,
      );
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Customer>.value(
          value: customerData,
        ),
      ],
      child: MaterialApp.router(
        title: '${customerData.displayName} - Business Card',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ).copyWith(
          textTheme: GoogleFonts.promptTextTheme(ThemeData().textTheme),
        ),
        routerConfig: routerList,
      ),
    );
  }
}
