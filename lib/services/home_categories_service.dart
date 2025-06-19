// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:safecart/models/home_categories_model.dart';
// import 'package:safecart/models/product_by_category_model.dart';

// import '../helpers/common_helper.dart';

// class HomeCategoriesService with ChangeNotifier {
//   List<Category?>? categories;
//   bool categoryLoading = false;
//   Category? selectedCategory;
//   bool categoryProductLoading = false;
//   List<Datum>? categoryProducts;
//   String? tempCatName;

//   setCategoryLoading({value}) {
//     categoryLoading = value ?? !categoryLoading;
//     notifyListeners();
//   }

//   setSelectedCategory(value) async {
//     selectedCategory = value;
//     fetchHomeCategoryProducts(selectedCategory?.name);
//     notifyListeners();
//   }

//   setCategoryProductLoading({value}) {
//     categoryProductLoading = value ?? !categoryProductLoading;
//     notifyListeners();
//   }

//   fetchHomeCategories(BuildContext context, {refreshing = false}) async {
//     final haveConnection = await checkConnection(context);
//     if (!haveConnection) {
//       categories ??= [];
//       categoryProducts ??= [];
//       notifyListeners();
//       return;
//     }
//     if (!refreshing) {
//       setCategoryLoading(value: true);
//     }

//     try {
//       var request = http.MultipartRequest('GET', Uri.parse('$baseApi/category'));

//       print('API Request: $baseApi/category');

//       http.StreamedResponse response = await request.send();

