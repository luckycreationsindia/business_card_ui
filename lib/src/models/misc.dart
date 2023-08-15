import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'misc.g.dart';

@RestApi()
abstract class MiscRestClient {
  factory MiscRestClient(Dio dio, {String baseUrl}) = _MiscRestClient;

  @GET("/sectors")
  Future<List<String>> getSectors();
}
