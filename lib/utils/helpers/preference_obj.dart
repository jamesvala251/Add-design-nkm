import 'package:get/get.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/modules/design/controllers/design_list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nkm_admin_panel/constants/preferences_constants.dart';

class PreferenceObj {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return;
  }

  static Future<void> clearPreferenceDataAndLogout() async {
    try {
      Get.delete<CommonController>(
        force: true,
      );
      Get.delete<DesignListController>(
        force: true,
      );
      await _sharedPreferences.clear();
    } catch (err) {
      print('Error while clearing preference data & logout: $err');
    }
    return;
  }

  static String get getAuthToken =>
      _sharedPreferences.getString(PreferencesConstants.authToken) ?? '';

  static Future<bool> setAuthToken({
    required String authToken,
  }) async {
    return await _sharedPreferences.setString(
      PreferencesConstants.authToken,
      authToken,
    );
  }

  static String? get getLanguageCode =>
      _sharedPreferences.getString(PreferencesConstants.languageCode);

  static Future<bool> setLanguageCode({
    required String languageCode,
  }) async {
    return await _sharedPreferences.setString(
      PreferencesConstants.languageCode,
      languageCode,
    );
  }

  static String? get getCountryCode =>
      _sharedPreferences.getString(PreferencesConstants.countryCode);

  static Future<bool> setCountryCode({
    required String countryCode,
  }) async {
    return await _sharedPreferences.setString(
      PreferencesConstants.countryCode,
      countryCode,
    );
  }
}
