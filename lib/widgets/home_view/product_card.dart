import 'package:flutter/material.dart';
import 'package:safecart/models/product_by_category_model.dart'; // Import Datum
import 'package:safecart/helpers/common_helper.dart';

class ProductCard extends StatelessWidget {
  final Datum product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 230,
      decoration: BoxDecoration(
        color: cc.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Product image placeholder
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: product.imgUrl != null
                  ? DecorationImage(
                      image: NetworkImage(product.imgUrl!), // Use 'image' instead of 'imageUrl'
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title ?? 'No Name',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            '\$${product.price ?? 0.0}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}