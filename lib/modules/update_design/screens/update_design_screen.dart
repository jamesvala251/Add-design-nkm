import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/constants/route_constants.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/modules/design/models/design_list_model.dart'
    as design_list;
import 'package:nkm_admin_panel/modules/update_design/controllers/update_design_controller.dart';
import 'package:nkm_admin_panel/modules/update_design/widgets/update_category_selection_bottom_sheet.dart';
import 'package:nkm_admin_panel/modules/update_design/widgets/update_sub_category_selection_bottom_sheet.dart';
import 'package:nkm_admin_panel/modules/update_design/widgets/update_supplier_selection_bottom_sheet.dart';
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';
import 'package:nkm_admin_panel/utils/ui/common_style.dart';
import 'package:nkm_admin_panel/utils/ui/max_value_text_input_formatter.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as path;

class UpdateDesignScreen extends StatefulWidget {
  const UpdateDesignScreen({super.key});

  @override
  State<UpdateDesignScreen> createState() => _UpdateDesignScreenState();
}

class _UpdateDesignScreenState extends State<UpdateDesignScreen> {
  late design_list.Data _designListItem;
  final UpdateDesignController _updateDesignController =
      Get.put(UpdateDesignController());
  final CommonController _commonController = Get.find<CommonController>();

  @override
  void initState() {
    super.initState();
    _designListItem = Get.arguments as design_list.Data;
    _updateDesignController.initData(designListItemModel: _designListItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Design"),
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
              getShopKeeperCommissionTextFieldWidget(),
              getWeightSelectionWidget(),
              getHallmarkSelectionWidget(),
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
                  if (_updateDesignController.selectedSupplierId == -1) {
                    UiUtils.errorSnackBar(message: 'Please select supplier!');
                    return;
                  } else if (_updateDesignController.selectedCategoryId == -1) {
                    UiUtils.errorSnackBar(message: 'Please select category!');
                    return;
                  } else if (_updateDesignController.selectedSubCategoryId ==
                      -1) {
                    UiUtils.errorSnackBar(
                        message: 'Please select sub-category!');
                    return;
                  } else if (_updateDesignController
                      .designNameController.text.isEmpty) {
                    UiUtils.errorSnackBar(message: 'Please enter design name!');
                    return;
                  } else if (_updateDesignController
                      .dealerCommissionController.text.isEmpty) {
                    UiUtils.errorSnackBar(
                        message: 'Please enter dealer commission!');
                    return;
                  } else if (_updateDesignController
                      .semiDealerCommissionController.text.isEmpty) {
                    UiUtils.errorSnackBar(
                        message: 'Please enter semi-dealer commission!');
                    return;
                  } else if (_updateDesignController
                      .shopkeeperCommissionController.text.isEmpty) {
                    UiUtils.errorSnackBar(
                        message: 'Please enter shopkeeper commission!');
                    return;
                  } else if (_updateDesignController
                          .updateDesignImageModelList.isEmpty &&
                      _designListItem.images.isEmpty) {
                    UiUtils.errorSnackBar(
                        message:
                            'Please select the product image by clicking on the "Select Image" button!');
                    return;
                  }
                  _updateDesignController.updateDesignApiCall(
                    designId: _designListItem.id,
                  );
                  return;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Update",
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

  Widget getImageSelectionWidget() {
    return Card(
      margin: const EdgeInsets.only(top: 24),
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
                  onPressed: () => _updateDesignController.selectImage(),
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
                height: _updateDesignController
                            .updateDesignImageModelList.isEmpty &&
                        _designListItem.images.isEmpty
                    ? 0.0
                    : 12.0,
              ),
            ),
            Obx(
              () => SizedBox(
                height: _updateDesignController
                            .updateDesignImageModelList.isEmpty &&
                        _designListItem.images.isEmpty
                    ? 0
                    : 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => _designListItem.images.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _designListItem.images.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: Get.theme.primaryColor),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Transform.scale(
                                              scale: 1.6,
                                              child: CachedNetworkImage(
                                                imageUrl: _designListItem
                                                    .images[index].url,
                                                fit: BoxFit.fill,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Center(
                                                  child: SpinKitSpinningLines(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    size: 30,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                ),
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
                                                  Get.back();
                                                  _updateDesignController
                                                      .deleteMediaDesignApiCall(
                                                    isDeletedMediaIsImage: true,
                                                    mediaId: _designListItem
                                                        .images[index].id,
                                                    designListItem:
                                                        _designListItem,
                                                    deleteMediaIndex: index,
                                                  );
                                                },
                                                onSecondButtonClicked: () =>
                                                    Get.back(),
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                  color: Colors.black54,
                                                ),
                                                height: 20,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: Text(
                                                    path.basename(
                                                      _designListItem
                                                          .images[index].url,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : const SizedBox(),
                      ),
                      Obx(
                        () => _updateDesignController
                                .updateDesignImageModelList.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: _updateDesignController
                                    .updateDesignImageModelList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) => InkWell(
                                  onLongPress: () {},
                                  onTap: () => Get.toNamed(
                                    AppRoutes.imageViewForDeviceScreen,
                                    arguments: {
                                      RouteConstants.title:
                                          (index + 1).toString(),
                                      RouteConstants.imagePath:
                                          _updateDesignController
                                              .updateDesignImageModelList[index]
                                              .imgPath
                                    },
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: Get.theme.primaryColor),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Transform.scale(
                                              scale: 1.2,
                                              child: Image.file(
                                                File(
                                                  _updateDesignController
                                                      .updateDesignImageModelList[
                                                          index]
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
                                                  _updateDesignController
                                                      .updateDesignImageModelList
                                                      .removeAt(index);
                                                  Get.back();
                                                },
                                                onSecondButtonClicked: () =>
                                                    Get.back(),
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                  color: Colors.black54,
                                                ),
                                                height: 20,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: Text(
                                                    path.basename(
                                                      _updateDesignController
                                                          .updateDesignImageModelList[
                                                              index]
                                                          .imgPath,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                              )
                            : const SizedBox(),
                      ),
                    ],
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
                  onPressed: () => _updateDesignController.selectVideo(),
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
                height: _updateDesignController
                            .updateDesignVideoModelList.isEmpty &&
                        _designListItem.videos.isEmpty
                    ? 0.0
                    : 12.0,
              ),
            ),
            Obx(
              () => SizedBox(
                height: _designListItem.videos.isEmpty &&
                        _updateDesignController
                            .updateDesignVideoModelList.isEmpty
                    ? 0
                    : 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => _designListItem.videos.isNotEmpty
                            ? ListView.separated(
                                separatorBuilder: (_, __) => const SizedBox(
                                  width: 8.0,
                                  height: 40,
                                ),
                                shrinkWrap: true,
                                itemCount: _designListItem.videos.length,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (_, index) => Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Get.theme.primaryColor),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: FutureBuilder(
                                            future:
                                                VideoThumbnail.thumbnailData(
                                              video: _designListItem
                                                  .videos[index].url,
                                              imageFormat: ImageFormat.JPEG,
                                            ),
                                            builder: (ctx, snapShot) {
                                              if (snapShot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: SpinKitSpinningLines(
                                                    color:
                                                        Get.theme.primaryColor,
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
                                                  Image.memory(snapShot.data!),
                                                  const Center(
                                                    child: Icon(
                                                      Icons
                                                          .play_circle_fill_rounded,
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
                                                Get.back();
                                                _updateDesignController
                                                    .deleteMediaDesignApiCall(
                                                  isDeletedMediaIsImage: false,
                                                  mediaId: _designListItem
                                                      .videos[index].id,
                                                  designListItem:
                                                      _designListItem,
                                                  deleteMediaIndex: index,
                                                );
                                              },
                                              onSecondButtonClicked: () =>
                                                  Get.back(),
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
                                                  bottomRight:
                                                      Radius.circular(8),
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                ),
                                                color: Colors.black54,
                                              ),
                                              height: 20,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                child: Text(
                                                  path.basename(
                                                    _designListItem
                                                        .videos[index].url,
                                                  ),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      Obx(
                        () => _updateDesignController
                                .updateDesignVideoModelList.isNotEmpty
                            ? ListView.separated(
                                separatorBuilder: (_, __) => const SizedBox(
                                  width: 8.0,
                                  height: 40,
                                ),
                                shrinkWrap: true,
                                itemCount: _updateDesignController
                                    .updateDesignVideoModelList.length,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (_, index) => InkWell(
                                  onLongPress: () {},
                                  onTap: () => Get.toNamed(
                                    AppRoutes.deviceVideoViewScreen,
                                    arguments: {
                                      RouteConstants.title:
                                          (index + 1).toString(),
                                      RouteConstants.videoPath:
                                          _updateDesignController
                                              .updateDesignVideoModelList[index]
                                              .videoPath
                                    },
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: Get.theme.primaryColor),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                             child: Text('test')// FutureBuilder(
                                            //   future:
                                            //       VideoThumbnail.thumbnailFile(
                                            //     video: _updateDesignController
                                            //         .updateDesignVideoModelList[
                                            //             index]
                                            //         .videoPath,
                                            //     imageFormat: ImageFormat.JPEG,
                                            //   ),
                                            //   builder: (ctx, snapShot) {
                                            //     if (snapShot.connectionState ==
                                            //         ConnectionState.waiting) {
                                            //       return Center(
                                            //         child: SpinKitSpinningLines(
                                            //           color: Get
                                            //               .theme.primaryColor,
                                            //           size: 30,
                                            //         ),
                                            //       );
                                            //     }
                                            //
                                            //     if (snapShot.data == null) {
                                            //       return const Center(
                                            //         child: Icon(
                                            //           Icons.error_rounded,
                                            //           color: Colors.red,
                                            //         ),
                                            //       );
                                            //     }
                                            //     return Stack(
                                            //       children: [
                                            //         Image.file(
                                            //           File(snapShot.data ?? ''),
                                            //         ),
                                            //         const Center(
                                            //           child: Icon(
                                            //             Icons
                                            //                 .play_circle_fill_rounded,
                                            //             color: Colors.white,
                                            //             size: 24,
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     );
                                            //   },
                                            // ),
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
                                                  _updateDesignController
                                                      .updateDesignVideoModelList
                                                      .removeAt(index);
                                                  Get.back();
                                                },
                                                onSecondButtonClicked: () =>
                                                    Get.back(),
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                  color: Colors.black54,
                                                ),
                                                height: 20,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: Text(
                                                    path.basename(
                                                      _updateDesignController
                                                          .updateDesignVideoModelList[
                                                              index]
                                                          .videoPath,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                              )
                            : const SizedBox(),
                      ),
                    ],
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
          controller: _updateDesignController.supplierController,
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
          controller: _updateDesignController.categoryController,
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

  List<Widget> getSelectSubCategoryWidget() {
    return [
      InkWell(
        onTap: () {
          if (_updateDesignController.categoryController.text
              .trim()
              .isNotEmpty) {
            _openBottomSheetForSubCategorySelection();
          } else {
            UiUtils.errorSnackBar(message: "Please Select Category");
          }
        },
        child: TextFormField(
          enabled: false,
          cursorColor: Get.theme.primaryColor,
          controller: _updateDesignController.subCategoryController,
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
        controller: _updateDesignController.designNameController,
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
                  onPressed: () =>
                      Get.toNamed(AppRoutes.updateDesignWeightsScreen),
                  child: Text(
                    "Update Weight*",
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
            const SizedBox(
              height: 8.0,
            ),
            Obx(
              () => SizedBox(
                height: 46,
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(
                    width: 8.0,
                    height: 32,
                  ),
                  itemCount: _updateDesignController
                      .updateDesignWeightModelList.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, index) => Container(
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _updateDesignController
                                .updateDesignWeightModelList[index]
                                .articleNumber,
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 1, // Height of the divider
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
                                stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                          Row(
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
                                  '${_updateDesignController.updateDesignWeightModelList[index].weight.value} ${_commonController.adminGetSettingsModel != null ? _commonController.adminGetSettingsModel!.data.designWeightUnit : 'mg'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
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

  Widget getHallmarkSelectionWidget() {
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
                  onPressed: () =>
                      Get.toNamed(AppRoutes.updateDesignHallmarkScreen),
                  child: Text(
                    "Update Hallmark*",
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
                  'Note :- You are required to add a hallmark for each quantity you have entered.',
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
            const SizedBox(
              height: 8.0,
            ),
            Obx(
                  () => SizedBox(
                height: 46,
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(
                    width: 8.0,
                    height: 32,
                  ),
                  itemCount: _updateDesignController
                      .updateDesignHallmarkModelList.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, index) => Container(
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _updateDesignController
                                .updateDesignHallmarkModelList[index]
                                .articleNumber,
                            style: TextStyle(
                              fontSize: Get.textTheme.titleSmall!.fontSize,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 1, // Height of the divider
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
                                stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                          Row(
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
                                  _updateDesignController.updateDesignHallmarkModelList[index].hallmark.value,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
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

  List<Widget> getDealerCommissionTextFieldWidget() {
    return [
      TextFormField(
        cursorColor: Get.theme.primaryColor,
        controller: _updateDesignController.dealerCommissionController,
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
        controller: _updateDesignController.semiDealerCommissionController,
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

  Widget getShopKeeperCommissionTextFieldWidget() {
    return TextFormField(
      cursorColor: Get.theme.primaryColor,
      controller: _updateDesignController.shopkeeperCommissionController,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.done,
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
    );
  }

  void _openBottomSheetForCategorySelection() {
    Get.bottomSheet(
      UpdateCategorySelectionBottomSheetWidget(
          categoryController: _updateDesignController.categoryController),
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  void _openBottomSheetForSupplierSelection() {
    Get.bottomSheet(
      UpdateSupplierSelectionBottomSheetWidget(
          supplierController: _updateDesignController.supplierController),
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  void _openBottomSheetForSubCategorySelection() {
    Get.bottomSheet(
      UpdateSubCategorySelectionBottomSheetWidget(
          subCategoryController: _updateDesignController.subCategoryController),
      isDismissible: true,
      isScrollControlled: true,
    );
  }
}
