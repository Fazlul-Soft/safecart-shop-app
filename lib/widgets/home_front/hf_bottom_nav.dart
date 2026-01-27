import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/services/cart_data_service.dart';
import 'package:safecart/services/compare_data_service.dart';
import 'package:safecart/services/wishlist_data_service.dart';

import '../../helpers/navigation_helper.dart';

class HFBottomNav extends StatelessWidget {
  const HFBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationHelper>(builder: (context, nProvider, child) {
      return BottomNavigationBar(
        selectedItemColor: cc.primaryColor,
        unselectedItemColor: cc.greyHint,
        backgroundColor: cc.pureWhite,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: nProvider.currentIndex,
        onTap: (value) => nProvider.setNavIndex(value),
        items: items,
      );
    });
  }

  List<BottomNavigationBarItem> get items => [
        BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/home_fill.svg',
              height: 27,
              color: cc.primaryColor,
            ),
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 27,
              color: cc.greyHint,
            ),
            label: asProvider.getString('Home')),
        BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/product_fill.svg',
              height: 27,
              color: cc.primaryColor,
            ),
            icon: SvgPicture.asset(
              'assets/icons/products.svg',
              height: 27,
              color: cc.greyHint,
            ),
            label: asProvider.getString('Products')),
        // BottomNavigationBarItem(
        //     activeIcon: SvgPicture.asset(
        //       'assets/icons/cart.svg',
        //       height: 27,
        //       color: cc.primaryColor,
        //     ),
        //     icon:
        //         Consumer<CartDataService>(builder: (context, cartData, child) {
        //       return badge.Badge(
        //         showBadge: cartData.cartList.isEmpty ? false : true,
        //         badgeContent: Text(
        //           cartData.totalQuantity().toString(),
        //           style: TextStyle(color: cc.pureWhite),
        //         ),
        //         child: SvgPicture.asset(
        //           'assets/icons/cart.svg',
        //           height: 27,
        //           color: cc.greyHint,
        //         ),
        //       );
        //     }),
        //     label: asProvider.getString('Cart')),
        BottomNavigationBarItem(
          icon: Consumer<CartDataService>(
            builder: (context, cartData, child) {
              return _navIconWithBadge(
                iconPath: 'assets/icons/cart.svg',
                isActive: false,
                count: cartData.totalQuantity(),
              );
            },
          ),
          activeIcon: Consumer<CartDataService>(
            builder: (context, cartData, child) {
              return _navIconWithBadge(
                iconPath: 'assets/icons/cart.svg',
                isActive: true,
                count: cartData.totalQuantity(),
              );
            },
          ),
          label: asProvider.getString('Cart'),
        ),

        BottomNavigationBarItem(
            icon: Consumer<WishlistDataService>(
                builder: (context, wishlistData, child) {
              return _navIconWithBadge(
                iconPath: 'assets/icons/mm.svg',
                isActive: false,
                count: wishlistData.wishlistItems.length,
              );
            }),
            activeIcon: Consumer<WishlistDataService>(
                builder: (context, wishlistData, child) {
              return _navIconWithBadge(
                iconPath: 'assets/icons/mm.svg',
                isActive: true,
                count: wishlistData.wishlistItems.length,
              );
            }),
            label: asProvider.getString('Saved')),
        BottomNavigationBarItem(
            activeIcon: Consumer<CompareDataService>(
                builder: (context, compareData, child) {
              return _navIconWithBadge(
                iconPath: 'assets/icons/compare.svg',
                isActive: true,
                count: compareData.compareItems.length,
              );
            }),
            icon: Consumer<CompareDataService>(
                builder: (context, compareData, child) {
              return _navIconWithBadge(
                iconPath: 'assets/icons/compare.svg',
                isActive: false,
                count: compareData.compareItems.length,
              );
            }),
            label: asProvider.getString('Compare')),
        BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/profile_fill.svg',
              height: 27,
              color: cc.primaryColor,
            ),
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              height: 27,
              color: cc.greyHint,
            ),
            label: asProvider.getString('Profile')),
      ];

  Widget _navIconWithBadge({
    required String iconPath,
    required bool isActive,
    required int count,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 27,
          color: isActive ? cc.primaryColor : cc.greyHint,
        ),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: cc.secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: cc.blackColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
