import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nkm_admin_panel/api/api_implementer.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/modules/add_design/models/create_design_image_model.dart';
import 'package:nkm_admin_panel/modules/add_design/models/create_design_model.dart';
import 'package:nkm_admin_panel/modules/add_design/models/create_design_video_model.dart';
import 'package:nkm_admin_panel/modules/add_design/models/hallmark_text_filed_model.dart';
import 'package:nkm_admin_panel/modules/add_design/models/weights_text_field_model.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/utils/helpers/custom_exception.dart';
import 'package:nkm_admin_panel/utils/helpers/helper.dart';
import 'package:nkm_admin_panel/utils/helpers/permission_util.dart';
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';
import 'package:path/path.dart' as path;

class AddDesignController extends GetxController {
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController designNameController = TextEditingController();
  final TextEditingController designWeightController = TextEditingController();
  final TextEditingController dealerCommissionController =
      TextEditingController();
  final TextEditingController semiDealerCommissionController =
      TextEditingController();
  final TextEditingController shopkeeperCommissionController =
      TextEditingController();
  final TextEditingController goldCaretController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  //for Category
  int selectedCategoryId = -1;

  //for sub-category
  int selectedSubCategoryId = -1;

  //for gold-caret
  int selectedGoldCaretId = -1;

  //for Supplier
  int selectedSupplierId = -1;

  final ImagePicker _imagePicker = ImagePicker();

  //for images
  final RxList<CreateDesignImageModel> createDesignImageModelList =
      <CreateDesignImageModel>[].obs;

  //for videos
  final RxList<CreateDesignVideoModel> createDesignVideoModelList =
      <CreateDesignVideoModel>[].obs;

  final MethodChannel _commonMethodChannel = const MethodChannel(
    CommonConstants.nkmAdminPanelMethodChannel,
  );
  final CommonController _commonController = Get.find<CommonController>();

  final RxList<WeightsTextFieldModel> weights =
      RxList<WeightsTextFieldModel>([]);

  final RxList<HallmarkTextFiledModel> hallmarks =
      RxList<HallmarkTextFiledModel>([]);

  @override
  void onInit() {
    super.onInit();
    _initSupplierId();
    _initCategoryId();
    _initGoldCaret();
  }

  void _initSupplierId() {
    if (_commonController.supplierList.isNotEmpty) {
      selectedSupplierId = _commonController.supplierList.first.id;
      supplierController.text = _commonController.supplierList.first.name;
    }
  }

  void _initCategoryId() {
    if (_commonController.categoryList.isNotEmpty) {
      selectedCategoryId = _commonController.categoryList.first.id;
      categoryController.text = _commonController.categoryList.first.name;
      selectedSubCategoryId = -1;
      _commonController.subCategoryList.clear();
      _commonController.getSubCategoryApiCall(categoryId: selectedCategoryId);
    }
  }

  void _initGoldCaret() {
    if (_commonController.goldCaretList.isNotEmpty) {
      selectedGoldCaretId = _commonController.goldCaretList.first.caret;
      goldCaretController.text = _commonController.goldCaretList.first.label;
    }
  }

