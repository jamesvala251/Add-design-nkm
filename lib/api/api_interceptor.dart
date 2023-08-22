import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/utils/helpers/preference_obj.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';

class ApiInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Authorization"] = "Bearer ${PreferenceObj.getAuthToken}";
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response!.statusCode == 401) {
      PreferenceObj.clearPreferenceDataAndLogout();
      UiUtils.errorSnackBar(message: 'Session Expired,Please login again!');
      await PreferenceObj.clearPreferenceDataAndLogout();
      Get.offAllNamed(
        AppRoutes.loginScreen,
      );
      return handler.next(err);
    }
    return handler.next(err);
  }
}
