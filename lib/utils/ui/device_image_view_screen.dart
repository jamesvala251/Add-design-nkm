import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/constants/route_constants.dart';

class DeviceImageViewScreen extends StatefulWidget {
  const DeviceImageViewScreen({Key? key}) : super(key: key);

  @override
  State<DeviceImageViewScreen> createState() => _DeviceImageViewScreenState();
}

class _DeviceImageViewScreenState extends State<DeviceImageViewScreen> {
  late String title;
  late String imagePath;

  @override
  void initState() {
    Map<String, String> temp = Get.arguments as Map<String, String>;
    title = temp[RouteConstants.title] as String;
    imagePath = temp[RouteConstants.imagePath] as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: InteractiveViewer(
              maxScale: 5,
              minScale: 1,
              child: Image.file(
                File(imagePath),
              )),
        ),
      ),
    );
  }
}
