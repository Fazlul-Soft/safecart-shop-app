import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';
import '../../utils/responsive.dart';

class SliderOneSkeleton extends StatelessWidget {
  const SliderOneSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        height: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
      ),
    );
  }
}
