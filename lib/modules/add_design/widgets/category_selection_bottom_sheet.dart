import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/add_design/controllers/add_design_controller.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/widgets/something_went_wrong_widget.dart';

class CategorySelectionBottomSheetWidget extends StatelessWidget {
  CategorySelectionBottomSheetWidget({
    super.key,
    required this.categoryController,
  });

  final AddDesignController _addDesignController =
      Get.find<AddDesignController>();
  final CommonController _commonController = Get.find<CommonController>();
  late final TextEditingController categoryController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: Get.height * 0.40,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _commonController.isLoadingCategory.value
            ? Center(
                child: SpinKitSpinningLines(
                  color: Get.theme.primaryColor,
                ),
              )
            : _commonController.errorStringCategory.value.isNotEmpty
                ? SomethingWentWrongWidget(
                    errorTxt: _commonController.errorStringCategory.value,
                    retryOnSomethingWentWrong: () =>
                        _commonController.getCategoryApiCall(),
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
                                CommonConstants.selectCategory,
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
                          itemCount: _commonController.categoryList.length,
                          separatorBuilder: (_, __) => Divider(
                            color: Get.theme.primaryColor,
                            thickness: 0.5,
                          ),
                          itemBuilder: (_, index) => ListTile(
                            onTap: () {
                              Get.back();
                              _addDesignController.selectedSubCategoryId = -1;
                              _addDesignController.subCategoryController.text = '';
                              _commonController.subCategoryList.value = [];
                              categoryController.text =
                                  _commonController.categoryList[index].name;
                              _addDesignController.selectedCategoryId =
                                  _commonController.categoryList[index].id;
                              _commonController.getSubCategoryApiCall(
                                categoryId:
                                    _addDesignController.selectedCategoryId,
                              );
                            },
                            leading: Card(
                              elevation: 3.0,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    _commonController.categoryList[index].icon,
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
                            trailing: _addDesignController.selectedCategoryId ==
                                    _commonController.categoryList[index].id
                                ? Icon(
                                    Icons.check_circle,
                                    color: Get.theme.primaryColor,
                                  )
                                : const SizedBox(),
                            title: Text(
                              _commonController.categoryList[index].name,
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