  Future<bool> askForStoragePermission() async {
    try {
      Object? object = await _commonMethodChannel
          .invokeMethod(CommonConstants.getAndroidVersionMethod);
      int androidVersion = 0;

      if (object != null) {
        androidVersion = int.parse(object.toString().trim());
      }

      return await PermissionUtil.hasStoragePermission(
        isAndroidVersion13OrAbove: androidVersion >= 13,
      );
    } catch (e) {
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        description: (e as CustomException).errMessage,
        onOkBntClick: () => Get.back(),
      );
      return false;
    }
  }

  void selectImage() {
    try {
      askForStoragePermission().then((value) async {
        if (value) {
          if (createDesignImageModelList.length <= 2) {
            List<XFile> xFileList = await _imagePicker.pickMultiImage();
            if (createDesignImageModelList.length + xFileList.length > 3) {
              UiUtils.errorSnackBar(
                message: 'You can only upload maximum 3 images!',
              );
              return;
            }
            if (xFileList.isNotEmpty) {
              for (var xFile in xFileList) {
                if (Helper.getFileSizeInMb(filePath: xFile.path) < 2) {
                  createDesignImageModelList.insert(
                    0,
                    CreateDesignImageModel(
                      imgPath: xFile.path,
                    ),
                  );
                } else {
                  UiUtils.errorSnackBar(
                    message:
                        'The image ${path.basename(xFile.path)} exceeds the maximum file size of 2MB and has been removed.',
                  );
                }
              }
              return;
            }
            return;
          }
          UiUtils.errorSnackBar(
              message: 'You can only upload maximum 3 images!');
          return;
        }
      });
    } catch (err) {
      UiUtils.errorSnackBar(message: err.toString());
      return;
    }
  }

  void selectVideo() {
    try {
      askForStoragePermission().then((value) async {
        if (value) {
          if (createDesignVideoModelList.isEmpty) {
            XFile? xFile =
                await _imagePicker.pickVideo(source: ImageSource.gallery);
            if (xFile != null) {
              if (Helper.getFileSizeInMb(filePath: xFile.path) < 2) {
                createDesignVideoModelList.insert(
                  0,
                  CreateDesignVideoModel(
                    videoPath: xFile.path,
                  ),
                );
                return;
              } else {
                UiUtils.errorSnackBar(
                    message: 'video size must be less then 2MB (<=2MB)');
              }
              return;
            } else {
              UiUtils.errorSnackBar(
                message: 'video not found!',
              );
              return;
            }
          }
          UiUtils.errorSnackBar(message: 'You can only upload 1 video!');
          return;
        }
      });
    } catch (err) {
      UiUtils.errorSnackBar(message: err.toString());
      return;
    }
  }

  void createDesignApiCall() async {
    try {
      AppDialogs.showProgressDialog(
        context: Get.context!,
      );
      CreateDesignModel createDesignModel =
          await ApiImplementer.createDesignApiCall(
        supplierId: selectedSupplierId,
        categoryId: selectedCategoryId,
        subCategoryId: selectedSubCategoryId,
        designName: designNameController.text,
        productWeight: designWeightController.text,
        dealerCommission: dealerCommissionController.text,
        semiDealerCommission: semiDealerCommissionController.text,
        shopkeeperCommission: shopkeeperCommissionController.text,
        caret: selectedGoldCaretId,
        quantity: quantityController.text,
        weightList: weights,
        hallmarkList: hallmarks,
        createDesignImageModelList: createDesignImageModelList,
        createDesignVideoModelList: createDesignVideoModelList.isEmpty
            ? null
            : createDesignVideoModelList,
      );
      Get.back();
      if (createDesignModel.success) {
        AppDialogs.showAlertDialog(
          context: Get.context!,
          title: 'Design Added!',
          description: createDesignModel.message,
          firstButtonName: 'Go Back',
          secondButtonName: 'Add More',
          onFirstButtonClicked: () {
            Get.back();
            Get.back(result: true);
          },
          onSecondButtonClicked: () {
            _clearData();
            Get.back();
          },
        );
        return;
      }
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        barrierDismissible: false,
        title: 'err_occurred'.tr,
        description: createDesignModel.message,
        onOkBntClick: () => Get.back(),
      );
      return;
    } on DioException catch (dioError) {
      Get.back();
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        title: 'err_occurred'.tr,
        description: errMsg,
        onOkBntClick: () => Get.back(),
      );
    } catch (error) {
      Get.back();
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        title: 'err_occurred'.tr,
        description: error.toString(),
        onOkBntClick: () => Get.back(),
      );
    }
  }

  void _clearData() {
    supplierController.clear();
    categoryController.clear();
    subCategoryController.clear();
    designNameController.clear();
    designWeightController.clear();
    dealerCommissionController.clear();
    semiDealerCommissionController.clear();
    shopkeeperCommissionController.clear();
    goldCaretController.clear();
    quantityController.clear();

    selectedCategoryId = -1;

    selectedSubCategoryId = -1;
    selectedGoldCaretId = -1;
    selectedSupplierId = -1;
    createDesignImageModelList.clear();
    createDesignVideoModelList.clear();
  }
}
