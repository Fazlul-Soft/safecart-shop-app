import 'dart:convert';

import 'package:flutter/material.dart';

import '../helpers/common_helper.dart';
import '../helpers/db_helper.dart';

class CompareItem {
  final dynamic id;
  final dynamic vendorId;
  final String title;
  final double? price;
  final double? originalPrice;
  final String imgUrl;
  final bool isCartable;
  final dynamic prodCatData;
  final double rating;
  final dynamic randomKey;
  final dynamic randomSecret;

  CompareItem(
    this.id,
    this.vendorId,
    this.title,
    this.price,
    this.originalPrice,
    this.imgUrl,
    this.isCartable,
    this.prodCatData,
    this.rating,
    this.randomKey,
    this.randomSecret,
  );
}

class CompareDataService with ChangeNotifier {
  Map<String, CompareItem> _compareItems = {};

  Map<String, CompareItem> get compareItems {
    return _compareItems;
  }

  bool isCompare(String id) {
    return _compareItems.containsKey(id);
  }

  Future<void> toggleCompare(
    BuildContext context,
    dynamic id,
    String title,
    double price,
    double? originalPrice,
    String imgUrl,
    bool isCartable,
    prodCatData,
    vendorId,
    double rating, {
    required randomKey,
    required randomSecret,
  }) async {
    if (_compareItems.containsKey(id.toString())) {
      deleteCompareItem(id, context);
      _compareItems.remove(id.toString());
      notifyListeners();
      return;
    }

    await DbHelper.insert('compare', {
      'vendorId': vendorId,
      'productId': id,
      'title': title,
      'price': price,
      'originalPrice': originalPrice,
      'imgUrl': imgUrl,
      'isCartable': isCartable ? 0 : 1,
      'prodCatData': jsonEncode(prodCatData),
      'rating': rating,
      'random_key': randomKey,
      'random_secret': randomSecret
    });

    _compareItems.putIfAbsent(
      id.toString(),
      () => CompareItem(
        id,
        vendorId,
        title,
        price,
        originalPrice,
        imgUrl,
        isCartable,
        prodCatData,
        rating,
        randomKey,
        randomSecret,
      ),
    );
    showToast(asProvider.getString('Item added to compare list'), cc.blackColor);
    notifyListeners();
  }

  Future<void> fetchCompareItems() async {
    final dbData = await DbHelper.fetchDb('compare');
    Map<String, CompareItem> dataList = {};
    for (var element in dbData) {
      dataList.putIfAbsent(
        element['productId'].toString(),
        () => CompareItem(
          element['productId'],
          element['vendorId'],
          element['title'],
          element['price'],
          element['originalPrice'],
          element['imgUrl'],
          element['isCartable'] == 0,
          jsonDecode(
            element['prodCatData'],
          ),
          element['rating'],
          element['random_key'],
          element['random_secret'],
        ),
      );
    }
    _compareItems = dataList;
    notifyListeners();
  }

  Future<void> deleteCompareItem(dynamic id, BuildContext context) async {
    await DbHelper.deleteDbSI('compare', id);
    _compareItems.removeWhere((key, value) {
      return value.id.toString() == id.toString();
    });
    showToast(asProvider.getString('Item removed from compare list'),
        cc.blackColor);
    notifyListeners();
  }

  Future<void> emptyCompare() async {
    await DbHelper.deleteDbTable('compare');
    _compareItems = {};
    notifyListeners();
  }
}
