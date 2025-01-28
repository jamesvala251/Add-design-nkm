import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateDesignHallmarkModel {
  TextEditingController controller = TextEditingController();
  final int id;
  late RxString hallmark = "".obs;
  late String articleNumber;

  UpdateDesignHallmarkModel({
    required this.id,
    required String hallmarkArg,
    required this.articleNumber,
  }) {
    hallmark.value = hallmarkArg.toString();
    controller.text = hallmarkArg.toString();
  }
}
