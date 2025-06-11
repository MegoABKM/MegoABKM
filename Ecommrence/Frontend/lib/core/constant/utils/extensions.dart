import 'package:ecommrence/core/constant/utils/scaleconfig.dart';
import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  ThemeData get appTheme => Theme.of(this);
  TextTheme get appTextTheme => Theme.of(this).textTheme;
  ScaleConfig get scaleConfig => ScaleConfig(this);
}
