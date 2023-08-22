import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/api/api_implementer.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/constants/images_path.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/modules/design/controllers/design_list_controller.dart';
import 'package:nkm_admin_panel/modules/login/models/login_model.dart';
import 'package:nkm_admin_panel/utils/helpers/helper.dart';
import 'package:nkm_admin_panel/utils/helpers/preference_obj.dart';
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';
import 'package:nkm_admin_panel/utils/ui/common_style.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final RxBool _isObSecure = true.obs;

  @override
  Widget build(BuildContext context) {
    double deviceAvailableHeight =
        Get.size.height - Get.mediaQuery.padding.vertical;

    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceAvailableHeight,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: deviceAvailableHeight * 0.10,
                ),
                Text(
                  'welcome'.tr,
                  style: TextStyle(
                    fontSize: Get.textTheme.headlineSmall!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 0.9,
                  ),
                ),
                Text(
                  'sign_in_to_continue'.tr,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleLarge!.fontSize,
                    letterSpacing: 0.9,
                    color: Colors.white60,
                  ),
                ),
                SizedBox(
                  height: deviceAvailableHeight * 0.07,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    ImagesPath.appLogo,
                    height: 94,
                    width: 220,
                  ),
                ),
                SizedBox(
                  height: deviceAvailableHeight * 0.07,
                ),
                TextFormField(
                  cursorColor: Colors.white70,
                  controller: _emailId,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 60,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Get.textTheme.titleMedium!.fontSize,
                  ),
                  decoration:
                      CommonStyle.getTextFormFiledDecorationForEmailIdFiled(
                    label: 'Email Address'.tr,
                    hintText: 'Enter Email Address'.tr,
                    context: context,
                  ),
                ),
                SizedBox(
                  height: deviceAvailableHeight * 0.03,
                ),
                Obx(
                  () => TextFormField(
                    cursorColor: Colors.white70,
                    controller: _password,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObSecure.value,
                    maxLength: 20,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                    ),
                    decoration: CommonStyle.getTextFormFiledDecorationForLogin(
                      label: 'Password',
                      hintText: 'Enter Password',
                      prefixIcon: Icons.lock,
                      sufixWidget: InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () {
                          _isObSecure.value = !_isObSecure.value;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Icon(
                            _isObSecure.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                        ),
                      ), // prefixIcon: Icons.person,
                    ),
                    validator: (enteredPassword) {
                      if (enteredPassword == null || enteredPassword.isEmpty) {
                        return '⚠️ Please enter password!';
                      } else if (enteredPassword.contains(' ')) {
                        return '⚠️ Password does\'t contain space!';
                      } else if (enteredPassword.length < 8) {
                        return '⚠️ Password length must be >= 8!';
                      } else if (enteredPassword.length > 20) {
                        return '⚠️ Password length must be < 20';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: deviceAvailableHeight * 0.07,
                ),
                ElevatedButton(
                  onPressed: () {
                    String emailId = _emailId.text.trim();
                    String password = _password.text.trim();
                    if (emailId.isEmpty) {
                      UiUtils.errorSnackBar(
                          message: 'Please enter Email Address!'.tr);
                      return;
                    } else if (password.isEmpty) {
                      UiUtils.errorSnackBar(
                          message: 'Please enter Password!'.tr);
                      return;
                    }
                    _loginApiCall(
                      emailId: emailId,
                      password: password,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                      ),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.white),
                  child: Text(
                    'sign_in'.tr.toUpperCase(),
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginApiCall({
    required String emailId,
    required String password,
  }) async {
    try {
      AppDialogs.showProgressDialog(
        context: context,
      );
      LoginModel userLoginModel = await ApiImplementer.loginApiCall(
        emailId: emailId,
        password: password,
      );
      Get.back();
      if (userLoginModel.success && userLoginModel.token.isNotEmpty) {
        _storeLoginData(loginModel: userLoginModel);
        UiUtils.successSnackBar(message: userLoginModel.message);
        return;
      }
      AppDialogs.showInformationDialogue(
        context: context,
        barrierDismissible: false,
        title: 'err_occurred'.tr,
        description: userLoginModel.message,
        onOkBntClick: () => Get.back(),
      );
      return;
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
    } catch (error) {
      Get.back();
      AppDialogs.showInformationDialogue(
        context: context,
        title: 'err_occurred'.tr,
        description: error.toString(),
        onOkBntClick: () => Get.back(),
      );
    }
  }

  void _storeLoginData({required LoginModel loginModel}) async {
    await PreferenceObj.setAuthToken(
      authToken: loginModel.token!,
    );
    Get.put(CommonController(), permanent: true);
    Get.put(DesignListController(), permanent: true);
    _goToDashboard();
    return;
  }

  void _goToDashboard() {
    Get.offAllNamed(
      AppRoutes.designListScreen,
    );
    return;
  }
}
