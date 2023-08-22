
import 'package:flutter/services.dart';

class MaxValueTextInputFormatter extends TextInputFormatter {
  final double maxValue;

  MaxValueTextInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isNotEmpty) {
      final enteredValue = double.parse(newValue.text);
      if (enteredValue > maxValue) {
        return oldValue;
      }
    }

    return newValue;
  }}