import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/text/body_text.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final int id = args["id"];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: BodyText(text: '${id}',)
          ),
        ),
      ),
    );
  }
}
