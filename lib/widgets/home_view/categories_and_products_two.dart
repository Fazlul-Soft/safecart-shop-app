import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:safecart/widgets/common/title_common.dart';
import 'package:safecart/services/search_product_service.dart';
import 'package:safecart/views/product_by_category_view.dart';
import 'package:safecart/views/product_by_subcategory_view.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/product_details_view/all_sub_categories_view.dart';
import '../../helpers/common_helper.dart';

class CategoriesAndProductsTwo extends StatefulWidget {
  const CategoriesAndProductsTwo({super.key});

  @override
  State<CategoriesAndProductsTwo> createState() =>
      _CategoriesAndProductsTwoState();
}

class _CategoriesAndProductsTwoState extends State<CategoriesAndProductsTwo> {
  bool _loading = true;
  List<dynamic> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseApi/category/selected/with-subcategories'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['selected_category'] != null &&
            json['selected_category']['categories'] != null) {
          _categories = json['selected_category']['categories'];
        } else {
          _categories = [];
        }
      }
    } catch (_) {
      _categories = [];
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'No selected categories found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _categories.map((category) {
        final List subcategories = category['subcategory'] ?? [];

        return Padding(
          // ✅ SAME spacing style as FeatureProducts
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CATEGORY TITLE (NO EXTRA GAP)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TitleCommon(
                  category['name'] ?? '',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllSubCategoriesView(
                          categoryName: category['name'],
                          subcategories:
                              subcategories, // Pass the list directly
                        ),
                      ),
                    );
                    // Provider.of<SearchProductService>(context, listen: false)
                    //     .setFilterOptions(catVal: category['name']);

                    // Provider.of<SearchProductService>(context, listen: false)
                    //     .fetchProducts(context);

                    // Navigator.of(context).pushNamed(
                    //   ProductByCategoryView.routeName,
                    //   arguments: [category['name']],
                    // );
                  },
                  seeAll: true,
                  compact: true,
                ),
              ),

              /// SUBCATEGORY GRID (DYNAMIC HEIGHT – NO BOTTOM GAP)
              if (subcategories.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap:
                        true, // Allows the grid to take only the space it needs
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subcategories.length > 4
                        ? 4
                        : subcategories.length, // Limit to 4 items
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      // AspectRatio = Width / Height.
                      // If width is ~170, and you want 160(img) + 25(text), use ~0.85
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      final subcat = subcategories[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ProductBySubcategoryView.routeName,
                            arguments: [subcat['id'], subcat['name']],
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              // Let the image take available space based on AspectRatio
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (subcat['image_url'] != null &&
                                            subcat['image_url']
                                                .toString()
                                                .isNotEmpty)
                                        ? NetworkImage(subcat['image_url'])
                                        : const AssetImage(
                                                'assets/images/defaultsub.jpg')
                                            as ImageProvider,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subcat['name'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'No subcategories found',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
