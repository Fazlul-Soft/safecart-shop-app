import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/common_helper.dart';
import '../../services/product_by_campaigns_service.dart';
import '../../services/search_product_service.dart';
import '../../views/product_by_campaign_view.dart';
import '../../views/product_by_category_view.dart';

class SliderOne extends StatelessWidget {
  final String title;
  final String subTitle;
  final String btText;
  final String image;
  final String? buttonUrl;
  final dynamic capm;
  final dynamic cat;

  const SliderOne(
    this.title,
    this.subTitle,
    this.btText,
    this.image, {
    this.buttonUrl,
    this.capm,
    this.cat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),

            /// Dark Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// Text + Button Overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Subtitle (Gold)
                  Text(
                    subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFE0BB20),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// CTA Button (DB Driven)
                  if (btText.isNotEmpty)
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF41695A), // Web green
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () async {
                          /// Priority 1 → URL from DB
                          if (buttonUrl != null && buttonUrl!.isNotEmpty) {
                            final uri = Uri.parse(buttonUrl!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                              return;
                            }
                          }

                          /// Priority 2 → Campaign
                          if (capm != null) {
                            Provider.of<ProductByCampaignsService>(context,
                                    listen: false)
                                .clearProductByCampaignData();

                            Navigator.of(context).pushNamed(
                              ProductByCampaignView.routeName,
                              arguments: [title, capm.toString()],
                            );
                            return;
                          }

                          /// Priority 3 → Category
                          if (cat != null) {
                            Provider.of<SearchProductService>(context,
                                    listen: false)
                                .setFilterOptions(catVal: cat);

                            Provider.of<SearchProductService>(context,
                                    listen: false)
                                .fetchProducts(context);

                            Navigator.of(context).pushNamed(
                              ProductByCategoryView.routeName,
                              arguments: [cat],
                            );
                          }
                        },
                        child: Text(
                          btText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
