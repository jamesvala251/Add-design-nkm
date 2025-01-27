import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/config/routes/app_routes.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';
import 'package:nkm_admin_panel/modules/design/controllers/design_list_controller.dart';
import 'package:nkm_admin_panel/modules/design/models/design_list_model.dart'
    as design_list_model;
import 'package:nkm_admin_panel/modules/design/widgets/design_details_bottom_sheet_widget.dart';
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';

class DesignListItemWidget extends StatelessWidget {
  const DesignListItemWidget({
    super.key,
    required this.item,
    required this.index,
  });

  final design_list_model.Data item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Slidable(
        // rowWidth: Get.width - 32,
        closeOnScroll: true,
        useTextDirection: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dragDismissible: false,
          extentRatio: 0.75,
          children: [
            SlidableAction(
              onPressed: (ctx) {},
              icon: Icons.download_rounded,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
              backgroundColor: Get.theme.primaryColor,
            ),
            const VerticalDivider(
              width: 0.2,
              color: Colors.white,
            ),
            SlidableAction(
              onPressed: (ctx) {
                Get.toNamed(
                  AppRoutes.updateDesignListScreen,
                  arguments: item,
                )!
                    .then((value) {
                  Get.find<DesignListController>().getDesignListApiCall();
                });
              },
              icon: Icons.edit_rounded,
              backgroundColor: Get.theme.primaryColor,
            ),
            const VerticalDivider(
              width: 0.2,
              color: Colors.white,
            ),
            SlidableAction(
              onPressed: (ctx) => _openBottomSheetForView(),
              icon: Icons.remove_red_eye_rounded,
              backgroundColor: Get.theme.primaryColor,
            ),
            const VerticalDivider(
              width: 0.2,
              color: Colors.white,
            ),
            SlidableAction(
              onPressed: (ctx) {
                AppDialogs.showAlertDialog(
                  context: context,
                  title: 'Delete ${item.name}?',
                  description:
                      'Are you sure want to delete ${item.name} design?',
                  firstButtonName: 'Yes',
                  secondButtonName: 'No',
                  onFirstButtonClicked: () async {
                    Get.back();
                    item.deleteDesignApiCall(index: index);
                  },
                  onSecondButtonClicked: () => Get.back(),
                );
              },
              icon: Icons.delete_rounded,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              backgroundColor: Get.theme.primaryColor,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => _openBottomSheetForView(),
          child: Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 0,
            ),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 7,
                bottom: 7,
                left: 6,
                right: 12.0,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      elevation: 3.0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: item.images.isNotEmpty
                          ? Transform.scale(
                              scale: 1.6,
                              child: CachedNetworkImage(
                                imageUrl: item.images.first.url,
                                height: 54,
                                width: 54,
                                placeholder: (_, __) => SpinKitSpinningLines(
                                  color: Get.theme.primaryColor,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 54,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 54,
                              width: 54,
                              child: Center(
                                child: Text(
                                  "NA",
                                  style:
                                      TextStyle(color: Get.theme.primaryColor),
                                ),
                              ),
                            ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                color: Get.theme.primaryColor,
                                fontSize: Get.textTheme.titleMedium!.fontSize,
                              ),
                            ),
                          ),
                          if (item.goldCaret.isNotEmpty)
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.hardEdge,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _getChipWidget(
                                      chipContent:
                                          '${item.goldCaret.first.articalFrom} to ${item.goldCaret.first.articalTo}',
                                    ),
                                    ...List.generate(
                                      item.goldCaret.length,
                                      (index) => _getChipWidget(
                                        chipContent:
                                            'Q-${item.goldCaret[index].qty} | C-${item.goldCaret[index].caret}',
                                      ),
                                    ),
                                  ],
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
    );
  }

  Card _getChipWidget({required String chipContent}) {
    return Card(
      elevation: 1,
      color: Get.theme.primaryColor,
      margin: const EdgeInsets.only(
        right: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 8,
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

  void _openBottomSheetForView() {
    Get.bottomSheet(
      DesignDetailsBottomSheetWidget(
        item: item,
      ),
      isScrollControlled: true,
    );
  }
}
