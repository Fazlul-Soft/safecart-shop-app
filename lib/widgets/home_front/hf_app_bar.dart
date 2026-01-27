// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:safecart/helpers/common_helper.dart';
// import 'package:safecart/helpers/navigation_helper.dart';
// import 'package:safecart/services/search_seatvice.dart';
// import 'package:safecart/views/product_search_view.dart';
// import 'package:safecart/widgets/home_front/custom_search_field.dart';

// import '../../services/profile_info_service.dart';
// import '../../services/search_product_service.dart';

// class HFAppBar extends StatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   const HFAppBar(this.scaffoldKey, {super.key});

//   @override
//   State<HFAppBar> createState() => _HFAppBarState();
// }

// class _HFAppBarState extends State<HFAppBar> {
//   bool showField = false;
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController textEditingController = TextEditingController();
//     return Consumer<NavigationHelper>(builder: (context, nhProvider, child) {
//       return SliverAppBar(
//         backgroundColor:
//             nhProvider.currentIndex == 4 ? cc.primaryColor : Colors.white,
//         foregroundColor:
//             nhProvider.currentIndex == 4 ? cc.primaryColor : cc.blackColor,
//         toolbarHeight: 65,
//         elevation: 0,
//         pinned: true,
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//         title:
//             Consumer<ProfileInfoService>(builder: (context, pProvider, child) {
//           return appBarTitle(pProvider, nhProvider.currentIndex);
//         }),
//         leading:
//             Consumer<NavigationHelper>(builder: (context, nhProvider, child) {
//           return nhProvider.currentIndex == 4
//               ? const SizedBox()
//               : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         print('opening drawer');
//                         widget.scaffoldKey.currentState!.openDrawer();
//                       },
//                       child: Container(
//                         padding: EdgeInsets.only(
//                             top: 10,
//                             left: rtlProvider.langRtl ? 0 : 10,
//                             right: rtlProvider.langRtl ? 10 : 0),
//                         color: Colors.transparent,
//                         child: GestureDetector(
//                             child: SvgPicture.asset(
//                           'assets/icons/menu.svg',
//                         )),
//                       ),
//                     ),
//                   ],
//                 );
//         }),
//         actions: [
//           Stack(
//             alignment: rtlProvider.langRtl
//                 ? Alignment.centerLeft
//                 : Alignment.centerRight,
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     height: 55,
//                     margin: EdgeInsets.only(
//                         top: 10,
//                         right: rtlProvider.langRtl ? 0 : 10,
//                         left: rtlProvider.langRtl ? 10 : 0),
//                     child: SizedBox(
//                       height: 45,
//                       child: Consumer<SearchService>(
//                           builder: (context, sProvider, child) {
//                         return CustomSearchField(
//                             textEditingController: textEditingController,
//                             showField: sProvider.showSearchBar,
//                             onFieldSubmit: () {
//                               if (textEditingController.text.isEmpty) {
//                                 return;
//                               }
//                               print(textEditingController.text);
//                               Provider.of<SearchProductService>(context,
//                                       listen: false)
//                                   .setFilterOptions(
//                                       nameVal: textEditingController.text);
//                               Provider.of<SearchProductService>(context,
//                                       listen: false)
//                                   .fetchProducts(context);
//                               FocusScope.of(context).unfocus();
//                               Navigator.of(context)
//                                   .pushNamed(ProductSearchView.routeName);
//                             });
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           )
//         ],
//       );
//     });
//   }

//   appBarTitle(pProvider, index) {
//     if (index == 0) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             pProvider.profileInfo == null
//                 ? (asProvider.getString('Welcome to'))
//                 : (asProvider.getString('Welcome back') + '!'),
//             style: const TextStyle(fontSize: 14),
//           ),
//           Text(
//             pProvider.profileInfo == null
//                 ? (asProvider.getString('Sombokchab'))
//                 : pProvider.profileInfo!.userDetails.name
//                     .toString()
//                     .capitalize(),
//             style: const TextStyle(fontSize: 20),
//           )
//         ],
//       );
//     }
//     if (index == 1) {
//       return Text(
//         "Products",
//         style: Theme.of(context)
//             .textTheme
//             .titleLarge!
//             .copyWith(color: cc.blackColor),
//       );
//     }
//     if (index == 2) {
//       return Text(
//         "My Cart",
//         style: Theme.of(context)
//             .textTheme
//             .titleLarge!
//             .copyWith(color: cc.blackColor),
//       );
//     }
//     if (index == 3) {
//       return Text(
//         "My Wishlist",
//         style: Theme.of(context)
//             .textTheme
//             .titleLarge!
//             .copyWith(color: cc.blackColor),
//       );
//     }
//     return const SizedBox();
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/navigation_helper.dart';
import 'package:safecart/services/profile_info_service.dart';
import 'package:safecart/helpers/common_helper.dart';

class HFAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HFAppBar(this.scaffoldKey, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationHelper>(builder: (_, nh, __) {
      debugPrint('HFAppBar: currentIndex=${nh.currentIndex}, scaffoldKey=$scaffoldKey');
      return SliverAppBar(
        backgroundColor: nh.currentIndex == 5 ? cc.primaryColor : Colors.white,
        foregroundColor: nh.currentIndex == 5 ? cc.primaryColor : cc.blackColor,
        toolbarHeight: 65,
        pinned: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Consumer<ProfileInfoService>(
          builder: (_, p, __) => _buildTitle(p, nh.currentIndex, context),
        ),
        leading: nh.currentIndex == 5
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  debugPrint('Menu icon tapped');
                  scaffoldKey.currentState?.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/icons/menu.svg'),
                ),
              ),
        actions: [
          if (nh.currentIndex == 1)
            GestureDetector(
              onTap: () {
                debugPrint('Filter icon tapped, scaffoldKey=$scaffoldKey');
                final state = scaffoldKey.currentState;
                debugPrint('Scaffold state: $state');
                if (state != null && state.hasEndDrawer) {
                  state.openEndDrawer();
                  debugPrint('EndDrawer opened');
                } else {
                  debugPrint('Failed to open EndDrawer: state=$state, hasEndDrawer=${state?.hasEndDrawer}');
                }
              },
              child: Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cc.greyFive, width: 1.5),
                  color: cc.pureWhite,
                ),
                child: SvgPicture.asset('assets/icons/filter.svg', color: cc.blackColor),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildTitle(ProfileInfoService p, int idx, BuildContext ctx) {
    if (idx == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.profileInfo == null ? asProvider.getString('Welcome to') : asProvider.getString('Welcome back') + '!',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            p.profileInfo == null ? asProvider.getString('Sombokchab') : p.profileInfo!.userDetails.name.capitalize(),
            style: const TextStyle(fontSize: 20),
          ),
        ],
      );
    } else if (idx == 1) {
      return Text("Products", style: Theme.of(ctx).textTheme.titleLarge!.copyWith(color: cc.blackColor));
    } else if (idx == 2) {
      return Text("My Cart", style: Theme.of(ctx).textTheme.titleLarge!.copyWith(color: cc.blackColor));
    } else if (idx == 3) {
      return Text("Save for Later", style: Theme.of(ctx).textTheme.titleLarge!.copyWith(color: cc.blackColor));
    } else if (idx == 4) {
      return Text("Compare", style: Theme.of(ctx).textTheme.titleLarge!.copyWith(color: cc.blackColor));
    }
    return const SizedBox();
  }
}
