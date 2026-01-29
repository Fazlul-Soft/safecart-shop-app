import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../services/product_details_service.dart';
import '../common/image_view.dart';
import 'product_details_indicator.dart';

class ProductDetailsImages extends StatelessWidget {
  const ProductDetailsImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      final images = <String>[];
      final mainImage = pdProvider.productDetails?.image;
      if (mainImage != null && mainImage.isNotEmpty) {
        images.add(mainImage);
      }
      final galleryImages = pdProvider.productDetails?.galleryImages ?? [];
      for (final img in galleryImages) {
        if (img.isNotEmpty && img != mainImage) {
          images.add(img);
        }
      }
      return SizedBox(
        height: 300,
        // margin: EdgeInsets.only(top: topPadding),
        // padding: const EdgeInsets.symmetric(vertical: 20),
        child: pdProvider.additionalInfoImage != null
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ImageView(
                        pdProvider.additionalInfoImage!,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 300,
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      // color: Colors.red,
                      imageUrl: pdProvider.additionalInfoImage ?? '',
                      placeholder: (context, url) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/app_icon.png'),
                                      opacity: .5)),
                            ),
                          ],
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/app_icon.png'),
                                      opacity: .5)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              )
            : Stack(
                children: [
                  Swiper(
                    itemCount: images.isNotEmpty ? images.length : 1,
                    viewportFraction: 1,
                    scale: 1,
                    autoplay: images.length > 1,
                    onIndexChanged: (value) => pdProvider.changeIndex(value),
                    itemBuilder: (context, index) {
                      final imageUrl = images.isNotEmpty
                          ? images[index]
                          : pdProvider.productDetails!.image ?? '';
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ImageView(
                                imageUrl,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 300,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              // color: Colors.red,
                              imageUrl: imageUrl,
                              placeholder: (context, url) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 200,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/loading_image.png'),
                                              opacity: .5)),
                                    ),
                                  ],
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 200,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/loading_image.png'),
                                              opacity: .5)),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: FittedBox(
                      child: Row(
                        children: [
                          ...images.map((e) => ProductDetailsIndicator(
                              e ==
                                  (images.isNotEmpty &&
                                          pdProvider.currentIndex <
                                              images.length
                                      ? images[pdProvider.currentIndex]
                                      : ''))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
