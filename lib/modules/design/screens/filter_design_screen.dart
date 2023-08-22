import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/design/controllers/filter_design_controller.dart';
import 'package:nkm_admin_panel/modules/design/widgets/design_list_item_filter.dart';
import 'package:nkm_admin_panel/modules/design/widgets/filter_bttom_sheet_widget.dart';
import 'package:nkm_admin_panel/widgets/loading_widget.dart';
import 'package:nkm_admin_panel/widgets/no_data_found_widget.dart';
import 'package:nkm_admin_panel/widgets/something_went_wrong_widget.dart';

class FilterDesignScreen extends StatefulWidget {
  const FilterDesignScreen({super.key});

  @override
  State<FilterDesignScreen> createState() => _FilterDesignScreenState();
}

class _FilterDesignScreenState extends State<FilterDesignScreen> {
  final FilterDesignController _filterDesignController =
      Get.find<FilterDesignController>();
  final ScrollController _scrollController = ScrollController();
  final RxBool _displayScrollToTop = false.obs;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    _filterDesignController.getDesignListApiCall();
    _scrollController.addListener(
      () {
        if (_scrollController.offset >= 400) {
          _displayScrollToTop.value = true;
        } else {
          _displayScrollToTop.value = false;
        }

        if (!_filterDesignController.isLoadingDesignList.value &&
            !_filterDesignController.isLoadingNextPage.value &&
            _filterDesignController.errorWhileLoadingNextPage.value.isEmpty &&
            _filterDesignController.hasMorePage.value &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent) {
          _filterDesignController.loadNextDesignListPage();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Design Filter'),
        actions: [
          IconButton(
            onPressed: () => openFilterBottomSheet(),
            icon: const Icon(Icons.filter_alt_rounded),
          ),
        ],
      ),
      body: Obx(
        () => _filterDesignController.isLoadingDesignList.value
            ? const LoadingWidget()
            : _filterDesignController.errorStringDesignList.value.isEmpty
                ? _filterDesignController.designList.isNotEmpty
                    ? _getDesignList
                    : NoDataFoundWidget(
                        retryOn: () {
                          _filterDesignController.getDesignListApiCall();
                        },
                      )
                : SomethingWentWrongWidget(
                    errorTxt:
                        _filterDesignController.errorStringDesignList.value,
                    retryOnSomethingWentWrong: () =>
                        _filterDesignController.errorStringDesignList.value,
                  ),
      ),
      floatingActionButton: Obx(
        () => _displayScrollToTop.value
            ? FloatingActionButton(
                heroTag: null,
                onPressed: () => _scrollToTop(),
                mini: true,
                clipBehavior: Clip.hardEdge,
                child: const Icon(
                  Icons.keyboard_double_arrow_up_rounded,
                  color: Colors.white,
                ),
              )
            : const SizedBox(),
      ),
      bottomNavigationBar: Obx(
        () => _filterDesignController.isLoadingDesignList.value
            ? const SizedBox()
            : _filterDesignController.isLoadingNextPage.value
                ? const SizedBox()
                : _filterDesignController.isFilterApplied.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 4,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Obx(
                                () => _filterDesignController
                                        .designName.isNotEmpty
                                    ? Card(
                                        color: Get.theme.primaryColor,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 12,
                                            right: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.design_services_rounded,
                                                size: Get.textTheme.titleMedium!
                                                    .fontSize,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'Design : ',
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .titleMedium!.fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                _filterDesignController
                                                    .designName.value,
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .titleMedium!.fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _filterDesignController
                                                      .removeParticularFilter(
                                                    designNameArg: true,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.cancel_rounded,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              Obx(
                                () => _filterDesignController.articleNo.value !=
                                        -1
                                    ? Card(
                                        color: Get.theme.primaryColor,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 12,
                                            right: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.numbers,
                                                size: Get.textTheme.titleMedium!
                                                    .fontSize,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'Article No. : ',
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .titleMedium!.fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                '${_filterDesignController.articleNo.value}',
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .titleMedium!.fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _filterDesignController
                                                      .removeParticularFilter(
                                                    articleNoArg: true,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.cancel_rounded,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              Obx(
                                () => _filterDesignController
                                            .selectedCategoryId.value !=
                                        -1
                                    ? Card(
                                        color: Get.theme.primaryColor,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 12,
                                            right: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.category_rounded,
                                                size: Get.textTheme.titleMedium!
                                                    .fontSize,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'Cate. : ',
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .titleMedium!.fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                _filterDesignController
                                                    .selectedCategoryName,
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .titleMedium!.fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _filterDesignController
                                                      .removeParticularFilter(
                                                    categoryArg: true,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.cancel_rounded,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              Obx(
                                () => _filterDesignController
                                            .selectedSubCategoryId.value !=
                                        -1
                                    ? Card(
                                        color: Get.theme.primaryColor,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 12,
                                            right: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.category_rounded,
                                                size: Get.textTheme.titleMedium!
                                                    .fontSize,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'Sub Cate. : ',
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .titleMedium!.fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                _filterDesignController
                                                    .selectedSubCategoryName,
                                                style: TextStyle(
                                                  fontSize: Get.textTheme
                                                      .titleMedium!.fontSize,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _filterDesignController
                                                      .removeParticularFilter(
                                                    subCateArg: true,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.cancel_rounded,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
      ),
    );
  }

  Column get _getDesignList => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                return await _filterDesignController.refreshDesignListApiCall();
              },
              child: ListView.builder(
                itemCount: _filterDesignController.designList.length,
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  bottom: 150,
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                itemBuilder: (_, index) => DesignListItemFilterWidget(
                  item: _filterDesignController.designList[index],
                  index: index,
                ),
              ),
            ),
          ),
          _getLoadMoreWidget(),
        ],
      );

  Widget _getLoadMoreWidget() {
    return Obx(
      () => _filterDesignController.isLoadingNextPage.value
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: SpinKitSpinningLines(
                      color: Get.theme.primaryColor,
                      size: 16,
                      itemCount: 2,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Page ${_filterDesignController.pageNo.value} is loading...',
                    style: TextStyle(
                      fontSize: Get.textTheme.bodySmall!.fontSize,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            )
          : _filterDesignController.errorWhileLoadingNextPage.value.isNotEmpty
              ? InkWell(
                  onTap: () {
                    _filterDesignController.loadNextDesignListPage();
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Get.theme.primaryColor,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          _filterDesignController
                              .errorWhileLoadingNextPage.value,
                          style: TextStyle(
                            fontSize: Get.textTheme.bodySmall!.fontSize,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(
        milliseconds: 400,
      ),
      curve: Curves.linear,
    );
  }

  void openFilterBottomSheet() {
    Get.bottomSheet(
      FilterBottomSheetWidget(),
      isScrollControlled: true,
    );
  }
}
