// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:safecart/models/search_product_model.dart';

// import '../helpers/common_helper.dart';
// import 'package:http/http.dart' as http;

// class SearchProductService with ChangeNotifier {
//   List<Datum>? searchedProduct;
//   String selectedName = '';
//   dynamic selectedCategory = '';
//   dynamic selectedSubCategory = '';
//   bool lodingCategoryProducts = false;
//   String selectedChildCats = '';
//   dynamic selectedMinPrice = '';
//   dynamic selectedMaxPrice = '';
//   int selectedRating = 0;
//   dynamic selectedColor = '';
//   dynamic selectedSize = '';
//   dynamic selectedBrand = '';
//   dynamic selectedTags;
//   bool loading = false;
//   bool noSubcategory = false;
//   String? nextPage;
//   bool nextLoading = false;
//   String url = '';

//   setLoading(value) {
//     loading = value ?? !loading;
//     notifyListeners();
//   }

//   setNextLoading(value) {
//     nextLoading = value ?? !nextLoading;
//     notifyListeners();
//   }

//   setFilterOptions(
//       {nameVal,
//       catVal,
//       subCatVal,
//       childCatVal,
//       colorVal,
//       sizeVal,
//       brandVal,
//       minPrice,
//       maxPrice,
//       rating}) {
//     selectedName = nameVal ?? selectedName;
//     selectedCategory = catVal ?? selectedCategory;
//     selectedSubCategory = subCatVal ?? selectedSubCategory;
//     selectedChildCats = childCatVal ?? selectedChildCats;
//     selectedColor = colorVal ?? selectedColor;
//     selectedSize = sizeVal ?? selectedSize;
//     selectedBrand = brandVal ?? selectedBrand;
//     selectedMinPrice = minPrice ?? selectedMinPrice;
//     selectedMaxPrice = maxPrice ?? selectedMaxPrice;
//     selectedRating = rating ?? selectedRating;
//   }

//   resetFilterOptions() {
//     searchedProduct = null;
//     // selectedName = '';
//     selectedCategory = '';
//     selectedSubCategory = '';
//     selectedChildCats = '';
//     selectedColor = '';
//     selectedSize = '';
//     selectedBrand = '';
//     selectedMinPrice = '';
//     selectedMaxPrice = '';
//     selectedRating = 0;
//   }

//   resetSearch() {
//     selectedName = '';
//     nextPage = null;
//   }

