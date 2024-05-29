import 'package:flutter/material.dart';

class ReusableButton extends StatefulWidget {
  final IconData? icon;
  final String text;
  final Color containerColor;

  const ReusableButton(
      {Key? key, this.icon, required this.text, required this.containerColor})
      : super(key: key);

  @override
  State<ReusableButton> createState() => _ReusableButtonState();
}

class _ReusableButtonState extends State<ReusableButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 25.0,
          )
        ],
        color: widget.containerColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(widget.icon),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
