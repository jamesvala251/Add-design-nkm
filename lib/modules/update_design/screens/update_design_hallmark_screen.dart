import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/modules/update_design/controllers/update_design_controller.dart';
import 'package:nkm_admin_panel/utils/ui/common_style.dart';

class UpdateDesignHallmarkScreen extends StatefulWidget {
  const UpdateDesignHallmarkScreen({super.key});

  @override
  State<UpdateDesignHallmarkScreen> createState() => _UpdateDesignHallmarkScreenState();
}

class _UpdateDesignHallmarkScreenState extends State<UpdateDesignHallmarkScreen> {
  final UpdateDesignController _updateDesignController =
  Get.find<UpdateDesignController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await validate();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Update Hallmark"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "ⓘ You are required to add a hallmark for each quantity you have entered",
                style: TextStyle(color: Get.theme.primaryColor),
              ),
              const SizedBox(
                height: 6.0,
              ),
              Obx(
                    () => Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 100, top: 10),
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 16.0,
                    ),
                    itemCount: _updateDesignController
                        .updateDesignHallmarkModelList.length,
                    itemBuilder: (_, index) => TextFormField(
                      cursorColor: Get.theme.primaryColor,
                      controller: _updateDesignController
                          .updateDesignHallmarkModelList[index].controller,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: Get.textTheme.titleMedium!.fontSize,
                      ),
                      decoration: CommonStyle.getCommonTextFormFiledDecoration(
                        label: _updateDesignController
                            .updateDesignHallmarkModelList[index].articleNumber,
                        hintText: 'Enter Hallmark',
                        prefixIcon: Icon(
                          Icons.balance_rounded,
                          color: Get.theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await validate();
            Get.back();
          },
          label: Text(
            "Update",
            style: TextStyle(
              color: Colors.white,
              fontSize: Get.textTheme.titleMedium!.fontSize,
            ),
          ),
          icon: const Icon(
            Icons.done,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Future<void> validate() async {
    for (var element in _updateDesignController.updateDesignHallmarkModelList) {
      if (element.controller.text.trim().isNotEmpty) {
        element.hallmark.value = element.controller.text.trim();
      } else if (element.controller.text.trim().isEmpty) {
        element.controller.text = element.hallmark.value;
      }
    }
    return;
  }
}