//       print('API Response Status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(await response.stream.bytesToString());
//         categories = HomeCategoriesModel.fromJson(data).categories;
//         setCategoryLoading(value: false);
//         if (categories?.first != null) {
//           setSelectedCategory(categories!.first);
//         }
//       } else {
//         categories ??= [];
//         setCategoryLoading(value: false);
//         print(response.reasonPhrase);
//       }
//     } on TimeoutException {
//       categories ??= [];
//       setCategoryLoading(value: false);
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (err) {
//       categories ??= [];
//       setCategoryLoading(value: false);
//       print(err);
//     }
//   }

//   fetchHomeCategoryProducts(name, {refreshing = false}) async {
//     print('$baseApi/product?category=$name');
//     if (name == null && tempCatName == null) {
//       return;
//     }
//     if (!refreshing) {
//       setCategoryProductLoading(value: true);
//     }
//     try {
//       final response =
//           await http.get(Uri.parse('$baseApi/product?category=$name'));
//       print(response.statusCode);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         categoryProducts = ProductByCategoryModel.fromJson(data).data;
//         setCategoryProductLoading(value: false);
//         notifyListeners();
//       } else {
//         categoryProducts ??= [];
//         setCategoryProductLoading(value: false);
//         print('category product fetch failed text');
//         print(response.body);
//       }
//     } on TimeoutException {
//       categoryProducts ??= [];
//       setCategoryProductLoading(value: false);
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (e) {
//       categoryProducts ??= [];
//       setCategoryProductLoading(value: false);
//       showToast(asProvider.getString(e.toString()), cc.red);
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/home_categories_model.dart';
import 'package:safecart/models/product_by_category_model.dart';

import '../helpers/common_helper.dart';

class HomeCategoriesService with ChangeNotifier {
  List<Category?>? categories;
  bool categoryLoading = false;
  Category? selectedCategory;
  bool categoryProductLoading = false;
  List<Datum>? categoryProducts;
  String? tempCatName;
  final Map<int, Map<String, dynamic>> _subcategoryCache =
      {}; // Cache subcategory data
  final Map<int, String> _subcategoryNames = {}; // Cache subcategory names
  final Map<int, String> _subcategoryImages = {};

  Future<void> initializeSubcategories() async {
    if (categories == null)
      // await fetchHomeCategories(category); // Fetch categories if not loaded
    if (categories == null) return;

    for (var category in categories!) {
      if (category != null) {
        final categoryId = category.id?.toString() ?? '0';
        try {
          final response =
              await http.get(Uri.parse('$baseApi/subcategory/$categoryId'));
          print(
              'Initializing subcategory response for $categoryId: ${response.body}');
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final subcategories = data['subcategories'] as List<dynamic>? ?? [];
            for (var subcat in subcategories) {
              final subcatId = subcat['id'] as int;
              final subcatName = subcat['name'] as String?;
              _subcategoryNames[subcatId] = subcatName ?? 'Subcat $subcatId';
              _subcategoryImages[subcatId] =
                  subcat['image_url'] as String? ?? '';
            }
          }
        } catch (e) {
          print('Error initializing subcategories for $categoryId: $e');
        }
      }
    }
  }

  setCategoryLoading({value}) {
    categoryLoading = value ?? !categoryLoading;
    notifyListeners();
  }

  setSelectedCategory(value) async {
    selectedCategory = value;
    fetchHomeCategoryProducts(selectedCategory?.name);
    notifyListeners();
  }

  setCategoryProductLoading({value}) {
    categoryProductLoading = value ?? !categoryProductLoading;
    notifyListeners();
  }

  fetchHomeCategories(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      categories ??= [];
      categoryProducts ??= [];
      notifyListeners();
      return;
    }
    if (!refreshing) {
      setCategoryLoading(value: true);
    }

    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/category'));

      print('API Request: $baseApi/category');

      http.StreamedResponse response = await request.send();

      print('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        categories = HomeCategoriesModel.fromJson(data).categories;
        setCategoryLoading(value: false);
        if (categories?.first != null) {
          setSelectedCategory(categories!.first);
        }
      } else {
        categories ??= [];
        setCategoryLoading(value: false);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      categories ??= [];
      setCategoryLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      categories ??= [];
      setCategoryLoading(value: false);
      print(err);
    }
  }

  fetchHomeCategoryProducts(String? name, {refreshing = false}) async {
    print('$baseApi/product?category=$name');
    if (name == null && tempCatName == null) {
      return;
    }
    if (!refreshing) {
      setCategoryProductLoading(value: true);
    }
    try {
      final response =
          await http.get(Uri.parse('$baseApi/product?category=$name'));
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        categoryProducts = ProductByCategoryModel.fromJson(data).data;
        setCategoryProductLoading(value: false);
        notifyListeners();
      } else {
        categoryProducts ??= [];
        setCategoryProductLoading(value: false);
        print('category product fetch failed text');
        print(response.body);
      }
    } on TimeoutException {
      categoryProducts ??= [];
      setCategoryProductLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (e) {
      categoryProducts ??= [];
      setCategoryProductLoading(value: false);
      showToast(asProvider.getString(e.toString()), cc.red);
    }
  }

  // Updated method to fetch subcategory image based on category_id and subcatId
  Future<String?> fetchSubcategoryImage(int subcatId, String categoryId) async {
    if (_subcategoryCache.containsKey(subcatId)) {
      return _subcategoryCache[subcatId]?['image_url'] ?? '';
    }

    try {
      final response =
          await http.get(Uri.parse('$baseApi/subcategory/$categoryId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final subcategories = data['subcategories'] as List<dynamic>;
        for (var subcat in subcategories) {
          final id = subcat['id'] as int;
          if (id == subcatId) {
            final imageUrl = subcat['image_url'] as String?;
            _subcategoryCache[subcatId] = {
              'name': subcat['name'] ?? 'Subcat $subcatId',
              'image_url': imageUrl ?? '',
            };
            return imageUrl;
          }
        }
        return null; // SubcatId not found
      } else {
        print('Subcategory image fetch failed: ${response.statusCode}');
        return null;
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
      return null;
    } catch (e) {
      print('Error fetching subcategory image: $e');
      return null;
    }
  }

  Map<int, String> get subcategoryNames => _subcategoryNames;
  // New method to fetch subcategory-wise products
  Future<void> fetchHomeSubcategoryProductsById(int subcategoryId,
      {refreshing = false}) async {
    print('$baseApi/product/subcategory/$subcategoryId');
    if (!refreshing) {
      setCategoryProductLoading(value: true);
    }
    try {
      final response = await http
          .get(Uri.parse('$baseApi/product/subcategory/$subcategoryId'));
      print('Subcategory products response status: ${response.statusCode}');
      print('Subcategory products data: ${response.body}'); // Add this line

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        categoryProducts = ProductByCategoryModel.fromJson(data).data;
        setCategoryProductLoading(value: false);
        notifyListeners();
      } else {
        categoryProducts ??= [];
        setCategoryProductLoading(value: false);
        print('Subcategory product fetch failed text');
        print(response.body);
      }
    } on TimeoutException {
      categoryProducts ??= [];
      setCategoryProductLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (e) {
      categoryProducts ??= [];
      setCategoryProductLoading(value: false);
      showToast(asProvider.getString(e.toString()), cc.red);
    }
  }
}
