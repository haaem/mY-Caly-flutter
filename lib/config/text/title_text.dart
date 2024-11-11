import 'package:flutter/material.dart';
import 'package:my_caly_flutter/config/color.dart';

class TitleText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight weight;
  final TextAlign textAlign;
  const TitleText({
    super.key,
    this.size = 28,
    required this.text,
    this.color = primaryBlack,
    this.weight = FontWeight.bold,
    this.textAlign = TextAlign.start
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontFamily: 'SFProBold',
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}
