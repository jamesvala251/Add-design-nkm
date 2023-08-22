import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/api/api_implementer.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/constants/images_path.dart';
import 'package:nkm_admin_panel/utils/helpers/helper.dart';
import 'package:nkm_admin_panel/utils/helpers/preference_obj.dart';
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 0,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Get.theme.primaryColor,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50.0),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    ImagesPath.appLogo,
                    width: 180,
                    height: 140,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.transparent
                            ],
                            stops: [0.0, 0.09, 0.4, 0.6, 0.9, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24.0),
                        onTap: () => Get.back(),
                        leading: const Icon(
                          Icons.dashboard_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Dashboard",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Get.textTheme.titleLarge!.fontSize),
                        ),
                      ),
                      Container(
                        height: 0.5,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.transparent
                            ],
                            stops: [0.0, 0.09, 0.4, 0.6, 0.9, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24.0),
                        onTap: () {
                          Get.back();
                          logoutApiCall(context: context);
                        },
                        leading: const Icon(
                          Icons.power_settings_new_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Get.textTheme.titleLarge!.fontSize),
                        ),
                      ),
                      Container(
                        height: 0.5,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.transparent
                            ],
                            stops: [0.0, 0.09, 0.4, 0.6, 0.9, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.transparent
                    ],
                    stops: [0.0, 0.09, 0.4, 0.6, 0.9, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 16.0,
                  ),
                  const Text(
                    "1.0.0",
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        widget.scaffoldKey.currentState!.closeDrawer(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logoutApiCall({
  required BuildContext context,
}) async {
  try {
    AppDialogs.showProgressDialog(
      context: context,
    );
    await ApiImplementer.logoutApiCall();
    await PreferenceObj.clearPreferenceDataAndLogout();
    Get.offAllNamed(AppRoutes.loginScreen);
  } on DioException catch (dioError) {
    Get.back();
    String errMsg = Helper.getErrMsgFromDioError(
      dioError: dioError,
    );
    AppDialogs.showInformationDialogue(
      context: context,
      title: 'err_occurred'.tr,
      description: errMsg,
      onOkBntClick: () => Get.back(),
    );
    rethrow;
  } catch (error) {
    Get.back();
    AppDialogs.showInformationDialogue(
      context: context,
      title: 'err_occurred'.tr,
      description: error.toString(),
      onOkBntClick: () => Get.back(),
    );
    rethrow;
  }
}
