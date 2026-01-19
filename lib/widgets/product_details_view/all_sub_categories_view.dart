import 'package:flutter/material.dart';
import 'package:safecart/views/product_by_subcategory_view.dart';
import 'package:safecart/widgets/common/custom_app_bar.dart';

class AllSubCategoriesView extends StatelessWidget {
  final String categoryName;
  final List subcategories;

  const AllSubCategoriesView({
    super.key,
    required this.categoryName,
    required this.subcategories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().appBarTitled(context, categoryName, () {
        Navigator.pop(context);
      }),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: subcategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.8, // Adjust based on image/text size
        ),
        itemBuilder: (context, index) {
          final subcat = subcategories[index];
          return GestureDetector(
            onTap: () {
              // Now navigate to the products of THIS subcategory
              Navigator.of(context).pushNamed(
                ProductBySubcategoryView.routeName,
                arguments: [subcat['id'], subcat['name']],
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (subcat['image_url'] != null &&
                                subcat['image_url'].toString().isNotEmpty)
                            ? NetworkImage(subcat['image_url'])
                            : const AssetImage('assets/images/defaultsub.jpg')
                                as ImageProvider,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subcat['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}