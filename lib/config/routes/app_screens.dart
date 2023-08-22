import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/modules/add_design/screens/add_design_screen.dart';
import 'package:nkm_admin_panel/modules/add_design/screens/enter_weights_screen.dart';
import 'package:nkm_admin_panel/modules/design/screens/filter_design_screen.dart';
import 'package:nkm_admin_panel/modules/login/screens/login_screen.dart';
import 'package:nkm_admin_panel/modules/update_design/screens/update_design_screen.dart';
import 'package:nkm_admin_panel/modules/update_design/screens/update_design_weight_screen.dart';
import 'package:nkm_admin_panel/utils/ui/device_image_view_screen.dart';
import 'package:nkm_admin_panel/utils/ui/device_video_view_screen.dart';
import 'package:nkm_admin_panel/utils/ui/network_video_view_screen.dart';
import 'package:nkm_admin_panel/modules/sub_category_design_details/screens/sub_category_design_details_screen.dart';
import 'package:nkm_admin_panel/modules/design/screens/design_list_screen.dart';
import 'package:nkm_admin_panel/utils/ui/network_image_view_screen.dart';

class AppScreens {
  static var list = [
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.designListScreen,
      page: () => const DesignListScreen(),
    ),
    GetPage(
      name: AppRoutes.filterDesignListScreen,
      page: () => const FilterDesignScreen(),
    ),
    GetPage(
      name: AppRoutes.updateDesignListScreen,
      page: () => const UpdateDesignScreen(),
    ),
    GetPage(
      name: AppRoutes.networkVideoViewScreen,
      page: () => const NetworkVideoViewScreen(),
    ),
    GetPage(
      name: AppRoutes.subCategoryDesignDetailsScreen,
      page: () => const SubCategoryDesignDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.networkImageViewScreen,
      page: () => const NetworkImageViewScreen(),
    ),
    GetPage(
      name: AppRoutes.addDesignScreen,
      page: () => const AddDesignScreen(),
    ),
    GetPage(
      name: AppRoutes.imageViewForDeviceScreen,
      page: () => const DeviceImageViewScreen(),
    ),
    GetPage(
      name: AppRoutes.deviceVideoViewScreen,
      page: () => const DeviceVideoViewScreen(),
    ),
    GetPage(
      name: AppRoutes.enterWeightsScreen,
      page: () => const EnterWeightsScreen(),
    ),
    GetPage(
      name: AppRoutes.updateDesignWeightsScreen,
      page: () => const UpdateDesignWeightScreen(),
    ),
  ];
}
