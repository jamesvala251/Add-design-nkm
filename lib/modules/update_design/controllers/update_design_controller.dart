import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nkm_admin_panel/api/api_implementer.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/modules/update_design/models/delete_media_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_hallmark_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_image_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_video_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_weight_model.dart';
import 'package:nkm_admin_panel/utils/helpers/custom_exception.dart';
import 'package:nkm_admin_panel/utils/helpers/helper.dart';
import 'package:nkm_admin_panel/utils/helpers/permission_util.dart';
import 'package:nkm_admin_panel/modules/design/models/design_list_model.dart'
    as design_list;
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';
import 'package:path/path.dart' as path;

class UpdateDesignController extends GetxController {
  TextEditingController supplierController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController designNameController = TextEditingController();
  TextEditingController dealerCommissionController = TextEditingController();
  TextEditingController semiDealerCommissionController =
      TextEditingController();
  TextEditingController shopkeeperCommissionController =
      TextEditingController();

  //for Supplier
  int selectedSupplierId = -1;

  //for Category
  int selectedCategoryId = -1;

  //for sub-category
  int selectedSubCategoryId = -1;

  //for weights
  final RxList<UpdateDesignWeightModel> updateDesignWeightModelList =
      <UpdateDesignWeightModel>[].obs;

  //for hallmark
  final RxList<UpdateDesignHallmarkModel> updateDesignHallmarkModelList =
      <UpdateDesignHallmarkModel>[].obs;

  final ImagePicker _imagePicker = ImagePicker();

  //for images
  final RxList<UpdateDesignImageModel> updateDesignImageModelList =
      <UpdateDesignImageModel>[].obs;

  //for videos
  final RxList<UpdateDesignVideoModel> updateDesignVideoModelList =
      <UpdateDesignVideoModel>[].obs;

  final MethodChannel _commonMethodChannel = const MethodChannel(
    CommonConstants.nkmAdminPanelMethodChannel,
  );

  final CommonController _commonController = Get.find<CommonController>();

  late int _uploadedImagesCount = 0;
  late int _uploadedVideosCount = 0;

  void initData({required design_list.Data designListItemModel}) {
    selectedSupplierId = designListItemModel.supplier.id;
    supplierController.text = designListItemModel.supplier.name;

    selectedCategoryId = designListItemModel.category.id;
    categoryController.text = designListItemModel.category.name;

    _commonController.getSubCategoryApiCall(categoryId: selectedCategoryId);

    selectedSubCategoryId = designListItemModel.subCategory.id;
    subCategoryController.text = designListItemModel.subCategory.name;

    designNameController.text = designListItemModel.name;
    // designWeightController.text = designListItemModel.weight;
    dealerCommissionController.text = designListItemModel.dealerCommission;
    semiDealerCommissionController.text =
        designListItemModel.semiDealerCommission;
    shopkeeperCommissionController.text =
        designListItemModel.shopkeeperCommission;

    for (var element in designListItemModel.goldCaret.first.designWeight) {
      updateDesignWeightModelList.add(
        UpdateDesignWeightModel(
          id: element.id,
          weightArg: element.weight,
          articleNumber: element.articleNumber,
        ),
      );
    }

    for (var element in designListItemModel.goldCaret.first.designWeight) {
      updateDesignHallmarkModelList.add(
        UpdateDesignHallmarkModel(
          id: element.id,
          hallmarkArg: element.hallmark,
          articleNumber: element.articleNumber,
        ),
      );
    }

    _uploadedImagesCount = designListItemModel.images.length;
    _uploadedVideosCount = designListItemModel.videos.length;
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
          if (_uploadedImagesCount + updateDesignImageModelList.length <= 2) {
            List<XFile> xFileList = await _imagePicker.pickMultiImage();
            if (_uploadedImagesCount +
                    updateDesignImageModelList.length +
                    xFileList.length >
                3) {
              UiUtils.errorSnackBar(
                message: 'You can only upload maximum 3 images!',
              );
              return;
            }
            if (xFileList.isNotEmpty) {
              for (var xFile in xFileList) {
                if (Helper.getFileSizeInMb(filePath: xFile.path) < 2) {
                  updateDesignImageModelList.insert(
                    0,
                    UpdateDesignImageModel(
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
          if (_uploadedVideosCount == 0 && updateDesignVideoModelList.isEmpty) {
            XFile? xFile =
                await _imagePicker.pickVideo(source: ImageSource.gallery);
            if (xFile != null) {
              if (Helper.getFileSizeInMb(filePath: xFile.path) < 2) {
                updateDesignVideoModelList.insert(
                  0,
                  UpdateDesignVideoModel(
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

  void deleteMediaDesignApiCall({
    required bool isDeletedMediaIsImage,
    required int mediaId,
    required design_list.Data designListItem,
    required int deleteMediaIndex,
  }) async {
    try {
      AppDialogs.showProgressDialog(
        context: Get.context!,
      );
      DeleteMediaModel deleteMediaModel =
          await ApiImplementer.deleteMediaApiCall(
        mediaId: mediaId,
      );
      Get.back();
      if (deleteMediaModel.success) {
        if (isDeletedMediaIsImage) {
          _uploadedImagesCount--;
          designListItem.images.removeAt(deleteMediaIndex);
          return;
        } else {
          _uploadedVideosCount--;
          designListItem.videos.removeAt(deleteMediaIndex);
          return;
        }
        // UiUtils.successSnackBar(message: deleteMediaModel.message);
        return;
      }
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        barrierDismissible: false,
        title: 'err_occurred'.tr,
        description: deleteMediaModel.message,
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

  void updateDesignApiCall({required int designId}) async {
    try {
      AppDialogs.showProgressDialog(
        context: Get.context!,
      );
      UpdateDesignModel updateDesignModel =
          await ApiImplementer.updateDesignApiCall(
        designId: designId,
        supplierId: selectedSupplierId,
        categoryId: selectedCategoryId,
        subCategoryId: selectedSubCategoryId,
        designName: designNameController.text,
        productWeightModelList: updateDesignWeightModelList,
        updateDesignHallmarkModelList: updateDesignHallmarkModelList,
        dealerCommission: dealerCommissionController.text,
        semiDealerCommission: semiDealerCommissionController.text,
        shopkeeperCommission: shopkeeperCommissionController.text,
        updateDesignImageModelList: updateDesignImageModelList,
        updateDesignVideoModelList: updateDesignVideoModelList,
      );
      Get.back();
      if (updateDesignModel.success) {
        AppDialogs.showInformationDialogue(
          context: Get.context!,
          title: 'Design Updated!',
          description: updateDesignModel.message,
          onOkBntClick: () {
            Get.back();
            Get.back();
          },
        );
        return;
      }
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        barrierDismissible: false,
        title: 'err_occurred'.tr,
        description: updateDesignModel.message,
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
}
