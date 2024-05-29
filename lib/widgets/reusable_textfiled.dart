import 'package:android_inventory_system/utils/constant_colors.dart';
import 'package:flutter/material.dart';

class ReUsableTextField extends StatelessWidget {
  final String hintText;

  var icon1;
  var icon;

  final TextEditingController controller;
  ReUsableTextField(
      {super.key,
      required this.hintText,
      this.icon1,
      this.icon,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .07,
      width: double.infinity,
      decoration: BoxDecoration(
          color: textFliedColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * .06),
          SizedBox(width: 20, child: Icon(icon1)),
          SizedBox(width: MediaQuery.of(context).size.width * .06),
          Container(width: 1, height: 50, color: Colors.grey),
          Container(
            width: MediaQuery.of(context).size.width * .65,
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * .04),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: icon,
                hintText: hintText,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
