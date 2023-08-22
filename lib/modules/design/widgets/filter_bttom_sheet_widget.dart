import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/modules/design/controllers/filter_design_controller.dart';
import 'package:nkm_admin_panel/utils/ui/common_style.dart';
import 'package:nkm_admin_panel/utils/ui/max_value_text_input_formatter.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';
import 'package:nkm_admin_panel/widgets/something_went_wrong_widget.dart';

class FilterBottomSheetWidget extends StatelessWidget {
  final TextEditingController _designNameController = TextEditingController();
  final TextEditingController _articleSeriesNoController =
      TextEditingController();
  late int _categoryId = -1;
  final TextEditingController _categoryController = TextEditingController();
  late int _subCategoryId = -1;
  final TextEditingController _subCategoryController = TextEditingController();

  final CommonController _commonController = Get.find<CommonController>();
  final FilterDesignController _filterDesignController =
      Get.find<FilterDesignController>();

  FilterBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    _designNameController.text =
        _filterDesignController.designName.value.trim();
    _articleSeriesNoController.text =
        _filterDesignController.articleNo.value == -1
            ? ''
            : _filterDesignController.articleNo.value.toString();
    _categoryController.text =
        _filterDesignController.selectedCategoryName.trim();
    _categoryId = _filterDesignController.selectedCategoryId.value;
    _subCategoryController.text =
        _filterDesignController.selectedSubCategoryName.trim();
    _subCategoryId = _filterDesignController.selectedSubCategoryId.value;

