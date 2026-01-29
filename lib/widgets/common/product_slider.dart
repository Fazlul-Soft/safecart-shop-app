import 'package:flutter/material.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/common/product_card.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../models/feature_products_model.dart' as feature_model;
import '../../models/home_campaign_products_model.dart' as home_campaign_model;
import '../../models/product_by_category_model.dart' as category_model;
import '../../models/product_by_subcategory_model.dart' as subcategory_model;
import '../../models/search_product_model.dart' as search_model;

class ProductSlider extends StatelessWidget {
  final productList;
  final shouldPop;

  const ProductSlider(this.productList, {super.key, this.shouldPop = false});

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Container(
            constraints: BoxConstraints(minWidth: screenWidth - 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...productList!.map((element) {
                  String? salePriceText;
                  String? originalPriceText;
                  if (element is feature_model.Datum) {
                    salePriceText =
                        element.discountPriceRaw ?? element.priceRaw;
                    originalPriceText =
                        element.discountPrice != null ? element.priceRaw : null;
                  } else if (element is home_campaign_model.Product) {
                    salePriceText =
                        element.discountPriceRaw ?? element.priceRaw;
                    originalPriceText =
                        element.discountPrice != null ? element.priceRaw : null;
                  } else if (element is category_model.Datum) {
                    salePriceText =
                        element.discountPriceRaw ?? element.priceRaw;
                    originalPriceText =
                        element.discountPrice != null ? element.priceRaw : null;
                  } else if (element is subcategory_model.Datum2) {
                    salePriceText =
                        element.discountPriceRaw ?? element.priceRaw;
                    originalPriceText =
                        element.discountPrice != null ? element.priceRaw : null;
                  } else if (element is search_model.Datum) {
                    salePriceText =
                        element.discountPriceRaw ?? element.priceRaw;
                    originalPriceText =
                        element.discountPrice != null ? element.priceRaw : null;
                  }
                  return Row(
                    children: [
                      ProductCard(
                        element!.prdId,
                        element.title ?? "",
                        element.imgUrl,
                        element.discountPrice ?? element.price,
                        element.discountPrice != null ? (element.price) : null,
                        index++,
                        badge: element.badge,
                        salePriceText: salePriceText,
                        originalPriceText: originalPriceText,
                        discPercentage: element.campaignPercentage != null &&
                                element.campaignPercentage != 0
                            ? formatAmount(element.campaignPercentage)
                            : null,
                        cartable: element.isCartAble!,
                        prodCatData: {
                          "category": element.categoryId,
                          "subcategory": element.subCategoryId,
                          "childcategory": element.childCategoryIds
                        },
                        rating: element.avgRatting,
                        endDate: element.endDate,
                        randomKey: element.randomKey,
                        randomSecret: element.randomSecret,
                        shouldPop: shouldPop,
                        stock: element.stockCount,
                        campaignStock: element.campaignStock,
                        vendorId: element.vendorId,
                      ),
                      EmptySpaceHelper.emptywidth(20),
                    ],
                  );
                }).toList()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
