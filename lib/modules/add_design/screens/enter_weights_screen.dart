import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/constants/route_constants.dart';
import 'package:nkm_admin_panel/modules/add_design/controllers/add_design_controller.dart';
import 'package:nkm_admin_panel/modules/add_design/models/weights_text_field_model.dart';
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';
import 'package:nkm_admin_panel/utils/ui/common_style.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';

class EnterWeightsScreen extends StatefulWidget {
  const EnterWeightsScreen({super.key});

  @override
  State<EnterWeightsScreen> createState() => _EnterWeightsScreenState();
}

class _EnterWeightsScreenState extends State<EnterWeightsScreen> {
  final AddDesignController _addDesignController =
      Get.find<AddDesignController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, dynamic> temp = Get.arguments as Map<String, dynamic>;
      String count = temp[RouteConstants.count] as String;
      bool isWeightAvailable = temp[RouteConstants.isWeightAvailable] as bool;
      if (!isWeightAvailable) {
        _addDesignController.weights.clear();
        for (int i = 0; i < int.parse(count); i++) {
          _addDesignController.weights.add(WeightsTextFieldModel());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppDialogs.showAlertDialog(
            context: context,
            title: "Alert",
            description: "Are you sure you want to go back without saving?",
            firstButtonName: "Yes",
            secondButtonName: "No",
            onFirstButtonClicked: () {
              _addDesignController.weights.clear();
              Get.back();
              Get.back();
            },
            onSecondButtonClicked: () {
              Get.back();
            });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Enter Weight"),
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
                    itemCount: _addDesignController.weights.length,
                    itemBuilder: (_, index) => TextFormField(
                      cursorColor: Get.theme.primaryColor,
                      controller:
                          _addDesignController.weights[index].controller,
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
                        label: 'Design Weight ${index + 1}',
                        hintText: 'Enter Design Weight ${index + 1}',
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
          onPressed: validate,
          label: Text(
            "Save",
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

  void validate() {
    int resultIndex = _addDesignController.weights.indexWhere((element) =>
        element.controller.text.trim().isEmpty ||
        double.parse(element.controller.text.trim()) <= 0);
    if (resultIndex == -1) {
      for (var element in _addDesignController.weights) {
        element.weight.value = element.controller.text.trim();
      }
      Get.back();
    } else {
      UiUtils.errorSnackBar(
          message:
              "Please Enter Weight ${resultIndex == -1 ? resultIndex + 2 : resultIndex + 1}");
    }
  }
}
