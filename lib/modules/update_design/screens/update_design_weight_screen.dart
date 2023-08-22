import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/modules/update_design/controllers/update_design_controller.dart';
import 'package:nkm_admin_panel/utils/ui/common_style.dart';

class UpdateDesignWeightScreen extends StatefulWidget {
  const UpdateDesignWeightScreen({super.key});

  @override
  State<UpdateDesignWeightScreen> createState() =>
      _UpdateDesignWeightScreenState();
}

class _UpdateDesignWeightScreenState extends State<UpdateDesignWeightScreen> {
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
          title: const Text("Update Weight"),
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
                "ⓘ You are required to add a weight for each quantity you have entered, and ensure that the weight is more than 0.",
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
                        .updateDesignWeightModelList.length,
                    itemBuilder: (_, index) => TextFormField(
                      cursorColor: Get.theme.primaryColor,
                      controller: _updateDesignController
                          .updateDesignWeightModelList[index].controller,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 7,
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: Get.textTheme.titleMedium!.fontSize,
                      ),
                      decoration: CommonStyle.getCommonTextFormFiledDecoration(
                        label: _updateDesignController
                            .updateDesignWeightModelList[index].articleNumber,
                        hintText: 'Enter Weight',
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
    for (var element in _updateDesignController.updateDesignWeightModelList) {
      if (element.controller.text.trim().isNotEmpty &&
          double.parse(element.controller.text.trim()) > 0) {
        element.weight.value = element.controller.text.trim();
      } else if (element.controller.text.trim().isEmpty ||
          double.parse(element.controller.text.trim()) <= 0) {
        element.controller.text = element.weight.value;
      }
    }
    return;
  }
}
