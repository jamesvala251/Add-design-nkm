import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/add_design/controllers/add_design_controller.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/widgets/something_went_wrong_widget.dart';

class SubCategorySelectionBottomSheetWidget extends StatelessWidget {
  SubCategorySelectionBottomSheetWidget({
    super.key,
    required this.subCategoryController,
  });

  late final TextEditingController subCategoryController;
  final CommonController _commonController = Get.find<CommonController>();
  final AddDesignController _addDesignController =
      Get.find<AddDesignController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: Get.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _commonController.isLoadingSubCategory.value
            ? Center(
                child: SpinKitSpinningLines(
                  color: Get.theme.primaryColor,
                ),
              )
            : _commonController.errorStringSubCategory.value.isNotEmpty
                ? SomethingWentWrongWidget(
                    errorTxt: _commonController.errorStringSubCategory.value,
                    retryOnSomethingWentWrong: () =>
                        _commonController.getSubCategoryApiCall(
                      categoryId: _addDesignController.selectedCategoryId,
                    ),
                  )
                : Column(
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
                                CommonConstants.selectSubCategory,
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
                      const SizedBox(
                        height: 12.0,
                      ),
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _commonController.subCategoryList.length,
                          separatorBuilder: (_, __) => Divider(
                            color: Get.theme.primaryColor,
                            thickness: 0.5,
                          ),
                          itemBuilder: (_, index) => ListTile(
                            onTap: () {
                              Get.back();
                              subCategoryController.text =
                                  _commonController.subCategoryList[index].name;
                              _addDesignController.selectedSubCategoryId =
                                  _commonController.subCategoryList[index].id;
                            },
                            leading: Card(
                              elevation: 3.0,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: _commonController
                                    .subCategoryList[index].icon,
                                fit: BoxFit.fill,
                                placeholder: (_, __) => SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: SpinKitSpinningLines(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Center(
                                    child: Text("NA"),
                                  ),
                                ),
                              ),
                            ),
                            trailing: _addDesignController
                                        .selectedSubCategoryId ==
                                    _commonController.subCategoryList[index].id
                                ? Icon(
                                    Icons.check_circle,
                                    color: Get.theme.primaryColor,
                                  )
                                : const SizedBox(),
                            title: Text(
                              _commonController.subCategoryList[index].name,
                              style: TextStyle(
                                fontSize: Get.textTheme.titleLarge!.fontSize,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                    ],
                  ),
      ),
    );
  }
}
