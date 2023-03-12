import 'package:flutter/material.dart';
import 'package:dynamic_agent/Screens/screens.dart';

class BulletText extends StatelessWidget {
  const BulletText({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: dark,
          ),
          height: width * 0.02,
          width: width * 0.02,
          child: null,
        ),
        SizedBox(width: width * 0.02),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                color: dark,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
