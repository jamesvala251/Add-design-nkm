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
    as design_list_model;

class DesignDetailsBottomSheetWidget extends StatelessWidget {
  final design_list_model.Data item;
  final CommonController commonController = Get.find<CommonController>();

  DesignDetailsBottomSheetWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: Get.textTheme.titleLarge!.fontSize!,
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 12,
                  icon: const Icon(
                    Icons.close_rounded,
                  ),
                  color: Get.theme.primaryColor,
                )
              ],
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Get.theme.primaryColor,
                  Get.theme.primaryColor,
                  Get.theme.primaryColor,
                  Get.theme.primaryColor,
                  Colors.transparent
                ],
                stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      item.articleSeries.isNotEmpty
                          ? Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'article_from_to'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          Get.textTheme.titleSmall!.fontSize,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  _getChipWidget(
                                    chipContent:
                                        '${item.goldCaret.first.articalFrom} to ${item.goldCaret.first.articalTo}',
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      Container(
                        width: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Colors.transparent
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      item.goldCaret.isNotEmpty
                          ? Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'quantity_caret'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          Get.textTheme.titleSmall!.fontSize,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  SingleChildScrollView(
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    clipBehavior: Clip.hardEdge,
                                    child: Row(
                                      children: [
                                        ...List.generate(
                                          item.goldCaret.length,
                                          (index) => _getChipWidget(
                                            chipContent:
                                                '${item.goldCaret[index].qty} | ${item.goldCaret[index].caret}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                item.goldCaret.isNotEmpty && item.articleSeries.isNotEmpty
                    ? Container(
                        height: 1, // Height of the divider
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Colors.transparent
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  height:
                      item.goldCaret.isNotEmpty && item.articleSeries.isNotEmpty
                          ? 12
                          : 0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'supplier_name'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        Get.textTheme.titleSmall!.fontSize,
                                  ),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  item.supplier.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        Get.textTheme.titleMedium!.fontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Get.theme.primaryColor,
                                  Get.theme.primaryColor,
                                  Get.theme.primaryColor,
                                  Get.theme.primaryColor,
                                  Colors.transparent
                                ],
                                stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          item.goldCaret.first.designWeight.isNotEmpty
                              ? Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'weight'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: Get
                                              .textTheme.titleSmall!.fontSize,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      SingleChildScrollView(
                                        padding: EdgeInsets.zero,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        clipBehavior: Clip.hardEdge,
                                        child: Row(
                                          children: [
                                            ...List.generate(
                                              item.goldCaret.first.designWeight
                                                  .length,
                                              (index) =>
                                                  _getChipForWeightWidget(
                                                designWeight: item
                                                    .goldCaret
                                                    .first
                                                    .designWeight[index]
                                                    .weight,
                                                articleNumber: item
                                                    .goldCaret
                                                    .first
                                                    .designWeight[index]
                                                    .articleNumber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _getChildRow(
                      lbl1: 'category'.tr,
                      value1: item.category.name,
                      lbl2: 'sub_category'.tr,
                      value2: item.subCategory.name,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _getChildRow(
                      lbl1: 'dealer_commission'.tr,
                      value1: item.dealerCommission,
                      lbl2: 'semi_dealer_commission'.tr,
                      value2: item.semiDealerCommission,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _getSingleChildRow(
                      lbl1: 'shopkeeper_commission'.tr,
                      value1: item.shopkeeperCommission,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    if (item.images.isNotEmpty || item.videos.isNotEmpty) ...[
                      Container(
                        height: 1, // Height of the divider
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Get.theme.primaryColor,
                              Colors.transparent
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: Text(
                          "design_image_videos".tr,
                          style: TextStyle(
                            fontSize: Get.textTheme.titleLarge!.fontSize,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            if (item.images.isNotEmpty)
                              ...List.generate(
                                item.images.length,
                                (index) => InkWell(
                                  onTap: () => Get.toNamed(
                                    AppRoutes.networkImageViewScreen,
                                    arguments: {
                                      RouteConstants.title: item.name,
                                      RouteConstants.imageUrl:
                                          item.images[index].url,
                                    },
                                  ),
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    margin: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: 20,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: Get.theme.primaryColor,
                                        width: 1.4,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Transform.scale(
                                        scale: 1.6,
                                        child: CachedNetworkImage(
                                          imageUrl: item.images[index].url,
                                          fit: BoxFit.fill,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: SpinKitSpinningLines(
                                              color: Get.theme.primaryColor,
                                              size: 30,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
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
                                ),
                              ),
                            if (item.videos.isNotEmpty)
                              InkWell(
                                onTap: () => Get.toNamed(
                                  AppRoutes.networkVideoViewScreen,
                                  arguments: {
                                    RouteConstants.videoUrl:
                                        item.videos.first.url,
                                    RouteConstants.title: item.name,
                                  },
                                ),
                                highlightColor: Colors.transparent,
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  margin: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 20,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: Get.theme.primaryColor,
                                      width: 1.4,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: FutureBuilder(
                                      future: VideoThumbnail.thumbnailFile(
                                        video: item.videos.first.url,
                                        // thumbnailPath: (await getTemporaryDirectory()).path,
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
                                              File(snapShot.data?.path ?? ''),
                                            ),
                                            Center(
                                              child: Icon(
                                                Icons.play_circle_fill_rounded,
                                                color: Get.theme.primaryColor,
                                                size: 40,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card _getChipWidget({required String chipContent}) {
    return Card(
      elevation: 2,
      color: Get.theme.primaryColor,
      margin: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12,
        ),
        child: Text(
          chipContent,
          style: TextStyle(
            fontSize: Get.textTheme.titleSmall!.fontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Card _getChipForWeightWidget(
      {required int designWeight, required String articleNumber}) {
    return Card(
      elevation: 2,
      color: Get.theme.primaryColor,
      margin: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 16,
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                articleNumber,
                style: TextStyle(
                  fontSize: Get.textTheme.titleSmall!.fontSize,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 1,// Height of the divider
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
                  Icon(
                    Icons.balance_rounded,
                    size: Get.textTheme.titleSmall!.fontSize,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    '$designWeight ${commonController.adminGetSettingsModel != null ? commonController.adminGetSettingsModel!.data.designWeightUnit : 'mg'}',
                    style: TextStyle(
                      fontSize: Get.textTheme.titleSmall!.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IntrinsicHeight _getChildRow({
    required String lbl1,
    required String value1,
    required String lbl2,
    required String value2,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  lbl1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleSmall!.fontSize,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  value1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Get.theme.primaryColor,
                  Get.theme.primaryColor,
                  Get.theme.primaryColor,
                  Get.theme.primaryColor,
                  Colors.transparent
                ],
                stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  lbl2,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleSmall!.fontSize,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  value2,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IntrinsicHeight _getSingleChildRow({
    required String lbl1,
    required String value1,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  lbl1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleSmall!.fontSize,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  value1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