    return Container(
      height: Get.height * 0.54,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  "Apply Filters",
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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    ...getDesignNameTextFieldWidget(),
                    ...getArticleSeriesNumberTextFieldWidget(),
                    ...getSelectCategoryWidget(),
                    ...getSelectSubCategoryWidget(),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _getFilterButtons(),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDesignNameTextFieldWidget() {
    return [
      TextFormField(
        cursorColor: Get.theme.primaryColor,
        controller: _designNameController,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        maxLength: 60,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontSize: Get.textTheme.titleMedium!.fontSize,
        ),
        decoration: CommonStyle.getCommonTextFormFiledDecoration(
          label: 'Design Name',
          hintText: 'Enter Design Name',
          prefixIcon: Icon(
            Icons.design_services_rounded,
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      const SizedBox(
        height: 16.0,
      ),
    ];
  }

  List<Widget> getArticleSeriesNumberTextFieldWidget() {
    return [
      TextFormField(
        cursorColor: Get.theme.primaryColor,
        controller: _articleSeriesNoController,
        textInputAction: TextInputAction.done,
        maxLength: 8,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontSize: Get.textTheme.titleMedium!.fontSize,
        ),
        decoration: InputDecoration(
          prefixText: 'NK',
          prefixStyle: TextStyle(
            fontSize: Get.textTheme.titleMedium!.fontSize,
          ),
          prefixIcon: Icon(
            Icons.numbers,
            color: Get.theme.primaryColor,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 12.0),
          label: Text(
            'Article Series no.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: Get.textTheme.titleLarge!.fontSize,
            ),
          ),
          labelStyle: TextStyle(
            letterSpacing: 1.1,
            color: Get.theme.primaryColor,
          ),
          hintText: 'Enter Article Series no.',
          hintStyle: TextStyle(
            letterSpacing: 1.1,
            color: Colors.grey.shade600,
          ),
          counterText: '',
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(
              color: Get.theme.primaryColor,
              width: 1.8,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(
              color: Get.theme.primaryColor,
              width: 1.8,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(
              color: Get.theme.primaryColor,
              width: 1.8,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.8,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.8,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 16.0,
      ),
    ];
  }

  List<Widget> getSelectCategoryWidget() {
    return [
      TextFormField(
        // enabled: false,
        readOnly: true,
        onTap: () => _openCategorySelectionForFilterBottomSheet(),
        cursorColor: Get.theme.primaryColor,
        controller: _categoryController,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontSize: Get.textTheme.titleMedium!.fontSize,
        ),
        decoration: CommonStyle.getCommonTextFormFiledDecoration(
          label: "Category",
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
      const SizedBox(
        height: 16.0,
      ),
    ];
  }

  List<Widget> getSelectSubCategoryWidget() {
    return [
      TextFormField(
        readOnly: true,
        onTap: () {
          if (_categoryId == -1) {
            UiUtils.errorSnackBar(message: "Please Select Category");
            return;
          } else {
            _openSubCategorySelectionForFilterBottomSheet();
            return;
          }
        },
        cursorColor: Get.theme.primaryColor,
        controller: _subCategoryController,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontSize: Get.textTheme.titleMedium!.fontSize,
        ),
        decoration: CommonStyle.getCommonTextFormFiledDecoration(
          label: "Sub-Category",
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
      const SizedBox(
        height: 16.0,
      ),
    ];
  }

  void _openCategorySelectionForFilterBottomSheet() {
    Get.bottomSheet(
      Obx(
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
                          _commonController.errorStringCategory.value,
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
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize!,
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
                                _categoryId =
                                    _commonController.categoryList[index].id;
                                _categoryController.text =
                                    _commonController.categoryList[index].name;
                                _commonController.getSubCategoryApiCall(
                                  categoryId: _categoryId,
                                );
                                _subCategoryId = -1;
                                _subCategoryController.clear();
                              },
                              leading: Card(
                                elevation: 3.0,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: _commonController
                                      .categoryList[index].icon,
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
                              trailing: _filterDesignController
                                          .selectedCategoryId.value ==
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
      ),
      isScrollControlled: true,
    );
  }

  void _openSubCategorySelectionForFilterBottomSheet() {
    Get.bottomSheet(
      Obx(
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
                          _commonController.errorStringSubCategory.value,
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
                                    fontSize:
                                        Get.textTheme.titleLarge!.fontSize!,
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
                                _subCategoryId =
                                    _commonController.subCategoryList[index].id;
                                _subCategoryController.text = _commonController
                                    .subCategoryList[index].name;
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
                              trailing: _filterDesignController
                                          .selectedSubCategoryId.value ==
                                      _commonController
                                          .subCategoryList[index].id
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
      ),
      isScrollControlled: true,
    );
  }

  Widget _getFilterButtons() {
    return Row(
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
            onPressed: () {
              _categoryId = -1;
              _subCategoryId = -1;
              _designNameController.clear();
              _subCategoryController.clear();
              _categoryController.clear();
              _articleSeriesNoController.clear();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Clear",
                style: TextStyle(
                  color: Get.theme.primaryColor,
                  fontSize: Get.textTheme.titleMedium!.fontSize,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16.0,
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
            onPressed: () => _applyFilter(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Apply Filter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Get.textTheme.titleMedium!.fontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _applyFilter() {
    try {
      _filterDesignController.designName.value =
          _designNameController.text.trim().isEmpty
              ? ''
              : _designNameController.text.trim();
      _filterDesignController.articleNo.value =
          _articleSeriesNoController.text.trim().isEmpty
              ? -1
              : int.parse(_articleSeriesNoController.text.trim());
      _filterDesignController.selectedCategoryId.value = _categoryId;
      _filterDesignController.selectedCategoryName =
          _categoryController.text.trim().isEmpty
              ? ''
              : _categoryController.text.trim();
      _filterDesignController.selectedSubCategoryId.value = _subCategoryId;
      _filterDesignController.selectedSubCategoryName =
          _subCategoryController.text.trim().isEmpty
              ? ''
              : _subCategoryController.text.trim();
      _filterDesignController.getDesignListApiCall();

      if (_designNameController.text.trim().isEmpty &&
          _articleSeriesNoController.text.trim().isEmpty &&
          _categoryId == -1 &&
          _subCategoryId == -1) {
        _filterDesignController.isFilterApplied.value = false;
        Get.back(result: true);
        return;
      }

      _filterDesignController.isFilterApplied.value = true;
      Get.back(result: true);
      return;
    } catch (err) {
      UiUtils.errorSnackBar(message: err.toString());
      return;
    }
  }
}
