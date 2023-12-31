import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/constants/route_constants.dart';
import 'package:nkm_admin_panel/custom_libs/spin_kit/spinning_lines.dart';

class NetworkImageViewScreen extends StatefulWidget {
  const NetworkImageViewScreen({Key? key}) : super(key: key);

  @override
  State<NetworkImageViewScreen> createState() =>
      _NetworkImageViewScreenState();
}

class _NetworkImageViewScreenState extends State<NetworkImageViewScreen> {
  late String title;
  late String imageUrl;

  @override
  void initState() {
    Map<String, String> temp = Get.arguments as Map<String, String>;
    title = temp[RouteConstants.title] as String;
    imageUrl = temp[RouteConstants.imageUrl] as String;
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
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  const Center(
                child: SpinKitSpinningLines(
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => const Padding(
                padding: EdgeInsets.only(top: 70),
                child: Icon(Icons.error, size: 50, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
