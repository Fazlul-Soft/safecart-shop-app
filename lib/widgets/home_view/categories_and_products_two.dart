import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/common/title_common.dart';
import 'package:safecart/helpers/empty_space_helper.dart';
import 'package:safecart/models/product_by_category_model.dart';
import 'package:safecart/services/home_categories_service.dart';
import 'package:safecart/services/search_product_service.dart';
import 'package:safecart/views/product_by_category_view.dart';
import 'package:safecart/views/product_by_subcategory_view.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:safecart/utils/responsive.dart';
import 'package:http/http.dart' as http;
import '../../helpers/common_helper.dart';

class CategoriesAndProductsTwo extends StatefulWidget {
  const CategoriesAndProductsTwo({super.key});

  @override
  _CategoriesAndProductsTwoState createState() =>
      _CategoriesAndProductsTwoState();
}

class _CategoriesAndProductsTwoState extends State<CategoriesAndProductsTwo> {
  late Timer _timer;
  final Map<String, List<int>> _cachedSubcategories = {};
  final Map<int, String> _subcategoryImages = {};
  final Map<int, String> _subcategoryNames = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
    _preloadSubcategories(); // Trigger preload
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    int minSeconds = 10 * 60;
    int maxSeconds = 15 * 60;
    int randomSeconds =
        minSeconds + Random().nextInt(maxSeconds - minSeconds + 1);

    _timer = Timer(Duration(seconds: randomSeconds), () {
      if (mounted) {
        setState(() {});
        _startTimer();
      }
    });
  }

  Future<void> _preloadSubcategories() async {
    final hcProvider =
        Provider.of<HomeCategoriesService>(context, listen: false);
    if (hcProvider.categories == null) return;

    for (var category in hcProvider.categories!) {
      if (category != null) {
        hcProvider.setSelectedCategory(category);
        await hcProvider.fetchHomeCategoryProducts(category.name);
        final categoryId = category.id?.toString() ?? '0';

        try {
          final response =
              await http.get(Uri.parse('$baseApi/subcategory/$categoryId'));
          print('Subcategory response for $categoryId: ${response.body}');
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final subcategories = data['subcategories'] as List<dynamic>? ?? [];
            final subcatIds =
                subcategories.map((subcat) => subcat['id'] as int).toList();
            _cachedSubcategories[category.name!] =
                subcatIds.isNotEmpty ? subcatIds : [];

            for (var subcat in subcategories) {
              final subcatId = subcat['id'] as int;
              final imageUrl = subcat['image_url'] as String?;
              final subcatName = subcat['name'] as String?;
              _subcategoryImages[subcatId] = imageUrl ?? '';
              _subcategoryNames[subcatId] =
                  subcatName ?? 'Subcat $subcatId'; // Name is set here
              print(
                  'Cached subcatId $subcatId: name=$subcatName, image=$imageUrl');
            }
          } else {
            _cachedSubcategories[category.name!] = [];
            print(
                'Subcategory fetch failed for $categoryId: ${response.statusCode}');
          }
        } catch (e) {
          _cachedSubcategories[category.name!] = [];
          print('Error fetching subcategories for $categoryId: $e');
        }
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<HomeCategoriesService>(builder: (context, hcProvider, child) {
          if (hcProvider.categories == null || hcProvider.categories!.isEmpty) {
            return Center(child: Text('No categories available'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hcProvider.categories!.length,
            itemBuilder: (context, categoryIndex) {
              final category = hcProvider.categories![categoryIndex];
              if (category == null) return const SizedBox();

              List<int>? subcatIds = _cachedSubcategories[category.name!];
              if (subcatIds == null) {
                print('No subcatIds for ${category.name}');
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text('Loading subcategories...'),
                );
              }

              final subcatList =
                  subcatIds.isNotEmpty ? List.from(subcatIds.take(4)) : [];
              print('SubcatList for ${category.name}: $subcatList');

              final categoryId = category.id?.toString() ?? '0';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TitleCommon(
                      category.name ?? 'Unknown Category',
                      () {
                        Provider.of<SearchProductService>(context,
                                listen: false)
                            .setFilterOptions(catVal: category.name!);
                        Provider.of<SearchProductService>(context,
                                listen: false)
                            .fetchProducts(context);
                        Navigator.of(context).pushNamed(
                          ProductByCategoryView.routeName,
                          arguments: [category.name!],
                        );
                      },
                      seeAll: true,
                    ),
                  ),
                  EmptySpaceHelper.emptyHight(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 400,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          subcatList.length > 4 ? 4 : subcatList.length,
                          (subcatIndex) {
                            print(
                                'Building item for subcatIndex: $subcatIndex, subcatId: ${subcatList[subcatIndex]}');
                            final subcatId = subcatList[subcatIndex];
                            final subcatName = _subcategoryNames[subcatId] ??
                                'Subcat $subcatId';
                            final subcatImage =
                                _subcategoryImages[subcatId] ?? '';

                            return GestureDetector(
                              onTap: () {
                                final hcProvider =
                                    Provider.of<HomeCategoriesService>(context,
                                        listen: false);
                                hcProvider
                                    .fetchHomeSubcategoryProductsById(subcatId);
                                Navigator.of(context).pushNamed(
                                  ProductBySubcategoryView.routeName,
                                  arguments: [subcatId, subcatName],
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenWidth / 2 - 30,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: subcatImage.isNotEmpty
                                            ? NetworkImage(subcatImage)
                                            : const AssetImage(
                                                'assets/images/defaultsub.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    subcatName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  EmptySpaceHelper.emptyHight(5),
                ],
              );
            },
          );
        }),
      ],
    );
  }
}
