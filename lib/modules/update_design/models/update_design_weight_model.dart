import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateDesignWeightModel {
  TextEditingController controller = TextEditingController();
  final int id;
  late RxString weight = "".obs;
  late String articleNumber;

  UpdateDesignWeightModel({required this.id, required int weightArg,required this.articleNumber,}) {
    weight.value = weightArg.toString();
    controller.text = weightArg.toString();
  }
}
