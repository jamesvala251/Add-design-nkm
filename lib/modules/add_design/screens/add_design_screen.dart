import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/constants/route_constants.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/add_design/controllers/add_design_controller.dart';
import 'package:nkm_admin_panel/modules/add_design/widgets/category_selection_bottom_sheet.dart';
import 'package:nkm_admin_panel/modules/add_design/widgets/gold_caret_selection_bottom_sheet.dart';
import 'package:nkm_admin_panel/modules/add_design/widgets/sub_category_selection_bottom_sheet.dart';
import 'package:nkm_admin_panel/modules/add_design/widgets/supplier_selection_bottom_sheet.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';
import 'package:nkm_admin_panel/utils/ui/common_style.dart';
import 'package:nkm_admin_panel/utils/ui/max_value_text_input_formatter.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as path;

class AddDesignScreen extends StatefulWidget {
  const AddDesignScreen({super.key});

  @override
  State<AddDesignScreen> createState() => _AddDesignScreenState();
}

class _AddDesignScreenState extends State<AddDesignScreen> {
  final AddDesignController _addDesignController =
      Get.put(AddDesignController());
  final CommonController _commonController = Get.find<CommonController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Design"),
        centerTitle: true,
      ),
      bottomNavigationBar: getSubmitCancelButtons(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8.0,
              ),
              ...getSelectSupplierWidget(),
              ...getSelectCategoryWidget(),
              ...getSelectSubCategoryWidget(),
              ...getDesignNameTextFieldWidget(),
              ...getDealerCommissionTextFieldWidget(),
              ...getSemiDealerCommissionTextFieldWidget(),
              ...getShopKeeperCommissionTextFieldWidget(),
              ...getSelectGoldCaretWidget(),
              getDesignQtyTextFieldWidget(),
              getWeightSelectionWidget(),
              getImageSelectionWidget(),
              getVideoSelectionWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSubmitCancelButtons() {
    return Card(
      elevation: 10,
      margin: EdgeInsets.zero,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        side: BorderSide(color: Get.theme.primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              flex: 6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  if (_addDesignController.selectedSupplierId == -1) {
                    UiUtils.errorSnackBar(message: 'Please select supplier!');
                    return;
                  } else if (_addDesignController.selectedCategoryId == -1) {
                    UiUtils.errorSnackBar(message: 'Please select category!');
                    return;
                  } else if (_addDesignController.selectedSubCategoryId == -1) {
                    UiUtils.errorSnackBar(
                        message: 'Please select sub-category!');
                    return;
                  } else if (_addDesignController
                      .designNameController.text.isEmpty) {
                    UiUtils.errorSnackBar(message: 'Please enter design name!');
                    return;
                  } else if (_addDesignController
                      .dealerCommissionController.text.isEmpty) {
                    UiUtils.errorSnackBar(
                        message: 'Please enter dealer commission!');
                    return;
                  } else if (_addDesignController
                      .semiDealerCommissionController.text.isEmpty) {
                    UiUtils.errorSnackBar(
                        message: 'Please enter semi-dealer commission!');
                    return;
                  } else if (_addDesignController
                      .shopkeeperCommissionController.text.isEmpty) {
                    UiUtils.errorSnackBar(
                        message: 'Please enter shopkeeper commission!');
                    return;
                  } else if (_addDesignController.selectedGoldCaretId == -1) {
                    UiUtils.errorSnackBar(message: 'Please select Gold Caret!');
                    return;
                  } else if (_addDesignController.quantityController.text
                          .trim()
                          .isEmpty ||
                      _addDesignController.quantityController.text.trim() ==
                          "0") {
                    UiUtils.errorSnackBar(message: 'Please Enter Quantity!');
                    return;
                  } else if (int.parse(_addDesignController
                          .quantityController.text
                          .trim()) !=
                      _addDesignController.weights.length) {
                    UiUtils.errorSnackBar(
                        message: 'Weight count should be same as Quantity!');
                    return;
                  } else if (_addDesignController
                      .createDesignImageModelList.isEmpty) {
                    UiUtils.errorSnackBar(
                        message:
                            'Please select the product image by clicking on the "Select Image" button!');
                    return;
                  }
                  _addDesignController.createDesignApiCall();
                  return;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getWeightSelectionWidget() {
    return Card(
      margin: const EdgeInsets.only(top: 24.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Get.theme.primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_addDesignController
                            .quantityController.text.isNotEmpty &&
                        _addDesignController.quantityController.text != "0") {
                      Get.toNamed(AppRoutes.enterWeightsScreen, arguments: {
                        RouteConstants.count:
                            _addDesignController.quantityController.text.trim(),
                        RouteConstants.isWeightAvailable:
                            _addDesignController.weights.isNotEmpty
                                ? true
                                : false
                      });
                    } else {
                      UiUtils.errorSnackBar(
                          message: "Please Enter Quantity First");
                    }
                  },
                  child: Text(
                    "Add Weight*",
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Tooltip(
                  margin: const EdgeInsets.only(left: 24.0, right: 24),
                  triggerMode: TooltipTriggerMode.tap,
                  enableFeedback: true,
                  preferBelow: true,
                  showDuration: const Duration(seconds: 2),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  message:
                      'Note :- You are required to add a weight for each quantity you have entered.',
                  child: Icon(
                    Icons.info_rounded,
                    color: Get.theme.primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
              ],
            ),
            Obx(
              () => SizedBox(
                height: _addDesignController.weights.isEmpty ? 0.0 : 8.0,
              ),
            ),
            Obx(
              () => _addDesignController.weights.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 32,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => const SizedBox(
                          width: 8.0,
                          height: 32,
                        ),
                        itemCount: _addDesignController.weights.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) => Container(
                          clipBehavior: Clip.hardEdge,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.balance_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
                              Obx(
                                () => Text(
                                  '${_addDesignController.weights[index].weight.value} ${_commonController.adminGetSettingsModel != null ? _commonController.adminGetSettingsModel!.data.designWeightUnit : 'mg'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageSelectionWidget() {
    return Card(
      margin: const EdgeInsets.only(top: 24.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Get.theme.primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                  onPressed: () => _addDesignController.selectImage(),
                  child: Text(
                    "Select Image*",
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Tooltip(
                  margin: const EdgeInsets.only(left: 24.0, right: 24),
                  triggerMode: TooltipTriggerMode.tap,
                  enableFeedback: true,
                  preferBelow: true,
                  showDuration: const Duration(seconds: 2),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  message:
                      'Note :- Image Size Should Be Less Than 2MB.At least one image is mandatory, with a maximum of three images allowed.',
                  child: Icon(
                    Icons.info_rounded,
                    color: Get.theme.primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
              ],
            ),
            Obx(
              () => SizedBox(
                height: _addDesignController.createDesignImageModelList.isEmpty
                    ? 0.0
                    : 8.0,
              ),
            ),
            Obx(
              () => _addDesignController.createDesignImageModelList.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 100,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => const SizedBox(
                          width: 8.0,
                          height: 40,
                        ),
                        itemCount: _addDesignController
                            .createDesignImageModelList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) => InkWell(
                          onLongPress: () {},
                          onTap: () => Get.toNamed(
                            AppRoutes.imageViewForDeviceScreen,
                            arguments: {
                              RouteConstants.title: (index + 1).toString(),
                              RouteConstants.imagePath: _addDesignController
                                  .createDesignImageModelList[index].imgPath
                            },
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Get.theme.primaryColor),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Transform.scale(
                                      scale: 1.2,
                                      child: Image.file(
                                        File(
                                          _addDesignController
                                              .createDesignImageModelList[index]
                                              .imgPath,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () {
                                      AppDialogs.showAlertDialog(
                                        context: context,
                                        title: "Delete",
                                        description:
                                            "Are you sure you want to delete Image?",
                                        firstButtonName: "Yes",
                                        secondButtonName: "No",
                                        onFirstButtonClicked: () {
                                          _addDesignController
                                              .createDesignImageModelList
                                              .removeAt(index);
                                          Get.back();
                                        },
                                        onSecondButtonClicked: () => Get.back(),
                                      );
                                    },
                                    child: const CircleAvatar(
                                      radius: 10,
                                      foregroundColor: Colors.white,
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8),
                                            bottomLeft: Radius.circular(8),
                                          ),
                                          color: Colors.black54,
                                        ),
                                        height: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Text(
                                            path.basename(
                                              _addDesignController
                                                  .createDesignImageModelList[
                                                      index]
                                                  .imgPath,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getVideoSelectionWidget() {
    return Card(
      margin: const EdgeInsets.only(top: 24.0, bottom: 24),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Get.theme.primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                  onPressed: () => _addDesignController.selectVideo(),
                  child: Text(
                    "Select Video",
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: Get.textTheme.titleMedium!.fontSize,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Tooltip(
                  margin: const EdgeInsets.only(left: 24.0, right: 24),
                  triggerMode: TooltipTriggerMode.tap,
                  enableFeedback: true,
                  preferBelow: true,
                  showDuration: const Duration(seconds: 2),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  message:
                      'Note :- Video Size Should Be Less Than 2MB(Optional).',
                  child: Icon(
                    Icons.info_rounded,
                    color: Get.theme.primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
              ],
            ),
            Obx(
              () => SizedBox(
                height: _addDesignController.createDesignVideoModelList.isEmpty
                    ? 0.0
                    : 8.0,
              ),
            ),
            Obx(
              () => _addDesignController.createDesignVideoModelList.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 100,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => const SizedBox(
                          width: 8.0,
                          height: 40,
                        ),
                        itemCount: _addDesignController
                            .createDesignVideoModelList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) => InkWell(
                          onLongPress: () {},
                          onTap: () => Get.toNamed(
                            AppRoutes.deviceVideoViewScreen,
                            arguments: {
                              RouteConstants.title: (index + 1).toString(),
                              RouteConstants.videoPath: _addDesignController
                                  .createDesignVideoModelList[index].videoPath
                            },
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Get.theme.primaryColor),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: FutureBuilder(
                                      future: VideoThumbnail.thumbnailFile(
                                        video: _addDesignController
                                            .createDesignVideoModelList[index]
                                            .videoPath,
                                        imageFormat: ImageFormat.JPEG,
                                      ),
                                      builder: (ctx, snapShot) {
                                        if (snapShot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: SpinKitSpinningLines(
                                              color: Get.theme.primaryColor,
                                              size: 30,
                                            ),
                                          );
                                        }

                                        if (snapShot.data == null) {
                                          return const Center(
                                            child: Icon(
                                              Icons.error_rounded,
                                              color: Colors.red,
                                            ),
                                          );
                                        }
                                        return Stack(
                                          children: [
                                            Image.file(
                                              File(snapShot.data ?? ''),
                                            ),
                                            const Center(
                                              child: Icon(
                                                Icons.play_circle_fill_rounded,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () {
                                      AppDialogs.showAlertDialog(
                                        context: context,
                                        title: "Delete",
                                        description:
                                            "Are you sure you want to delete Video?",
                                        firstButtonName: "Yes",
                                        secondButtonName: "No",
                                        onFirstButtonClicked: () {
                                          _addDesignController
                                              .createDesignVideoModelList
                                              .removeAt(index);
                                          Get.back();
                                        },
                                        onSecondButtonClicked: () => Get.back(),
                                      );
                                    },
                                    child: const CircleAvatar(
                                      radius: 10,
                                      foregroundColor: Colors.white,
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8),
                                            bottomLeft: Radius.circular(8),
                                          ),
                                          color: Colors.black54,
                                        ),
                                        height: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Text(
                                            path.basename(
                                              _addDesignController
                                                  .createDesignVideoModelList[
                                                      index]
                                                  .videoPath,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getSelectSupplierWidget() {
    return [
      InkWell(
        onTap: () => _openBottomSheetForSupplierSelection(),
        child: TextFormField(
          enabled: false,
          cursorColor: Get.theme.primaryColor,
          controller: _addDesignController.supplierController,
          style: TextStyle(
            color: Get.theme.primaryColor,
            fontSize: Get.textTheme.titleMedium!.fontSize,
          ),
          decoration: CommonStyle.getCommonTextFormFiledDecoration(
            label: "Supplier*",
            hintText: '',
            prefixIcon: Icon(
              Icons.person_rounded,
              color: Get.theme.primaryColor,
            ),
            suffixIcon: Icon(
              Icons.arrow_drop_down_rounded,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 24.0,
      ),
    ];
  }

  List<Widget> getSelectCategoryWidget() {
    return [
      InkWell(
        onTap: () => _openBottomSheetForCategorySelection(),
        child: TextFormField(
          enabled: false,
          cursorColor: Get.theme.primaryColor,
          controller: _addDesignController.categoryController,
          style: TextStyle(
            color: Get.theme.primaryColor,
            fontSize: Get.textTheme.titleMedium!.fontSize,
          ),
          decoration: CommonStyle.getCommonTextFormFiledDecoration(
            label: "Category*",
            hintText: '',
            prefixIcon: Icon(
              Icons.category_rounded,
              color: Get.theme.primaryColor,
            ),
            suffixIcon: Icon(
              Icons.arrow_drop_down_rounded,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 24.0,
      ),
    ];
  }

  List<Widget> getSelectGoldCaretWidget() {
    return [
      InkWell(
        onTap: () => _openBottomSheetForGoldCaretSelection(),
        child: TextFormField(
          enabled: false,
          cursorColor: Get.theme.primaryColor,
          controller: _addDesignController.goldCaretController,
          style: TextStyle(
            color: Get.theme.primaryColor,
            fontSize: Get.textTheme.titleMedium!.fontSize,
          ),
          decoration: CommonStyle.getCommonTextFormFiledDecoration(
            label: "Gold-Caret*",
            hintText: '',
            prefixIcon: Icon(
              Icons.eco_rounded,
              color: Get.theme.primaryColor,
            ),
            suffixIcon: Icon(
              Icons.arrow_drop_down_rounded,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 24.0,
      ),
    ];
  }

  List<Widget> getSelectSubCategoryWidget() {
    return [
      InkWell(
        onTap: () {
          if (_addDesignController.categoryController.text.trim().isNotEmpty) {
            _openBottomSheetForSubCategorySelection();
          } else {
            UiUtils.errorSnackBar(message: "Please Select Category");
          }
        },
        child: TextFormField(
          enabled: false,
          cursorColor: Get.theme.primaryColor,
          controller: _addDesignController.subCategoryController,
          style: TextStyle(
            color: Get.theme.primaryColor,
            fontSize: Get.textTheme.titleMedium!.fontSize,
          ),
          decoration: CommonStyle.getCommonTextFormFiledDecoration(
            label: "Sub-Category*",
            hintText: '',
            prefixIcon: Icon(
              Icons.category_rounded,
              color: Get.theme.primaryColor,
            ),
            suffixIcon: Icon(
              Icons.arrow_drop_down_rounded,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 24.0,
      ),
    ];
  }

  List<Widget> getDesignNameTextFieldWidget() {
    return [
      TextFormField(
        cursorColor: Get.theme.primaryColor,
        controller: _addDesignController.designNameController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontSize: Get.textTheme.titleMedium!.fontSize,
        ),
        decoration: CommonStyle.getCommonTextFormFiledDecoration(
          label: 'Design Name*',
          hintText: 'Enter Design Name',
          prefixIcon: Icon(
            Icons.design_services_rounded,
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      const SizedBox(
        height: 24.0,
      ),
    ];
  }

  Widget getDesignQtyTextFieldWidget() {
    return TextFormField(
      onChanged: (_) => _addDesignController.weights.clear(),
      cursorColor: Get.theme.primaryColor,
      enableInteractiveSelection: false,
      controller: _addDesignController.quantityController,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        MaxValueTextInputFormatter(500),
      ],
      style: TextStyle(
        color: Get.theme.primaryColor,
        fontSize: Get.textTheme.titleMedium!.fontSize,
      ),
      decoration: CommonStyle.getCommonTextFormFiledDecoration(
        label: 'Qty*',
        hintText: 'Enter Quantity',
        prefixIcon: Icon(
          Icons.design_services_rounded,
          color: Get.theme.primaryColor,
        ),
      ),
    );
  }

  List<Widget> getDealerCommissionTextFieldWidget() {
    return [
      TextFormField(
        cursorColor: Get.theme.primaryColor,
        controller: _addDesignController.dealerCommissionController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [
          MaxValueTextInputFormatter(100),
        ],
        maxLength: 5,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontSize: Get.textTheme.titleMedium!.fontSize,
        ),
        decoration: CommonStyle.getCommonTextFormFiledDecoration(
          label: 'Dealer Commission(%)*',
          hintText: 'Enter Dealer Commission',
          prefixIcon: Icon(
            Icons.percent_rounded,
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      const SizedBox(
        height: 24.0,
      ),
    ];
  }

  List<Widget> getSemiDealerCommissionTextFieldWidget() {
    return [
      TextFormField(
        cursorColor: Get.theme.primaryColor,
        controller: _addDesignController.semiDealerCommissionController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [
          MaxValueTextInputFormatter(100),
        ],
        maxLength: 5,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontSize: Get.textTheme.titleMedium!.fontSize,
        ),
        decoration: CommonStyle.getCommonTextFormFiledDecoration(
          label: 'Semi-Dealer Commission(%)*',
          hintText: 'Enter Semi-Dealer Commission',
          prefixIcon: Icon(
            Icons.percent_rounded,
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      const SizedBox(
        height: 24.0,
      ),
    ];
  }

  List<Widget> getShopKeeperCommissionTextFieldWidget() {
    return [
      TextFormField(
        cursorColor: Get.theme.primaryColor,
        controller: _addDesignController.shopkeeperCommissionController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [
          MaxValueTextInputFormatter(100),
        ],
        maxLength: 5,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontSize: Get.textTheme.titleMedium!.fontSize,
        ),
        decoration: CommonStyle.getCommonTextFormFiledDecoration(
          label: 'Shopkeeper Commission(%)*',
          hintText: 'Enter Shopkeeper Commission',
          prefixIcon: Icon(
            Icons.percent_rounded,
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      const SizedBox(
        height: 24.0,
      ),
    ];
  }

  void _openBottomSheetForCategorySelection() {
    Get.bottomSheet(
      CategorySelectionBottomSheetWidget(
          categoryController: _addDesignController.categoryController),
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  void _openBottomSheetForSupplierSelection() {
    Get.bottomSheet(
      SupplierSelectionBottomSheetWidget(
          supplierController: _addDesignController.supplierController),
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  void _openBottomSheetForGoldCaretSelection() {
    Get.bottomSheet(
      GoldCaretSelectionBottomSheetWidget(
          goldCaretController: _addDesignController.goldCaretController),
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  void _openBottomSheetForSubCategorySelection() {
    Get.bottomSheet(
      SubCategorySelectionBottomSheetWidget(
          subCategoryController: _addDesignController.subCategoryController),
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<AddDesignController>();
  }
}
