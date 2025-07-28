// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:provider/provider.dart';
// import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
// import 'package:safecart/helpers/empty_space_helper.dart';
// import 'package:safecart/services/all_product_service.dart';

// import '../../utils/responsive.dart';
// import '../../widgets/common/product_card.dart';
// import '../../widgets/skelletons/product_card_skeleton.dart';
// import '../helpers/common_helper.dart';
// import '../services/product_details_service.dart';
// import '../utils/custom_preloader.dart';
// import 'product_details_view.dart';

// import '../services/search_filter_data_service.dart';
// import '../widgets/search_view/filter_bottom_sheet.dart';

// class ProductsView extends StatelessWidget {
//   static const routeName = 'products_view';
//   ProductsView({super.key});
//   ScrollController controller = ScrollController();
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   final searchBarFocusNode = FocusNode();

//   @override
//   Widget build(BuildContext context) {
//     controller.addListener((() => scrollListener(context)));
//     Provider.of<AllProductsService>(context, listen: false).resetProducts();
//     return Consumer<AllProductsService>(builder: (context, apProvider, child) {
//       return SizedBox(
//         height: screenHeight - 150,
//         child: FutureBuilder(
//             future: !apProvider.loading && apProvider.allProducts == null
//                 ? apProvider.fetchProducts(context)
//                 : null,
//             builder: (context, snapshot) {
//               return apProvider.loading && apProvider.allProducts == null
//                   ? SingleChildScrollView(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 8),
//                       physics: const NeverScrollableScrollPhysics(),
//                       child: GridView.builder(
//                         gridDelegate: const FlutterzillaFixedGridView(
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 15,
//                             crossAxisSpacing: 15,
//                             height: 200),
//                         padding: EdgeInsets.zero,
//                         itemCount: 12,
//                         shrinkWrap: true,
//                         clipBehavior: Clip.none,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           return ProductCardSkeleton();
//                         },
//                       ))
//                   : apProvider.allProducts != null &&
//                           apProvider.allProducts!.isEmpty
//                       ? Center(
//                           child: Text(asProvider.getString('No product found')),
//                         )
//                       : Column(
//                           children: [
//                             Expanded(
//                               child: StaggeredGridView.countBuilder(
//                                 crossAxisCount: 2,
//                                 controller: controller,
//                                 itemCount: apProvider.allProducts!.length,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 20),
//                                 staggeredTileBuilder: (index) =>
//                                     const StaggeredTile.fit(1),
//                                 // physics: const NeverScrollableScrollPhysics(),
//                                 itemBuilder: (context, index) {
//                                   final element =
//                                       apProvider.allProducts![index];
//                                   return GestureDetector(
//                                       onTap: () {
//                                         Navigator.of(context).pop();
//                                         Navigator.of(context).pop();
//                                         Provider.of<ProductDetailsService>(
//                                                 context,
//                                                 listen: false)
//                                             .clearProductDetails();
//                                         Navigator.of(context).pushNamed(
//                                             ProductDetailsView.routeName,
//                                             arguments: [
//                                               element.title,
//                                               element.prdId
//                                             ]);
//                                       },
//                                       child: ProductCard(
//                                         element.prdId,
//                                         element.title ?? "",
//                                         element.imgUrl,
//                                         element.discountPrice ?? element.price,
//                                         element.discountPrice != null
//                                             ? (element.price)
//                                             : null,
//                                         index,
//                                         badge: element.badge,
//                                         discPercentage: element
//                                             .campaignPercentage
//                                             ?.toStringAsFixed(2),
//                                         cartable: element.isCartAble!,
//                                         prodCatData: {
//                                           "category": element.categoryId,
//                                           "subcategory": element.subCategoryId,
//                                           "childcategory":
//                                               element.childCategoryIds
//                                         },
//                                         rating: element.avgRatting,
//                                         randomKey: element.randomKey,
//                                         randomSecret: element.randomSecret,
//                                         stock: element.stockCount,
//                                         campaignStock: element.campaignStock,
//                                       ));
//                                 },
//                               ),
//                             ),
//                             if (apProvider.nextLoading)
//                               SizedBox(height: 60, child: CustomPreloader()),
//                             EmptySpaceHelper.emptyHight(20),
//                           ],
//                         );
//             }),
//       );
//     });
//   }

