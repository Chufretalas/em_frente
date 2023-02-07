import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/themes/theme_colors.dart';

import '../utils/constants.dart';

class BlueCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double borderRadius;
  const BlueCard({Key? key, required this.child, this.height = 80, this.borderRadius = 22}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          color: ThemeColors.dynamicBlueColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: kElevationToShadow[8]
      ),
      height: height,
      padding:
      const EdgeInsets.only(right: 14, left: 14, top: 8, bottom: 8),
      child: child
    );
  }
}
