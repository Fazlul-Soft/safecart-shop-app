import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/home_view/slider_one.dart';
import 'package:safecart/widgets/skelletons/slider_one_skeleton.dart';

import '../../services/slider_service.dart';

class AutoSlider extends StatelessWidget {
  final int sliderType;

  const AutoSlider({this.sliderType = 1, super.key});

  @override
  Widget build(BuildContext context) {
    final sliderProvider = Provider.of<SliderService>(context, listen: false);
    return FutureBuilder(
        future: sliderProvider.getSliderList(sliderType) == null &&
                !sliderProvider.isSliderLoading(sliderType)
            ? sliderProvider.fetchSlider(context, sliderType)
            : null,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Swiper(
          //     itemCount: sProvider.sliderOneList.length,
          //     viewportFraction: .95,
          //     scale: .95,
          //     autoplay: true,
          //     itemBuilder: (context, index) {
          //       final element = sProvider.sliderOneList[index];
          //       return SliderOneSkeleton();
          //     },
          //   );
          // }
          return Consumer<SliderService>(
            builder: (context, sProvider, child) {
              final sliderList = sProvider.getSliderList(sliderType);
              return !sProvider.isSliderLoading(sliderType) &&
                      sliderList != null
                  ? sliderList.isNotEmpty
                      ? SizedBox(
                          height: 420,
                          child: Swiper(
                            itemCount: sliderList.length,
                            viewportFraction: .9,
                            scale: .95,
                            autoplay: true,
                            itemBuilder: (context, index) {
                              final element = sliderList[index];
                              return SliderOne(
                                element.title,
                                element.description,
                                element.buttonText,
                                element.image,
                                buttonUrl: element.buttonUrl?.toString(),
                                capm: element.campaign,
                                cat: element.category,
                              );
                            },
                          ),
                        )
                      : const SizedBox()
                  : const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SizedBox(height: 230, child: SliderOneSkeleton()),
                    );
            },
          );
        });
  }

  Future delay() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
