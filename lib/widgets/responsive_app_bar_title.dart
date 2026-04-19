import 'package:flutter/material.dart';

class ResponsiveAppBarTitle extends StatelessWidget {
  const ResponsiveAppBarTitle(
    this.title, {
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final double fontSize;

        if (maxWidth < 140) {
          fontSize = 13;
        } else if (maxWidth < 220) {
          fontSize = 15;
        } else if (maxWidth < 320) {
          fontSize = 17;
        } else {
          fontSize = 20;
        }

        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
