// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:safecart/views/product_search_view.dart';
// import 'package:safecart/views/products_view.dart';
// import 'package:safecart/views/wishlist_view.dart';
// import 'package:safecart/widgets/home_front/hf_app_bar.dart';

// import '../helpers/common_helper.dart';
// import '../helpers/navigation_helper.dart';
// import '../utils/responsive.dart';
// import '../widgets/home_front/hf_bottom_nav.dart';
// import '../widgets/home_view/home_app_drawer.dart';
// import 'cart_view.dart';
// import 'home_view.dart';
// import 'profile_view.dart';

// class HomeFrontView extends StatelessWidget {
//   static const routeName = 'home front';
//   HomeFrontView({super.key});
//   final homeFrontPages = [
//     HomeView(),
//     ProductsView(),
//     const CartView(),
//     const WishlistView(),
//     const ProfileView(),
//   ];
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

//   PreferredSizeWidget? appBar(BuildContext context) {
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenSizeAndPlatform(context);

//     DateTime? currentBackPressTime;
//     return Consumer<NavigationHelper>(builder: (context, nProvider, child) {
//       return WillPopScope(
//         onWillPop: () async {
//           if (nProvider.currentIndex != 0) {
//             nProvider.setNavIndex(0);
//             return false;
//           }
//           DateTime now = DateTime.now();
//           if (currentBackPressTime == null ||
//               now.difference(currentBackPressTime!) >
//                   const Duration(seconds: 2)) {
//             currentBackPressTime = now;
//             showToast(
//                 asProvider.getString('Press again to exit'), cc.blackColor);
//             return false;
//           }
//           return true;
//         },
//         child: Scaffold(
//           key: scaffoldKey,
//           drawer: nProvider.currentIndex != 4 ? const HomeAppDrawer() : null,
//           drawerEnableOpenDragGesture: false,
//           body: Stack(
//             children: [
//               if (nProvider.currentIndex == 4)
//                 Container(
//                   height: screenHeight / 2.5 >= 300 ? screenHeight / 2.5 : 300,
//                   width: double.infinity,
//                   color: cc.primaryColor,
//                 ),
//               CustomScrollView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   slivers: [
//                     HFAppBar(scaffoldKey),
//                     SliverFillRemaining(
//                       hasScrollBody:
//                           true, // This is key for the internal grid to scroll
//                       child: homeFrontPages[nProvider.currentIndex],
//                     ),
//                     // SliverList(
//                     //     delegate: SliverChildListDelegate([
//                     //   homeFrontPages[nProvider.currentIndex],
//                     // ]))
//                   ]),
//             ],
//           ),
//           bottomNavigationBar: const HFBottomNav(),
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/views/compare_product_view.dart';
import 'package:safecart/views/products_view.dart';
import 'package:safecart/views/wishlist_view.dart';
import 'package:safecart/widgets/home_front/hf_app_bar.dart';
import 'package:safecart/widgets/search_view/filter_bottom_sheet.dart'; // Import this

import '../helpers/common_helper.dart';
import '../helpers/navigation_helper.dart';
import '../utils/responsive.dart';
import '../widgets/home_front/hf_bottom_nav.dart';
import '../widgets/home_view/home_app_drawer.dart';
import 'cart_view.dart';
import 'home_view.dart';
import 'profile_view.dart';

class HomeFrontView extends StatelessWidget {
  static const routeName = 'home front';
  HomeFrontView({super.key});

  final homeFrontPages = [
    HomeView(),
    const ProductsView(), // Ensure this is const if possible
    const CartView(),
    const WishlistView(),
    const CompareProductView(),
    const ProfileView(),
  ];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    DateTime? currentBackPressTime;

    return Consumer<NavigationHelper>(builder: (context, nProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          if (nProvider.currentIndex != 0) {
            nProvider.setNavIndex(0);
            return false;
          }
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
            currentBackPressTime = now;
            showToast(asProvider.getString('Press again to exit'), cc.blackColor);
            return false;
          }
          return true;
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: nProvider.currentIndex != 5 ? const HomeAppDrawer() : null,
          // MODIFICATION: Add the endDrawer here so the GlobalKey can find it
          endDrawer: nProvider.currentIndex == 1
              ? Drawer(
                  width: screenWidth / 1.2,
                  child: SafeArea(
                    child: FilterBottomSheet(scaffoldKey),
                  ),
                )
              : null,
          drawerEnableOpenDragGesture: false,
          endDrawerEnableOpenDragGesture: false,
          body: Stack(
            children: [
              if (nProvider.currentIndex == 5)
                Container(
                  height: screenHeight / 2.5 >= 300 ? screenHeight / 2.5 : 300,
                  width: double.infinity,
                  color: cc.primaryColor,
                ),
              CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  HFAppBar(scaffoldKey),
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: homeFrontPages[nProvider.currentIndex],
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: const HFBottomNav(),
        ),
      );
    });
  }
}
