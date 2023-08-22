import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/design/controllers/design_list_controller.dart';
import 'package:nkm_admin_panel/modules/design/controllers/filter_design_controller.dart';
import 'package:nkm_admin_panel/modules/design/widgets/drawer_widget.dart';
import 'package:nkm_admin_panel/modules/design/widgets/design_list_item_widget.dart';
import 'package:nkm_admin_panel/modules/design/widgets/filter_bttom_sheet_widget.dart';
import 'package:nkm_admin_panel/widgets/loading_widget.dart';
import 'package:nkm_admin_panel/widgets/no_data_found_widget.dart';
import 'package:nkm_admin_panel/widgets/something_went_wrong_widget.dart';

class DesignListScreen extends StatefulWidget {
  const DesignListScreen({super.key});

  @override
  State<DesignListScreen> createState() => _DesignListScreenState();
}

class _DesignListScreenState extends State<DesignListScreen> {
  final DesignListController _designListController =
      Get.find<DesignListController>();
  final ScrollController _scrollController = ScrollController();
  final RxBool _displayScrollToTop = false.obs;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  RxBool isSnackBarOpen = false.obs;

  @override
  void initState() {
    Get.put(FilterDesignController());
    _designListController.getDesignListApiCall();
    _scrollController.addListener(
      () {
        if (_scrollController.offset >= 400) {
          _displayScrollToTop.value = true;
        } else {
          _displayScrollToTop.value = false;
        }

        if (!_designListController.isLoadingDesignList.value &&
            !_designListController.isLoadingNextPage.value &&
            _designListController.errorWhileLoadingNextPage.value.isEmpty &&
            _designListController.hasMorePage.value &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent) {
          _designListController.loadNextDesignListPage();
        }
      },
    );
    super.initState();
  }

  void changeVariableAfterTwoSeconds() async {
    await Future.delayed(const Duration(seconds: 2));
    isSnackBarOpen.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSnackBarOpen.value) {
          return true;
        } else {
          isSnackBarOpen.value = true;
          const snackBar = SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text('Press back again to exit!')
              ],
            ),
            duration: Duration(seconds: 2),
          );

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
          changeVariableAfterTwoSeconds();

          return false;
        }
      },
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          centerTitle: true,
          title: Text('design'.tr),
          actions: [
            IconButton(
              onPressed: () => openFilterBottomSheet(),
              icon: const Icon(Icons.filter_alt_rounded),
            ),
          ],
        ),
        drawer: DrawerWidget(
          scaffoldKey: _key,
        ),
        body: Obx(
          () => _designListController.isLoadingDesignList.value
              ? const LoadingWidget()
              : _designListController.errorStringDesignList.value.isEmpty
                  ? _designListController.designList.isNotEmpty
                      ? _getDesignList
                      : NoDataFoundWidget(
                          retryOn: () {
                            _designListController.getDesignListApiCall();
                          },
                        )
                  : SomethingWentWrongWidget(
                      errorTxt:
                          _designListController.errorStringDesignList.value,
                      retryOnSomethingWentWrong: () =>
                          _designListController.errorStringDesignList.value,
                    ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(
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
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 44,
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  Get.toNamed(AppRoutes.addDesignScreen)!.then((value) {
                    _scrollToTop();
                    _designListController.refreshDesignListApiCall();
                    return;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
                // backgroundColor: Colors.red,
                icon: const Icon(
                  Icons.diamond_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  'add_design'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  Column get _getDesignList => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                return await _designListController.refreshDesignListApiCall();
              },
              child: ListView.builder(
                itemCount: _designListController.designList.length,
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  bottom: 150,
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                itemBuilder: (_, index) => DesignListItemWidget(
                  item: _designListController.designList[index],
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
      () => _designListController.isLoadingNextPage.value
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
                    'Page ${_designListController.pageNo.value} is loading...',
                    style: TextStyle(
                      fontSize: Get.textTheme.bodySmall!.fontSize,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            )
          : _designListController.errorWhileLoadingNextPage.value.isNotEmpty
              ? InkWell(
                  onTap: () {
                    _designListController.loadNextDesignListPage();
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
                          _designListController.errorWhileLoadingNextPage.value,
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
    ).then((value) {
      if (value != null && value) {
        Get.toNamed(AppRoutes.filterDesignListScreen);
      }
    });
  }
}
