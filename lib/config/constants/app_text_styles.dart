import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle headline1(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!;

  static TextStyle body1(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;

  static TextStyle body2(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;

  static TextStyle caption(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!;

  static TextStyle button(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!;
}