import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class TitleCommon extends StatelessWidget {
  String title;
  void Function()? onPressed;
  bool seeAll;
  bool padding;
  bool compact;
  TitleCommon(this.title, this.onPressed,
      {this.seeAll = true,
      this.padding = false,
      this.compact = false,
      super.key});
  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        if (seeAll)
          TextButton(
            onPressed: onPressed,
            child: Text(asProvider.getString('View All'),
                textAlign: TextAlign.end,
                style: TextStyle(color: cc.primaryColor, fontSize: 14)),
            style: compact
                ? TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )
                : null,
          ),
        // const Icon(
        //   Icons.arrow_forward_ios,
        //   size: 18,
        // )
      ],
    );

    return Container(
      padding: padding ? const EdgeInsets.symmetric(horizontal: 20) : null,
      child: compact
          ? SizedBox(
              height: 32,
              child: Align(alignment: Alignment.centerLeft, child: row))
          : row,
    );
  }
}
