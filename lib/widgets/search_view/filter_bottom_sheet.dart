import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/search_filter_data_service.dart';
import 'package:safecart/services/search_product_service.dart';
import 'package:safecart/utils/responsive.dart';
import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/common_services.dart';
import '../../services/rtl_service.dart';
import 'package:safecart/utils/custom_row_button.dart';
import '../common/field_title.dart';
import 'filter_rtl_padding.dart';

class FilterBottomSheet extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool hideCategoryFilters;
  final bool hideAdvancedFilters;
  const FilterBottomSheet(this.scaffoldKey,
      {this.hideCategoryFilters = false,
      this.hideAdvancedFilters = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    final rtl = Provider.of<RTLService>(context, listen: false);
    final filterOption =
        Provider.of<SearchFilterDataService>(context, listen: false);

    String formatPrice(double value) {
      return formatAmount(value);
    }

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        EmptySpaceHelper.emptyHight(MediaQuery.of(context).padding.top + 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              asProvider.getString('Filter'),
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        if (!hideCategoryFilters) ...[
          if (filterOption.filterOprions?.allCategory != null &&
              filterOption.filterOprions!.allCategory!.isNotEmpty)
            FilterRtlPadding(
              child: Text(
                asProvider.getString('Category'),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cc.greyParagraph),
              ),
            ),
          if (filterOption.filterOprions?.allCategory != null &&
              filterOption.filterOprions!.allCategory!.isNotEmpty)
            Consumer<SearchFilterDataService>(
                builder: (context, foProvider, child) {
              return SizedBox(
                height: 44,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: rtl.langRtl ? 0 : 25.0,
                    right: rtl.langRtl ? 25 : 0,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: foProvider.filterOprions!.allCategory!.length,
                  itemBuilder: ((context, index) {
                    final category =
                        foProvider.filterOprions!.allCategory![index];
                    final isSelected =
                        category.name.toString() == foProvider.selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        foProvider.setSelectedCategory(category.name);
                        debugPrint('Selected category: ${category.name}');
                      },
                      child: filterOptions(category.name, isSelected),
                    );
                  }),
                ),
              );
            }),
          Consumer<SearchFilterDataService>(
              builder: (context, foProvider, child) {
            return foProvider.selectedCategory != null &&
                    foProvider.selectedCategory != ''
                ? FilterRtlPadding(
                    child: Text(
                      asProvider.getString('Sub-category'),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: cc.greyParagraph),
                    ),
                  )
                : const SizedBox();
          }),
          Consumer<SearchFilterDataService>(
              builder: (context, foProvider, child) {
            return foProvider.selectedCategory != null &&
                    foProvider.selectedCategory != ''
                ? foProvider.selectedCategorySubList.isNotEmpty
                    ? SizedBox(
                        height: 44,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: rtl.langRtl ? 0 : 25.0,
                            right: rtl.langRtl ? 25 : 0,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: foProvider.selectedCategorySubList.length,
                          itemBuilder: ((context, index) {
                            final subcategory =
                                foProvider.selectedCategorySubList[index];
                            final isSelected = subcategory.name.toString() ==
                                foProvider.selectedSubCategory;
                            return GestureDetector(
                              onTap: () {
                                foProvider
                                    .setSelectedSubCategory(subcategory.name);
                                debugPrint(
                                    'Selected subcategory: ${subcategory.name}');
                              },
                              child:
                                  filterOptions(subcategory.name, isSelected),
                            );
                          }),
                        ),
                      )
                    : FilterRtlPadding(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            asProvider.getString('No sub-category available'),
                            style: TextStyle(color: cc.greyHint, fontSize: 14),
                          ),
                        ),
                      )
                : const SizedBox();
          }),
        ],
        /*
        Consumer<SearchFilterDataService>(
            builder: (context, foProvider, child) {
          return foProvider.selectedSubCategory != null &&
                  foProvider.selectedSubCategory != ''
              ? FilterRtlPadding(
                  child: Text(
                    asProvider.getString('Child-category'),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: cc.greyParagraph),
                  ),
                )
              : const SizedBox();
        }),
        Consumer<SearchFilterDataService>(
            builder: (context, foProvider, child) {
          return foProvider.selectedSubCategory != null &&
                  foProvider.selectedSubCategory != ''
              ? foProvider.selectedSubcategoryChildList.isNotEmpty
                  ? SizedBox(
                      height: 44,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          left: rtl.langRtl ? 0 : 25.0,
                          right: rtl.langRtl ? 25 : 0,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            foProvider.selectedSubcategoryChildList.length,
                        itemBuilder: ((context, index) {
                          final childCategory =
                              foProvider.selectedSubcategoryChildList[index];
                          final isSelected = childCategory.name.toString() ==
                              foProvider.selectedChildCats;
                          return GestureDetector(
                            onTap: () {
                              foProvider
                                  .setSelectedChildCats(childCategory.name);
                              debugPrint(
                                  'Selected child category: ${childCategory.name}');
                            },
                            child:
                                filterOptions(childCategory.name, isSelected),
                          );
                        }),
                      ),
                    )
                  : FilterRtlPadding(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          asProvider.getString('No sub-category available'),
                          style: TextStyle(color: cc.greyHint, fontSize: 14),
                        ),
                      ),
                    )
              : const SizedBox();
        }),
        */
        if (!hideAdvancedFilters &&
            (filterOption.filterOprions?.allColors?.isNotEmpty ?? false))
          FilterRtlPadding(
            child: Text(
              asProvider.getString('Color'),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (!hideAdvancedFilters &&
            (filterOption.filterOprions?.allColors?.isNotEmpty ?? false))
          Consumer<SearchFilterDataService>(
              builder: (context, spProvider, child) {
            return FilterRtlPadding(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        filterOption.setSelectedColor(
                            filterOption.filterOprions!.allColors![index].name);
                        debugPrint(
                            'Selected color: ${filterOption.filterOprions!.allColors![index].name}');
                      },
                      child: filterColorOption(
                        filterOption
                            .filterOprions!.allColors![index].colorCode!,
                        spProvider.selectedColor ==
                            filterOption.filterOprions!.allColors![index].name,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      EmptySpaceHelper.emptywidth(5),
                  itemCount: filterOption.filterOprions!.allColors!.length,
                ),
              ),
            );
          }),
        if (!hideAdvancedFilters &&
            (filterOption.filterOprions?.allSizes?.isNotEmpty ?? false))
          FilterRtlPadding(
            child: Text(
              asProvider.getString('Size'),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (!hideAdvancedFilters &&
            (filterOption.filterOprions?.allSizes?.isNotEmpty ?? false))
          Consumer<SearchFilterDataService>(
              builder: (context, spProvider, child) {
            return FilterRtlPadding(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        filterOption.setSelectedSize(
                            filterOption.filterOprions!.allSizes![index].name);
                        debugPrint(
                            'Selected size: ${filterOption.filterOprions!.allSizes![index].name}');
                      },
                      child: filterOptions(
                        filterOption.filterOprions!.allSizes![index].name!,
                        spProvider.selectedSize ==
                            filterOption.filterOprions!.allSizes![index].name,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      EmptySpaceHelper.emptywidth(5),
                  itemCount: filterOption.filterOprions!.allSizes!.length,
                ),
              ),
            );
          }),
        if (!hideAdvancedFilters &&
            (filterOption.filterOprions?.allBrands?.isNotEmpty ?? false))
          FilterRtlPadding(
            child: Text(
              asProvider.getString('Brands'),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cc.greyParagraph),
            ),
          ),
        if (!hideAdvancedFilters &&
            (filterOption.filterOprions?.allBrands?.isNotEmpty ?? false))
          Consumer<SearchFilterDataService>(
              builder: (context, spProvider, child) {
            return FilterRtlPadding(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        filterOption.setSelectedBrand(
                            filterOption.filterOprions!.allBrands![index].name);
                        debugPrint(
                            'Selected brand: ${filterOption.filterOprions!.allBrands![index].name}');
                      },
                      child: filterOptions(
                        filterOption.filterOprions!.allBrands![index].name,
                        filterOption.selectedBrand ==
                            filterOption.filterOprions!.allBrands![index].name,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      EmptySpaceHelper.emptywidth(5),
                  itemCount: filterOption.filterOprions!.allBrands!.length,
                ),
              ),
            );
          }),
        if (!hideAdvancedFilters)
        Consumer<SearchFilterDataService>(
            builder: (context, sfdProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FieldTitle(asProvider.getString('Filter Price')),
                Consumer<SearchFilterDataService>(
                    builder: (context, sfdProvider, child) {
                  return Text(
                    rtl.curRtl
                        ? '${formatPrice(sfdProvider.selectedMinPrice ?? sfdProvider.minPrice)}${rtl.currency}'
                            '-${formatPrice(sfdProvider.selectedMaxPrice ?? sfdProvider.maxPrice)}${rtl.currency}'
                        : '${rtl.currency}${formatPrice(sfdProvider.selectedMinPrice ?? sfdProvider.minPrice)}'
                            '-${rtl.currency}${formatPrice(sfdProvider.selectedMaxPrice ?? sfdProvider.maxPrice)}',
                  );
                }),
              ],
            ),
          );
        }),
        if (!hideAdvancedFilters)
        Consumer<SearchFilterDataService>(
            builder: (context, sfdProvider, child) {
          return Consumer<CommonServices>(builder: (context, srData, child) {
            return SliderTheme(
              data: SliderThemeData(
                rangeThumbShape: const RoundRangeSliderThumbShape(
                    elevation: 1, enabledThumbRadius: 10),
                thumbColor: cc.pureWhite,
                disabledThumbColor: cc.pureWhite,
                activeTrackColor: cc.primaryColor,
                trackHeight: 10,
              ),
              child: RangeSlider(
                values: RangeValues(
                  sfdProvider.selectedMinPrice ?? sfdProvider.minPrice,
                  sfdProvider.selectedMaxPrice ?? sfdProvider.maxPrice,
                ),
                max: filterOption.maxPrice,
                min: filterOption.minPrice,
                inactiveColor: cc.lightPrimary10,
                labels: RangeLabels(
                  formatAmount(
                      sfdProvider.selectedMinPrice ?? sfdProvider.minPrice),
                  formatAmount(
                      sfdProvider.selectedMaxPrice ?? sfdProvider.maxPrice),
                ),
                onChanged: (RangeValues values) {
                  sfdProvider.setRangeValues(values);
                  debugPrint(
                      'Selected price range: ${values.start} - ${values.end}');
                },
              ),
            );
          });
        }),
        if (!hideAdvancedFilters) ...[
          FilterRtlPadding(
            child: FieldTitle(asProvider.getString('Average Rating')),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Consumer<SearchFilterDataService>(
                    builder: (context, sfProvider, child) {
                  return RatingBar.builder(
                    itemSize: 24,
                    initialRating: sfProvider.selectedRating.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    unratedColor: cc.lightPrimary,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                    itemBuilder: (context, _) => SvgPicture.asset(
                      'assets/icons/star.svg',
                      color: cc.orangeRating,
                    ),
                    onRatingUpdate: (rating) {
                      sfProvider.setSelectedRating(rating.toInt());
                      debugPrint('Selected rating: $rating');
                    },
                  );
                }),
                const Spacer(),
                Consumer<SearchFilterDataService>(
                  builder: (context, sfProvider, child) {
                    return GestureDetector(
                      onTap: () {
                        sfProvider.setSelectedRating(0);
                        debugPrint('Rating reset');
                      },
                      child: Icon(
                        Icons.refresh_rounded,
                        color: cc.primaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          EmptySpaceHelper.emptyHight(20),
          const SizedBox(height: 40),
        ],
        Consumer<CommonServices>(builder: (context, srData, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: CustomRowButton(
              width: (screenWidth / 1.2) / 2.3,
              bt1text: asProvider.getString('Reset Filter'),
              bt2text: asProvider.getString('Apply Filter'),
              bt1func: () {
                scaffoldKey.currentState!.closeEndDrawer();
                final spProvider =
                    Provider.of<SearchProductService>(context, listen: false);
                final sfdProvider = Provider.of<SearchFilterDataService>(
                    context,
                    listen: false);
                spProvider.resetFilterOptions();
                sfdProvider.resetSelectedSearchFilter();
                spProvider.fetchProducts(context);
                debugPrint('Filters reset and products fetched');
              },
              bt2func: () {
                scaffoldKey.currentState!.closeEndDrawer();
                final spProvider =
                    Provider.of<SearchProductService>(context, listen: false);
                final sfdProvider = Provider.of<SearchFilterDataService>(
                    context,
                    listen: false);
                spProvider.setFilterOptions(
                  catVal: sfdProvider.selectedCategory,
                  subCatVal: sfdProvider.selectedSubCategory,
                  childCatVal: sfdProvider.selectedChildCats,
                  colorVal: sfdProvider.selectedColor,
                  sizeVal: sfdProvider.selectedSize,
                  brandVal: sfdProvider.selectedBrand,
                  minPrice: sfdProvider.selectedMinPrice?.toString() ?? '',
                  maxPrice: sfdProvider.selectedMaxPrice?.toString() ?? '',
                  rating: sfdProvider.selectedRating,
                );
                spProvider.fetchProducts(context);
                debugPrint(
                  'Filters applied: category=${sfdProvider.selectedCategory}, '
                  'subcategory=${sfdProvider.selectedSubCategory}, '
                  'childCategory=${sfdProvider.selectedChildCats}, '
                  'color=${sfdProvider.selectedColor}, '
                  'size=${sfdProvider.selectedSize}, '
                  'brand=${sfdProvider.selectedBrand}, '
                  'minPrice=${sfdProvider.selectedMinPrice}, '
                  'maxPrice=${sfdProvider.selectedMaxPrice}, '
                  'rating=${sfdProvider.selectedRating}',
                );
              },
            ),
          );
        }),
        EmptySpaceHelper.emptyHight(30),
      ]),
    );
  }

  Widget filterOptions(String text, bool isSelected) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isSelected ? cc.primaryColor : cc.greyBorder,
          width: 1,
        ),
        color: isSelected ? cc.primaryColor : cc.pureWhite,
      ),
      child: Text(
        text,
        style: TextStyle(color: isSelected ? cc.pureWhite : cc.blackColor),
      ),
    );
  }

  Widget filterColorOption(String text, bool isSelected) {
    final color = text.replaceAll('#', '0xff');
    return Container(
      height: 20,
      width: 40,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(int.parse(color)),
      ),
      child: isSelected
          ? Icon(
              Icons.done,
              color: cc.pureWhite,
              size: 18,
            )
          : null,
    );
  }
}
