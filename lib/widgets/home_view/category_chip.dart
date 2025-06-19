import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class CategoryChip extends StatelessWidget {
  String title;
  bool isSelected;
  void Function()? onTap;
  CategoryChip(this.title, this.isSelected, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? null : Border.all(color: cc.greyBorder),
            color: isSelected ? cc.primaryColor : null,
          ),
          child:
              Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? cc.pureWhite : cc.greyHint),
          ),
          //   ],
          // ),
        ));
  }
}