//   scrollListener(BuildContext context) async {
//     if (controller.offset >= controller.position.maxScrollExtent &&
//         !controller.position.outOfRange) {
//       ScaffoldMessenger.of(context).removeCurrentSnackBar();
//       final apProvider =
//           Provider.of<AllProductsService>(context, listen: false);
//       if (!apProvider.nextLoading && apProvider.nextPage != null) {
//         // apProvider.setNextLoading(true);
//         apProvider.fetchNextPageProducts(context);
//       }
//       // apProvider.setNextLoading(false);

//       if (apProvider.nextPage == null) {
//         showToast(asProvider.getString('No more product found'), cc.blackColor);
//       }
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/all_product_service.dart';
import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../utils/custom_preloader.dart';
import '../widgets/common/product_card.dart';
import '../widgets/skelletons/product_card_skeleton.dart';
import '../widgets/search_view/filter_bottom_sheet.dart';
import '../utils/responsive.dart';
import '../services/product_details_service.dart';


class ProductsView extends StatefulWidget {
  static const routeName = 'products_view';
  const ProductsView({Key? key}) : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ScrollController controller = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllProductsService>(context, listen: false).fetchProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: Container(
        width: screenWidth / 1.2,
        color: Colors.white,
        child: FilterBottomSheet(scaffoldKey),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: Consumer<AllProductsService>(builder: (context, apProvider, child) {
        if (apProvider.loading && apProvider.allProducts == null) {
          return _buildLoading();
        }
        if (apProvider.allProducts != null && apProvider.allProducts!.isEmpty) {
          return Center(child: Text(asProvider.getString('No product found')));
        }

        return Column(
          children: [
            Expanded(child: _buildGrid(apProvider)),
            if (apProvider.nextLoading)
              SizedBox(height: 60, child: CustomPreloader()),
            EmptySpaceHelper.emptyHight(20),
          ],
        );
      }),
    );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      child: GridView.builder(
        gridDelegate: const FlutterzillaFixedGridView(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          height: 200,
        ),
        padding: EdgeInsets.zero,
        itemCount: 12,
        shrinkWrap: true,
        clipBehavior: Clip.none,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, __) => ProductCardSkeleton(),
      ),
    );
  }

  Widget _buildGrid(AllProductsService ap) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      controller: controller,
      itemCount: ap.allProducts!.length,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
      itemBuilder: (_, index) {
        final e = ap.allProducts![index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Provider.of<ProductDetailsService>(context, listen: false)
                .clearProductDetails();
            Navigator.of(context).pushNamed(
              'product_details_view',
              arguments: [e.title, e.prdId],
            );
          },
          child: ProductCard(
            e.prdId,
            e.title ?? '',
            e.imgUrl,
            e.discountPrice ?? e.price,
            e.discountPrice != null ? e.price : null,
            index,
            badge: e.badge,
            discPercentage: e.campaignPercentage?.toStringAsFixed(2),
            cartable: e.isCartAble!,
            prodCatData: {
              'category': e.categoryId,
              'subcategory': e.subCategoryId,
              'childcategory': e.childCategoryIds,
            },
            rating: e.avgRatting,
            randomKey: e.randomKey,
            randomSecret: e.randomSecret,
            stock: e.stockCount,
            campaignStock: e.campaignStock,
          ),
        );
      },
    );
  }

  void _scrollListener() {
    final ap = Provider.of<AllProductsService>(context, listen: false);
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (!ap.nextLoading && ap.nextPage != null) {
        ap.fetchNextPageProducts(context);
      } else if (ap.nextPage == null) {
        showToast(asProvider.getString('No more product found'), cc.blackColor);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
