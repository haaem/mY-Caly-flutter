import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:my_caly_flutter/config/text/title_text.dart';
import 'package:my_caly_flutter/pages/calendar/tag_box.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  String _getWeekday(int day) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[day-1];
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final event = args["event"];
    final color = args['color'];
    var media = MediaQuery.of(context).size;
    var width = media.width;
    DateTime start = event.startDate;
    DateTime end = event.endDate;
    List<String> tags = List<String>.from(event.tags);
    bool hasImage = !event.imageURL.isEmpty;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                child: Container(
                  height: 80,
                  width: width,
                  color: color,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 16,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_left_outlined, size: 25, color: primaryBlack,)
                        )
                      ),
                      Center(
                        child: TitleText(text: event.category, size: 20, weight: FontWeight.w600,),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: TitleText(text: event.title, size: 24, weight: FontWeight.w600,),
              ),
              const SizedBox(height: 30,),
              Container(
                width: width,
                height: 100,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: primaryGrey, width: 1),
                    bottom: BorderSide(color: primaryGrey, width: 1)
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BodyText(
                      text: '${start.year}.${start.month}.${start.day}(${_getWeekday(start.weekday)})'
                          '\n${start.hour}:${start.minute}',
                      color: primaryBlack,
                      textAlign: TextAlign.center,
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                    Image.asset('assets/image/triangle.png'),
                    BodyText(
                      text: '${end.year}.${end.month}.${end.day}(${_getWeekday(end.weekday)})'
                          '\n${end.hour}:${end.minute}',
                      color: primaryBlack,
                      textAlign: TextAlign.center,
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Wrap(
                spacing: 15,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: tags.map((tag) => TagBox(tag: tag)).toList(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(45, 55, 45, 45),
                child: event.content.isNotEmpty
                    ? BodyText(
                  text: event.content,
                  size: 15,
                  weight: FontWeight.w500,
                )
                    : const BodyText(
                  text: '내용이 없습니다.',
                  size: 15,
                  color: Colors.grey,
                  weight: FontWeight.w400,
                ),
              ),
              hasImage ? Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 45),
                child: Column(
                  children: (event.imageURL as List<String>).map((image) => Image.network(image)).toList(),
                ),
              ) : const SizedBox(height: 0,),
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(event.link);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    debugPrint('Could not launch $url');
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BodyText(text: 'Show more', underline: true, size: 15, color: Colors.black45,),
                    SizedBox(width: 3),
                    Icon(Icons.insert_link, color: Colors.black45)
                  ],
                ),
              ),
              const SizedBox(height: 45,)
            ]
          )
        ),
      ),
    );
  }
}
