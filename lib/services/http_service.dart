import 'package:coincap/models/app_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? appConfig;
  String? base_url;

  HTTPService() {
    appConfig = GetIt.instance.get<AppConfig>();
    base_url = appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String path) async {
    try {
      String url = "$base_url$path";
      Response response = await dio.get(url);
      return response;
    } catch (e) {
      print('HTTPService: Unable to perform get request.');
      print(e);
    }
  }
}
