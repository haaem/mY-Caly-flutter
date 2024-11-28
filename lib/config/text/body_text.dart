import 'package:flutter/material.dart';
import 'package:my_caly_flutter/config/color.dart';

class BodyText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight weight;
  final TextAlign textAlign;
  final bool shadow;
  final bool underline;
  const BodyText({
    super.key,
    this.size = 16,
    required this.text,
    this.color = primaryBlack,
    this.weight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.shadow = false,
    this.underline = false
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontFamily: 'SFProRegular',
        fontSize: size,
        fontWeight: weight,
        decoration: underline ? TextDecoration.underline : null,
        shadows: shadow ? <Shadow> [const Shadow(offset: Offset(2.5, 2.5), blurRadius: 10, color: primaryBlack)] : null
      ),
    );
  }
}