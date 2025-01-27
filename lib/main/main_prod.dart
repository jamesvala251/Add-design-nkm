import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/config/env/env_config.dart';
import 'package:nkm_admin_panel/firebase_options.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/modules/design/controllers/design_list_controller.dart';
import 'package:nkm_admin_panel/root_widget.dart' as root_widget;
import 'package:nkm_admin_panel/utils/helpers/preference_obj.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig(
    envType: EnvTypeEnum.prod,
    appName: "NKM Admin Panel",
    baseUrl: "https://nkmnosepinsllp.com/api/",
  );
  await PreferenceObj.init();
  if (PreferenceObj.getAuthToken.isNotEmpty) {
    Get.put(CommonController(), permanent: true);
    Get.put(DesignListController(), permanent: true);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) async {
      runApp(const root_widget.RootWidget());
    },
  );
}
