import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitSpinningLines(color: Get.theme.primaryColor,),
          const SizedBox(
            height: 12,
          ),
          Text(
            "loading".tr,
            style: const TextStyle(
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
