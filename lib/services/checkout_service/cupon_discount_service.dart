import 'package:flutter/cupertino.dart';
import '../../helpers/common_helper.dart';

class CuponDiscountService with ChangeNotifier {
  String? couponText;
  String? totalAmount;
  String? cartData;
  double couponDiscount = 0;
  bool isLoading = false;

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setCouponText(value) {
    couponText = value;
    notifyListeners();
  }

  setTotalAmount(double value) {
    totalAmount = formatAmount(value);
    notifyListeners();
  }

  setCarData(value) {
    cartData = value;
    notifyListeners();
  }

  clearCoupon() {
    couponText = null;
    totalAmount = null;
    cartData = null;
    couponDiscount = 0;
    isLoading = false;
  }
}