//   fetchProducts(BuildContext context) async {
//     searchedProduct = null;
//     setLoading(true);
//     final haveConnection = await checkConnection(context);
//     if (!haveConnection) {
//       setLoading(false);
//       searchedProduct = [];
//       return;
//     }
//     selectedMinPrice = selectedMinPrice == 'null' || selectedMinPrice == null
//         ? ''
//         : selectedMinPrice;
//     selectedMaxPrice = selectedMaxPrice == 'null' || selectedMaxPrice == null
//         ? ''
//         : selectedMaxPrice;
//     final url =
//         "$baseApi/product?name=$selectedName&category=$selectedCategory&sub_category=$selectedSubCategory&child_category=$selectedChildCats&size=$selectedSize&brand=$selectedBrand&color=$selectedColor&min_price=$selectedMinPrice&max_price=$selectedMaxPrice&rating=$selectedRating&sku&tag&delivery_option&refundable&inventory_warning&from_price&to_price&date_range&count";
//     try {
//       var request = http.Request('GET', Uri.parse(url));

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final data = jsonDecode(await response.stream.bytesToString());
//         print(data);
//         final tempPL = SearchProductModel.fromJson(data);
//         searchedProduct = tempPL.data;
//         nextPage = tempPL.currentPage < tempPL.lastPage
//             ? "$url&page=${tempPL.currentPage + 1}"
//             : null;
//         setLoading(false);
//       } else {
//         setLoading(false);
//         searchedProduct ??= [];
//         print(response.reasonPhrase);
//       }
//     } on TimeoutException {
//       setLoading(false);
//       searchedProduct ??= [];
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (err) {
//       setLoading(false);
//       searchedProduct ??= [];
//       print(err);
//     }
//   }

//   fetchNextPageProducts(BuildContext context) async {
//     setNextLoading(true);
//     final haveConnection = await checkConnection(context);
//     if (!haveConnection) {
//       setNextLoading(false);
//       searchedProduct ??= [];
//       return;
//     }
//     print(selectedName);
//     print('searching products '
//         '$nextPage');
//     try {
//       var request = http.Request('GET', Uri.parse('$nextPage'));

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final data = jsonDecode(await response.stream.bytesToString());
//         final tempPL = SearchProductModel.fromJson(data);
//         print(data);
//         for (var element in tempPL.data) {
//           searchedProduct!.add(element);
//         }

//         nextPage = tempPL.currentPage < tempPL.lastPage
//             ? "$url&page=${tempPL.currentPage + 1}"
//             : null;
//         print(searchedProduct?.length);
//         setNextLoading(false);
//       } else {
//         setNextLoading(false);
//         searchedProduct ??= [];
//         print(response.reasonPhrase);
//       }
//     } on TimeoutException {
//       setNextLoading(false);
//       searchedProduct ??= [];
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (err) {
//       setNextLoading(false);
//       searchedProduct ??= [];
//       print(err);
//     }
//   }
// }




import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/search_product_model.dart';
import '../helpers/common_helper.dart';

class SearchProductService with ChangeNotifier {
  List<Datum>? searchedProduct;
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
  bool loading = false;
  bool nextLoading = false;
  String? nextPage;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setNextLoading(bool value) {
    nextLoading = value;
    notifyListeners();
  }

  void resetProducts() {
    searchedProduct = null;
    nextPage = null;
    notifyListeners();
  }

  void resetFilterOptions() {
    searchedProduct = null;
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
  resetSearch() {
    selectedName = '';
    nextPage = null;
  }
  void setFilterOptions({
    String? nameVal,
    dynamic catVal,
    dynamic subCatVal,
    String? childCatVal,
    dynamic colorVal,
    dynamic sizeVal,
    dynamic brandVal,
    String? minPrice,
    String? maxPrice,
    int? rating,
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
    final params = <String>[];
    if (selectedName.isNotEmpty) params.add('name=$selectedName');
    if (selectedCategory != null && selectedCategory.isNotEmpty) params.add('category=$selectedCategory');
    if (selectedSubCategory != null && selectedSubCategory.isNotEmpty) params.add('sub_category=$selectedSubCategory');
    if (selectedChildCats.isNotEmpty) params.add('child_category=$selectedChildCats');
    if (selectedSize != null && selectedSize.isNotEmpty) params.add('size=$selectedSize');
    if (selectedBrand != null && selectedBrand.isNotEmpty) params.add('brand=$selectedBrand');
    if (selectedColor != null && selectedColor.isNotEmpty) params.add('color=$selectedColor');
    if (selectedMinPrice != null && selectedMinPrice.isNotEmpty) params.add('min_price=$selectedMinPrice');
    if (selectedMaxPrice != null && selectedMaxPrice.isNotEmpty) params.add('max_price=$selectedMaxPrice');
    if (selectedRating > 0) params.add('rating=$selectedRating');
    if (page != null) params.add('page=$page');
    final queryString = params.join('&');
    final url = queryString.isEmpty ? '$baseApi/product' : '$baseApi/product?$queryString';
    debugPrint('Filter URL: $url');
    return url;
  }

  Future<void> fetchProducts(BuildContext context) async {
    resetProducts();
    setLoading(true);
    if (!await checkConnection(context)) {
      setLoading(false);
      searchedProduct = [];
      showToast(asProvider.getString('No internet connection'), cc.red);
      notifyListeners();
      return;
    }

    try {
      final url = _filterUrl();
      final request = http.Request('GET', Uri.parse(url));
      final response = await request.send();
      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        debugPrint('API response: $data');
        final parsed = SearchProductModel.fromJson(data);
        searchedProduct = parsed.data ?? [];
        nextPage = parsed.currentPage < parsed.lastPage
            ? _filterUrl(parsed.currentPage + 1)
            : null;
      } else {
        debugPrint('Fetch products failed: ${response.reasonPhrase}');
        showToast(asProvider.getString('Failed to load products'), cc.red);
        searchedProduct = [];
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
      searchedProduct = [];
    } catch (e) {
      debugPrint('Error fetching products: $e');
      showToast(asProvider.getString('Error loading products'), cc.red);
      searchedProduct = [];
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> fetchNextPageProducts(BuildContext context) async {
    if (nextPage == null || nextLoading) return;
    setNextLoading(true);
    if (!await checkConnection(context)) {
      setNextLoading(false);
      showToast(asProvider.getString('No internet connection'), cc.red);
      notifyListeners();
      return;
    }

    try {
      final request = http.Request('GET', Uri.parse(nextPage!));
      final response = await request.send();
      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        debugPrint('Next page API response: $data');
        final parsed = SearchProductModel.fromJson(data);
        searchedProduct = [...searchedProduct ?? [], ...parsed.data ?? []];
        nextPage = parsed.currentPage < parsed.lastPage
            ? _filterUrl(parsed.currentPage + 1)
            : null;
      } else {
        debugPrint('Fetch next page failed: ${response.reasonPhrase}');
        showToast(asProvider.getString('Failed to load more products'), cc.red);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (e) {
      debugPrint('Error fetching next page: $e');
      showToast(asProvider.getString('Error loading more products'), cc.red);
    }
    setNextLoading(false);
    notifyListeners();
  }
}