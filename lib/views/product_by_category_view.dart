import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safecart/services/search_filter_data_service.dart';
import 'package:safecart/widgets/search_view/filter_bottom_sheet.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/widgets/common/product_card.dart';

import '../helpers/common_helper.dart';
import '../utils/responsive.dart';
import '../services/product_details_service.dart';
import '../services/search_product_service.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/skelletons/product_card_skeleton.dart';
import 'product_details_view.dart';

class ProductByCategoryView extends StatelessWidget {
  static const routeName = 'product_by_category_view';
  ProductByCategoryView({super.key});
  ScrollController controller = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final title = routeData.first;
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar().appBarTitled(context, title, () {
        Provider.of<SearchProductService>(context, listen: false)
            .setFilterOptions(catVal: '');
        Navigator.of(context).pop();
      }, actions: [
        GestureDetector(
          onTap: () {
            final saProvider =
                Provider.of<SearchProductService>(context, listen: false);
            final sfdProvider =
                Provider.of<SearchFilterDataService>(context, listen: false);
            if (sfdProvider.filterOprions == null) {
              sfdProvider.fetchSearchfilterData(context);
            }
            sfdProvider.setFilterAccordingToSearch(
              cat: saProvider.selectedCategory,
              subCat: saProvider.selectedSubCategory,
              childCat: saProvider.selectedChildCats,
              color: saProvider.selectedColor,
              size: saProvider.selectedSize,
              brand: saProvider.selectedBrand,
              rating: saProvider.selectedRating,
              minPrize: (saProvider.selectedMinPrice ?? '') == '' ||
                      saProvider.selectedMinPrice == 'null'
                  ? null
                  : double.parse(saProvider.selectedMinPrice),
              maxPrize: (saProvider.selectedMaxPrice ?? '') == '' ||
                      saProvider.selectedMaxPrice == 'null'
                  ? null
                  : double.parse(saProvider.selectedMaxPrice),
            );
            scaffoldKey.currentState!.openEndDrawer();
          },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: cc.greyFive,
                width: 1.5,
              ),
              color: cc.pureWhite,
            ),
            child: SvgPicture.asset(
              'assets/icons/filter.svg',
              color: cc.blackColor,
            ),
          ),
        )
      ]),
      endDrawer: Container(
        width: screenWidth / 1.2,
        height: screenHeight,
        color: Colors.white,
        child: FilterBottomSheet(scaffoldKey, hideCategoryFilters: true),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<SearchProductService>(context, listen: false)
              .setFilterOptions(catVal: '');
          return true;
        },
        child: Consumer<SearchProductService>(
            builder: (context, saProvider, child) {
          return Column(
            children: [
              Expanded(
                child: saProvider.loading || saProvider.searchedProduct == null
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        physics: const NeverScrollableScrollPhysics(),
                        child: GridView.builder(
                          gridDelegate: const FlutterzillaFixedGridView(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              height: 200),
                          itemCount: 12,
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProductCardSkeleton();
                          },
                        ))
                    : saProvider.searchedProduct != null &&
                            saProvider.searchedProduct!.isEmpty
                        ? Center(
                            child:
                                Text(asProvider.getString('No product found')),
                          )
                        : StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            controller: controller,
                            itemCount: saProvider.searchedProduct!.length,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            padding: const EdgeInsets.all(20),
                            staggeredTileBuilder: (index) =>
                                const StaggeredTile.fit(1),
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final element =
                                  saProvider.searchedProduct![index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Provider.of<ProductDetailsService>(context,
                                            listen: false)
                                        .clearProductDetails();
                                    Navigator.of(context).pushNamed(
                                        ProductDetailsView.routeName,
                                        arguments: [
                                          element.title,
                                          element.prdId
                                        ]);
                                  },
                                  child: ProductCard(
                                    element.prdId,
                                    element.title ?? "",
                                    element.imgUrl,
                                    element.discountPrice ?? element.price,
                                    element.discountPrice != null
                                        ? (element.price)
                                        : null,
                                    index,
                                    badge: element.badge,
                                    salePriceText:
                                        element.discountPriceRaw ??
                                            element.priceRaw,
                                    originalPriceText:
                                        element.discountPrice != null
                                            ? element.priceRaw
                                            : null,
                                    discPercentage: element.campaignPercentage
                                        != null &&
                                                element.campaignPercentage !=
                                                    0
                                            ? formatAmount(
                                                element.campaignPercentage)
                                            : null,
                                    cartable: element.isCartAble!,
                                    prodCatData: {
                                      "category": element.categoryId,
                                      "subcategory": element.subCategoryId,
                                      "childcategory": element.childCategoryIds
                                    },
                                    rating: element.avgRatting,
                                    randomKey: element.randomKey,
                                    randomSecret: element.randomSecret,
                                    stock: element.stockCount,
                                    campaignStock: element.campaignStock,
                                  ));
                            },
                          ),
              ),
              if (saProvider.nextLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(height: 60, child: CustomPreloader()),
                ),
            ],
          );
        }),
      ),
    );
  }

  scrollListener(BuildContext context) async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final saProvider =
          Provider.of<SearchProductService>(context, listen: false);
      if (!saProvider.nextLoading && saProvider.nextPage != null) {
        // saProvider.setNextLoading(true);
        saProvider.fetchNextPageProducts(context);
      }
      // saProvider.setNextLoading(false);

      if (saProvider.nextPage == null) {
        showToast(asProvider.getString('No more product found'), cc.blackColor);
      }
    }
  }
}
