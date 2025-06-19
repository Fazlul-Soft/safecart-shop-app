import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/widgets/common/product_card.dart';
import '../helpers/common_helper.dart';
import '../services/home_categories_service.dart';
import '../services/product_details_service.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/skelletons/product_card_skeleton.dart';
import 'product_details_view.dart';

class ProductBySubcategoryView extends StatelessWidget {
  static const routeName = 'product_by_subcategory_view';
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    controller.addListener(() => scrollListener(context));
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final subcatId = routeData[0] as int;
    final subcatName = routeData[1] as String; // Use the passed subcategory name

    final hcProvider = Provider.of<HomeCategoriesService>(context, listen: false);
    print('Using subcatName for $subcatId: $subcatName');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      hcProvider.fetchHomeSubcategoryProductsById(subcatId);
    });

    return Scaffold(
      appBar: CustomAppBar().appBarTitled(context, subcatName, () {
        Navigator.of(context).pop();
      }),
      body: WillPopScope(
        onWillPop: () async => true,
        child: Consumer<HomeCategoriesService>(
          builder: (context, hcProvider, child) {
            return Column(
              children: [
                Expanded(
                  child: hcProvider.categoryProductLoading || hcProvider.categoryProducts == null
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
                            itemBuilder: (context, index) => ProductCardSkeleton(),
                          ),
                        )
                      : hcProvider.categoryProducts!.isEmpty
                          ? Center(child: Text(asProvider.getString('No product found')))
                          : StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              controller: controller,
                              itemCount: hcProvider.categoryProducts!.where((product) => product.subCategoryId == subcatId).length,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              padding: const EdgeInsets.all(20),
                              staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                              itemBuilder: (context, index) {
                                final filteredProducts = hcProvider.categoryProducts!.where((product) => product.subCategoryId == subcatId).toList();
                                final element = filteredProducts[index];
                                String? discPercentage;
                                if (element.campaignPercentage is num) {
                                  discPercentage = element.campaignPercentage?.toStringAsFixed(2);
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Provider.of<ProductDetailsService>(context, listen: false)
                                        .clearProductDetails();
                                    Navigator.of(context).pushNamed(
                                      ProductDetailsView.routeName,
                                      arguments: [element.title, element.prdId],
                                    );
                                  },
                                  child: ProductCard(
                                    element.prdId,
                                    element.title ?? "",
                                    element.imgUrl,
                                    element.discountPrice ?? element.price,
                                    element.discountPrice != null ? element.price : null,
                                    index,
                                    badge: element.badge,
                                    discPercentage: discPercentage,
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
                                  ),
                                );
                              },
                            ),
                ),
                if (hcProvider.categoryProductLoading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(height: 60, child: CustomPreloader()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void scrollListener(BuildContext context) async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final hcProvider = Provider.of<HomeCategoriesService>(context, listen: false);
      final routeData = ModalRoute.of(context)!.settings.arguments as List;
      final subcatId = routeData[0] as int;
      if (false) { // Placeholder for future pagination
        hcProvider.fetchHomeSubcategoryProductsById(subcatId);
      }
      if (true) {
        showToast(asProvider.getString('No more product found'), cc.blackColor);
      }
    }
  }
}