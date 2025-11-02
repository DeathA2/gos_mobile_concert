import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_concert/generated/assets/assets.gen.dart';
import 'package:mobile_concert/src/theme/colors.dart';

class XSvgCustom extends StatelessWidget {
  final SvgGenImage svgPath;
  final double? svgWidth;
  final Color? svgColor;
  const XSvgCustom({
    super.key,
    required this.svgPath,
    this.svgWidth,
    this.svgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: 1,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: svgPath.svg(
              width: svgWidth,
              colorFilter: ColorFilter.mode(AppColors.black3, BlendMode.srcIn),
            ),
          ),
        ),
        svgPath.svg(
          width: svgWidth,
          colorFilter: svgColor != null
              ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
              : null,
        ),
      ],
    );
  }
}
