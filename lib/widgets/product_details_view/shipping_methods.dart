import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/helpers/empty_space_helper.dart';

import '../../services/product_details_service.dart';

class ShippingMethods extends StatelessWidget {
  const ShippingMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return pdProvider.productDetails!.productDeliveryOption == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...pdProvider.productDetails!.productDeliveryOption!
                      .map((e) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: cc.whiteGrey,
                              border: Border.all(
                                color: cc.greyBorder2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                ),
                                EmptySpaceHelper.emptyHight(2),
                                Text(
                                  e.subTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: cc.greyHint, fontSize: 10),
                                ),
                              ],
                            ),
                          ))
                ],
              ),
            );
    });
  }
}
