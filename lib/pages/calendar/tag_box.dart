import 'package:flutter/material.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';

class TagBox extends StatelessWidget {
  final String tag;
  const TagBox({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffF4F4F4)
        ),
        child: BodyText(text: tag, size: 15, weight: FontWeight.normal,),
      ),
    );
  }
}
