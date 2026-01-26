import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/home_view/slider_three.dart';

import '../../helpers/empty_space_helper.dart';
import '../../services/slider_service.dart';
import '../skelletons/slider_two_skeleton.dart';

class ManualSliderTwo extends StatelessWidget {
  final int sliderType;

  const ManualSliderTwo({this.sliderType = 3, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SliderService>(builder: (context, sProvider, child) {
      return SizedBox(
        child: FutureBuilder(
          future: sProvider.getSliderList(sliderType) == null &&
                  !sProvider.isSliderLoading(sliderType)
              ? sProvider.fetchSlider(context, sliderType)
                  : null,
          builder: (context, snapshot) {
            final sliderList = sProvider.getSliderList(sliderType);
            return !sProvider.isSliderLoading(sliderType) &&
                    sliderList != null
                ? sliderList.isNotEmpty
                    ? SizedBox(
                        height: 180,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            itemBuilder: (context, index) {
                              final element = sliderList[index];
                              return SliderThree(
                                element.title,
                                element.description,
                                element.buttonText,
                                element.image,
                                index,
                                capm: element.campaign,
                                cat: element.category,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                EmptySpaceHelper.emptywidth(20),
                            itemCount: sliderList.length),
                      )
                    : const SizedBox()
                : SizedBox(
                    height: 180,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemBuilder: (context, index) => SliderTwoSkeleton(),
                        separatorBuilder: (context, index) =>
                            EmptySpaceHelper.emptywidth(20),
                        itemCount: 7),
                  );
          },
        ),
      );
    });
  }

  Future delay() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
