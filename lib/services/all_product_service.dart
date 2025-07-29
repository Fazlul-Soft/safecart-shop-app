// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:safecart/models/search_product_model.dart';

// import '../helpers/common_helper.dart';
// import 'package:http/http.dart' as http;

// class AllProductsService with ChangeNotifier {
//   List<Datum>? allProducts;
//   bool loading = false;
//   bool noSubcategory = false;
//   String? nextPage;
//   bool nextLoading = false;

//   setLoading(value) {
//     loading = value ?? !loading;
//     notifyListeners();
//   }

//   setNextLoading(value) {
//     nextLoading = value ?? !nextLoading;
//     notifyListeners();
//   }

//   resetProducts() {
//     allProducts = null;
//   }

//   fetchProducts(BuildContext context) async {
//     allProducts = null;
//     setLoading(true);
//     final haveConnection = await checkConnection(context);
//     if (!haveConnection) {
//       setLoading(false);
//       return;
//     }

//     try {
//       var request = http.Request('GET', Uri.parse('$baseApi/product'));

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final data = jsonDecode(await response.stream.bytesToString());
//         print(data);
//         allProducts = SearchProductModel.fromJson(data).data;

//         final tempPL = SearchProductModel.fromJson(data);
//         nextPage = tempPL.currentPage < tempPL.lastPage
//             ? "$baseApi/product?&page=${tempPL.currentPage + 1}"
//             : null;
//         debugPrint("next page is $nextPage".toString());
//       } else {
//         print(response.reasonPhrase);
//       }
//     } on TimeoutException {
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (err) {
//       print(err);
//     } finally {
//       allProducts ??= [];
//       setLoading(false);
//     }
//   }

//   fetchNextPageProducts(BuildContext context) async {
//     setNextLoading(true);
//     final haveConnection = await checkConnection(context);
//     if (!haveConnection) {
//       setNextLoading(false);
//       // allProducts = [];
//       return;
//     }
//     print('getting next page $nextPage');
//     try {
//       var request = http.Request('GET', Uri.parse('$nextPage'));

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final data = jsonDecode(await response.stream.bytesToString());
//         print(data);
//         for (var element in SearchProductModel.fromJson(data).data) {
//           allProducts?.add(element);
//         }
//         final tempPL = SearchProductModel.fromJson(data);
//         nextPage = tempPL.currentPage < tempPL.lastPage
//             ? "$baseApi/product?&page=${tempPL.currentPage + 1}"
//             : null;
//         print(allProducts?.length);
//       } else {
//         print(response.reasonPhrase);
//       }
//     } on TimeoutException {
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (err) {
//       print(err);
//     } finally {
//       setNextLoading(false);
//     }
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/search_product_model.dart';
import '../helpers/common_helper.dart';

class AllProductsService with ChangeNotifier {
  List<Datum>? allProducts;
  bool loading = false;
  bool nextLoading = false;
  String? nextPage;

  // filter state
  String selectedName = '';
  dynamic selectedCategory = '';
  dynamic selectedSubCategory = '';
  String selectedChildCats = '';
  dynamic selectedColor = '';
  dynamic selectedSize = '';
  dynamic selectedBrand = '';
  dynamic selectedMinPrice = '';
  dynamic selectedMaxPrice = '';
  int selectedRating = 0;

  setLoading(bool? value) {
    loading = value ?? !loading;
    notifyListeners();
  }

  setNextLoading(bool? value) {
    nextLoading = value ?? !nextLoading;
    notifyListeners();
  }

  resetProducts() {
    allProducts = null;
    nextPage = null;
  }

  resetFilterOptions() {
    selectedName = '';
    selectedCategory = '';
    selectedSubCategory = '';
    selectedChildCats = '';
    selectedColor = '';
    selectedSize = '';
    selectedBrand = '';
    selectedMinPrice = '';
    selectedMaxPrice = '';
    selectedRating = 0;
    notifyListeners();
  }

  setFilterOptions({
    nameVal,
    catVal,
    subCatVal,
    childCatVal,
    colorVal,
    sizeVal,
    brandVal,
    minPrice,
    maxPrice,
    rating,
  }) {
    selectedName = nameVal ?? selectedName;
    selectedCategory = catVal ?? selectedCategory;
    selectedSubCategory = subCatVal ?? selectedSubCategory;
    selectedChildCats = childCatVal ?? selectedChildCats;
    selectedColor = colorVal ?? selectedColor;
    selectedSize = sizeVal ?? selectedSize;
    selectedBrand = brandVal ?? selectedBrand;
    selectedMinPrice = minPrice ?? selectedMinPrice;
    selectedMaxPrice = maxPrice ?? selectedMaxPrice;
    selectedRating = rating ?? selectedRating;
    notifyListeners();
  }

  String _filterUrl([int? page]) {
    final params = [
      "name=$selectedName",
      "category=$selectedCategory",
      "sub_category=$selectedSubCategory",
      "child_category=$selectedChildCats",
      "size=$selectedSize",
      "brand=$selectedBrand",
      "color=$selectedColor",
      "min_price=$selectedMinPrice",
      "max_price=$selectedMaxPrice",
      "rating=$selectedRating",
    ];
    if (page != null) params.add("page=$page");
    return "$baseApi/product?${params.join('&')}";
  }

  Future<void> fetchProducts(BuildContext context) async {
    resetProducts();
    setLoading(true);
    if (!await checkConnection(context)) {
      setLoading(false);
      return;
    }

    try {
      final url = _filterUrl();
      final req = http.Request('GET', Uri.parse(url));
      final resp = await req.send();
      if (resp.statusCode == 200) {
        final data = jsonDecode(await resp.stream.bytesToString());
        final parsed = SearchProductModel.fromJson(data);
        allProducts = parsed.data;
        nextPage = parsed.currentPage < parsed.lastPage
            ? _filterUrl(parsed.currentPage + 1)
            : null;
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (_) {}
    allProducts ??= [];
    setLoading(false);
  }

  Future<void> fetchNextPageProducts(BuildContext context) async {
    if (nextPage == null) return;
    setNextLoading(true);
    if (!await checkConnection(context)) {
      setNextLoading(false);
      return;
    }
    try {
      final req = http.Request('GET', Uri.parse(nextPage!));
      final resp = await req.send();
      if (resp.statusCode == 200) {
        final data = jsonDecode(await resp.stream.bytesToString());
        final parsed = SearchProductModel.fromJson(data);
        allProducts?.addAll(parsed.data);
        nextPage = parsed.currentPage < parsed.lastPage
            ? _filterUrl(parsed.currentPage + 1)
            : null;
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (_) {}
    setNextLoading(false);
  }
}
