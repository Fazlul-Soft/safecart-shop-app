import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/product_details_service.dart';

class ProductRatingScore extends StatelessWidget {
  const ProductRatingScore({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                final ratingValue =
                    pdProvider.productDetails?.reviewsAvgRating ?? 0.0;
                final isFilled = ratingValue >= (index + 1).toDouble();
                return Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: SvgPicture.asset(
                    'assets/icons/star.svg',
                    color: isFilled ? cc.orangeRating : cc.greyDots,
                    height: 16,
                  ),
                );
              }),
            ),
            EmptySpaceHelper.emptywidth(6),
            Text(
              '(${(pdProvider.productDetails?.reviewsAvgRating ?? 0.0).toStringAsFixed(1)})',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: cc.greyHint),
            ),
            const Spacer(),
            if (pdProvider.productDetails!.campaignProduct?.endDate != null &&
                pdProvider.productDetails!.campaignProduct!.endDate!
                    .isAfter(now))
              SlideCountdownSeparated(
                showZeroValue: false,
                separator: '',
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: cc.greyBorder,
                    )),
                style: TextStyle(
                    color: cc.blackColor.withOpacity(.8),
                    fontWeight: FontWeight.bold),
                duration: pdProvider.productDetails!.campaignProduct!.endDate!
                    .difference(now),
              ),
          ],
        ),
      );
    });
  }
}
