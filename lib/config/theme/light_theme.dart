import 'package:flutter/material.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/utils/helpers/material_color_generator.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF44062C),
    primaryContainer: Color(0xFF44062C),
    secondary: Color(0xFF44062C),
    error: Colors.red,
    // brightness: Brightness.light,
    errorContainer: Colors.red,
  ),
  primarySwatch: MaterialColorGenerator.generateMaterialColor(
    color: const Color(0xFF44062C),
  ),
  fontFamily: CommonConstants.regular,
  canvasColor: Colors.white,
  // highlightColor: const Color(0xFFE651B9),
);
