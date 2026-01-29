// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/save_sign_in_info_service.dart';
import 'package:safecart/services/profile_info_service.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:safecart/services/search_filter_data_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../helpers/common_helper.dart';
import '../helpers/db_helper.dart';
import '../helpers/network_connectivity.dart';
import '../services/cart_data_service.dart';
import '../services/common_services.dart';
import '../services/compare_data_service.dart';
import '../services/payment_gateway_service.dart';
import '../services/wishlist_data_service.dart';
import '../utils/responsive.dart';
import 'home_front_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _starting = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dbInit(context);
      initiateStartingSequence(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: cc.primaryColor,
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
            ),
          ),
          Consumer<RTLService>(builder: (context, rtlProvider, child) {
            return Positioned(
                bottom: screenWidth / 2.5,
                child: rtlProvider.noConnection
                    ? TextButton(
                        onPressed: () {
                          initiateStartingSequence(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: cc.primaryColor,
                          backgroundColor: cc.pureWhite,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          surfaceTintColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          elevation: 0,
                        ),
                        child: Text(
                          asProvider.getString('Retry'),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: cc.primaryColor),
                        ),
                      )
                    : CustomPreloader(
                        whiteColor: true,
                        width: 80,
                      ));
          })
        ],
      ),
    );
  }

  void dbInit(BuildContext context) {
    List databases = ['cart', 'wishlist', 'compare'];
    databases.map((e) => DbHelper.database(e));
    Provider.of<CartDataService>(context, listen: false).fetchCarts();
    Provider.of<WishlistDataService>(context, listen: false)
        .fetchWishlistItem();
    Provider.of<CompareDataService>(context, listen: false)
        .fetchCompareItems();
  }

  Future<void> initiateStartingSequence(BuildContext context) async {
    if (_starting) {
      return;
    }
    _starting = true;
    rtlProvider.setNoConnection(false);
    try {
      await _runStartup(context).timeout(const Duration(seconds: 25));
    } on TimeoutException catch (err, st) {
      log('Splash startup timed out', error: err, stackTrace: st);
      rtlProvider.setNoConnection(true);
    } catch (err, st) {
      log('Splash startup failed: $err', stackTrace: st);
      rtlProvider.setNoConnection(true);
    } finally {
      if (mounted && !_navigated) {
        _starting = false;
      }
    }
  }

  Future<void> _runStartup(BuildContext context) async {
    final hasConnection = await checkConnection(context);
    if (!hasConnection) {
      rtlProvider.setNoConnection(true);
      return;
    }

    final NetworkConnectivity networkConnectivity =
        NetworkConnectivity.instance;
    networkConnectivity.listenToConnectionChange(context);
    await Provider.of<RTLService>(context, listen: false)
        .fetchCurrency(context);
    await Provider.of<RTLService>(context, listen: false).fetchLang(context);
    await Provider.of<SaveSignInInfoService>(context, listen: false)
        .getSaveinfos(context);
    log("fetching filter options");
    Provider.of<SearchFilterDataService>(context, listen: false)
        .fetchSearchfilterData(context);
    await Provider.of<CommonServices>(context, listen: false).introSubmitted();

    Provider.of<PaymentGatewayService>(context, listen: false)
        .fetchGateways(context);

    final pi = Provider.of<ProfileInfoService>(context, listen: false);
    await pi.fetchProfileInfo(context);
    _navigateTo(HomeFrontView.routeName);
    if (pi.profileInfo == null) {
      setToken('');
    }
  }

  void _navigateTo(String routeName) {
    if (_navigated || !mounted) {
      return;
    }
    _navigated = true;
    Navigator.of(context).popAndPushNamed(routeName);
  }
}
