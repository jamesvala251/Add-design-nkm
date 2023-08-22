import 'package:dio/dio.dart';
import 'package:nkm_admin_panel/config/env/env_config.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';

class DioClient {
  static Dio? _dio;

  static Dio? getDioClient() {
    if (_dio == null) {
      _dio = Dio();
      _dio!.options.baseUrl = EnvConfig.instance.baseUrl;
      _dio!.options.connectTimeout = const Duration(
          milliseconds: CommonConstants.connectionTimeOutInMilliseconds);
      _dio!.options.receiveTimeout = const Duration(
          milliseconds: CommonConstants.receiveTimeOutInMilliseconds);
    }
    return _dio;
  }
}
