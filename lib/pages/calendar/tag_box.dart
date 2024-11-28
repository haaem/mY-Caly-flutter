import 'package:flutter/material.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';

class TagBox extends StatelessWidget {
  final String tag;
  const TagBox({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xffE9ECEF)
      ),
      child: BodyText(text: tag, size: 15, weight: FontWeight.normal,),
    );
  }
}
