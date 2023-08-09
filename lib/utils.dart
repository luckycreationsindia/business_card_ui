import 'package:dio/dio.dart';

class Consts {
  static String API_ROOT = "http://localhost:9876/api/v1/";
  static late Map<String, String> env;
  static late Dio dio;
}