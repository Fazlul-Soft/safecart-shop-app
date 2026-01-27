import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/services/compare_data_service.dart';
import 'package:safecart/utils/responsive.dart';

import '../../helpers/empty_space_helper.dart';

class CompareProductCard extends StatelessWidget {
  final CompareItem item;
  final VoidCallback onRemove;

  const CompareProductCard({
    required this.item,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: cc.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cc.greyBorder),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: SizedBox(
              height: screenHeight / 8.5,
              child: CachedNetworkImage(
                imageUrl: item.imgUrl.isEmpty
                    ? imageLoadingProductCard
                    : item.imgUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/app_icon.png'),
                          opacity: .5,
                        ),
                      ),
                    ),
                  ],
                ),
                errorWidget: (context, url, error) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/app_icon.png'),
                          opacity: .5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          EmptySpaceHelper.emptyHight(8),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                if (item.price != null)
                  Text(
                    '${item.price!.toStringAsFixed(2)}${rtlProvider.currency}',
                    style: TextStyle(
                      fontSize: 15,
                      color: cc.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (item.originalPrice != null)
                  Text(
                    '${item.originalPrice!.toStringAsFixed(2)}${rtlProvider.currency}',
                    style: TextStyle(
                      fontSize: 12,
                      color: cc.greyHint,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Row(
                  children: [
                    RatingBar.builder(
                      ignoreGestures: true,
                      itemSize: 14,
                      initialRating: item.rating <= 0 ? 0 : item.rating,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                      itemBuilder: (context, _) => SvgPicture.asset(
                        'assets/icons/star.svg',
                        color: cc.orangeRating,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    EmptySpaceHelper.emptywidth(10),
                    Text(
                      item.rating > 0
                          ? "(${item.rating.toStringAsFixed(1)})"
                          : "",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text("Remove", style: TextStyle(fontSize: 12)),
                    onPressed: onRemove,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
