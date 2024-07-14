import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  const YellowButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.width,
  });

  final String label;
  final Function() onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(25),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
