import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';

final themeData = ThemeData(
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(kPrimary),
    fillColor: MaterialStateProperty.all(kLight),
  ),
  primarySwatch: Colors.grey,
);
