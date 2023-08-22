import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/config/env/env_config.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/config/routes/app_screens.dart';
import 'package:nkm_admin_panel/config/theme/app_theme.dart';
import 'package:nkm_admin_panel/utils/helpers/preference_obj.dart';
import 'package:nkm_admin_panel/utils/services/language_service.dart';

class RootWidget extends StatelessWidget {
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: EnvConfig.instance.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: PreferenceObj.getAuthToken.isNotEmpty
          ? AppRoutes.designListScreen
          : AppRoutes.loginScreen,
      getPages: AppScreens.list,
      locale: (PreferenceObj.getLanguageCode == null ||
              PreferenceObj.getCountryCode == null)
          ? const Locale('en', 'US')
          : Locale(
              PreferenceObj.getLanguageCode!,
              PreferenceObj.getCountryCode!,
            ),
      translations: LocaleString(),
    );
  }
}
