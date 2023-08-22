import 'package:dio/dio.dart';
import 'package:nkm_admin_panel/api/api_interceptor.dart';
import 'package:nkm_admin_panel/config/env/env_config.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/utils/helpers/preference_obj.dart';

class AuthTokenDioClient {
  static Dio? _dio;
  static ApiInterceptor? _apiInterceptor;

  static Dio? getAuthTokenDioClient() {
    if (_dio == null && PreferenceObj.getAuthToken.isNotEmpty) {
      _dio = Dio();
      _apiInterceptor = ApiInterceptor();
      _dio!.options.baseUrl = EnvConfig.instance.baseUrl;
      _dio!.interceptors.add(_apiInterceptor!);
      _dio!.options.connectTimeout = const Duration(
          milliseconds: CommonConstants.connectionTimeOutInMilliseconds);
      _dio!.options.receiveTimeout = const Duration(
          milliseconds: CommonConstants.receiveTimeOutInMilliseconds);
    }
    return _dio;
  }
}
