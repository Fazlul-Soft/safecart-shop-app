import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';

import '../../services/rtl_service.dart';

class CustomDropdown extends StatelessWidget {
  String hintText;
  List listData;
  String? value;
  void Function(dynamic)? onChanged;
  CustomDropdown(this.hintText, this.listData, this.onChanged,
      {this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: cc.greyBorder,
          width: 1,
        ),
      ),
      child: DropdownButton(
        hint: Text(
          hintText,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: cc.greyHint,
                fontSize: 14,
              ),
        ),
        underline: Container(),
        isExpanded: true,
        elevation: 0,
        isDense: true,
        value: value,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: cc.greyHint,
              fontSize: 14,
            ),
        icon: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: cc.greyHint,
        ),
        onChanged: onChanged,
        items: (listData).map((value) {
          return DropdownMenuItem(
            alignment: Provider.of<RTLService>(context, listen: false).langRtl
                ? Alignment.centerRight
                : Alignment.centerLeft,
            value: value,
            child: SizedBox(
              // width: screenWidth - 140,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
