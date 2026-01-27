import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/services/compare_data_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/compare_product_view/compare_product_card.dart';

class CompareProductView extends StatelessWidget {
  const CompareProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CompareDataService>(builder: (context, cProvider, child) {
      if (cProvider.compareItems.isEmpty) {
        return SizedBox(
          height: screenHeight - 140,
          child: Center(
            child: Text(
              asProvider.getString('No item found'),
              style: TextStyle(color: cc.greyHint),
            ),
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.58,
        ),
        itemCount: cProvider.compareItems.values.length,
        itemBuilder: (context, index) {
          final item = cProvider.compareItems.values.toList()[index];
          return CompareProductCard(
            item: item,
            onRemove: () async {
              await cProvider.deleteCompareItem(item.id, context);
            },
          );
        },
      );
    });
  }
}
