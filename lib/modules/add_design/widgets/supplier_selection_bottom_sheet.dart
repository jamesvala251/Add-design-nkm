import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/add_design/controllers/add_design_controller.dart';
import 'package:nkm_admin_panel/modules/design/controllers/common_controller.dart';
import 'package:nkm_admin_panel/widgets/something_went_wrong_widget.dart';

class SupplierSelectionBottomSheetWidget extends StatelessWidget {
  SupplierSelectionBottomSheetWidget({
    super.key,
    required this.supplierController,
  });

  final CommonController _commonController = Get.find<CommonController>();
  final AddDesignController _addDesignController =
      Get.find<AddDesignController>();
  late final TextEditingController supplierController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: Get.height * 0.25,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _commonController.isLoadingSupplier.value
            ? Center(
                child: SpinKitSpinningLines(
                  color: Get.theme.primaryColor,
                ),
              )
            : _commonController.errorStringSupplier.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FittedBox(
                      child: SomethingWentWrongWidget(
                        errorTxt: _commonController.errorStringSupplier.value,
                        retryOnSomethingWentWrong: () =>
                            _commonController.getSuppliersApiCall(),
                      ),
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
                                CommonConstants.selectSupplier,
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
                          itemCount: _commonController.supplierList.length,
                          separatorBuilder: (_, __) => Divider(
                            color: Get.theme.primaryColor,
                            thickness: 0.5,
                          ),
                          itemBuilder: (_, index) => ListTile(
                            onTap: () {
                              _addDesignController.selectedSupplierId =
                                  _commonController.supplierList[index].id;
                              supplierController.text =
                                  _commonController.supplierList[index].name;
                              Get.back();
                            },
                            trailing: _addDesignController.selectedSupplierId ==
                                    _commonController.supplierList[index].id
                                ? Icon(
                                    Icons.check_circle,
                                    color: Get.theme.primaryColor,
                                  )
                                : const SizedBox(),
                            title: Text(
                              _commonController.supplierList[index].name,
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
