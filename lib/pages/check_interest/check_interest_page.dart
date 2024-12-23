import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../config/color.dart';
import '../../config/text/body_text.dart';
import '../../config/text/title_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CheckInterestPage extends StatefulWidget {
  const CheckInterestPage({super.key});

  @override
  State<CheckInterestPage> createState() => _CheckInterestPageState();
}

class _CheckInterestPageState extends State<CheckInterestPage> {
  final List<String> interests = [
  '공공서비스', '전문직', '경영·기획·컨설팅', '금융·회계', '통상·무역', '교육', '인사·경영지원', '광고·마케팅', '영업', '법률·법무', 'IT', '디자인', '의약·보건',
  '생산관리/품질관리', '전기·전자·반도체', '재료·신소재', '에너지·환경', '기계·로봇·자동화', '화학·화공·섬유', '바이오·식품', '토목·건설·환경'
  ];
  List<String> selectedInterests = [];
  final dio = Dio();

  static const storage = FlutterSecureStorage();

  void _toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        if (selectedInterests.length < 3) {
          selectedInterests.add(interest);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can select up to 3 interests.'),
            ),
          );
        }
      }
    });
  }

  void _send() async {
    dynamic userInfo = '';

    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one interest.'),
        ),
      );
    } else {
      // 서버로 보내기
      String? major;
      // String? grade;
      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('selectedTags', selectedInterests);
        major = prefs.getString('selectedMajor');
        // grade = prefs.getString('selectedGrade');
      });
      userInfo = await storage.read(key: 'login');
      var decoded = jsonDecode(userInfo);
      String id = decoded['id'];
      try {
        final response = await dio.request(
          'http://3.36.111.1/api/users/$id/details',
          options: Options(
            method: 'PUT',
          ),
          queryParameters: {
            'username': id,
            'college': major,
          },
          data: jsonEncode(selectedInterests)
        );
        if (response.statusCode == 200) {
          Get.offAllNamed('/calendar');
        }
      } on DioException catch (e) {
        debugPrint(
            'Dio Error: ${e.response?.statusCode} - ${e.response?.data}');
        Get.snackbar(
          'Error',
          '서버와 통신 중 문제가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      catch (e) {
        debugPrint('Unhandled Error: $e');
        Get.snackbar(
          'Error',
          '알 수 없는 오류가 발생했습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;

    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          width: (width-60),
                          height: 7,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const TitleText(
                        text: 'Personalize your Interests',
                        color: primaryBlack,
                        size: 23,
                        weight: FontWeight.w900,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const BodyText(
                          text: 'Choose your interests up to maximum 3.', color: Colors.grey),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: interests.length,
                          itemBuilder: (context, index) {
                            final interest = interests[index];
                            final isSelected = selectedInterests.contains(interest);
                            return GestureDetector(
                              onTap: () => _toggleInterest(interest),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xffEAF2FF)
                                      : primaryTransparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? primaryTransparent : primaryGrey
                                  )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      interest,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isSelected ? primaryBlue : primaryBlack,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check, color: primaryBlue),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 25,),
                      GestureDetector(
                        onTap: _send,
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: width - 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryBlue,
                          ),
                          child: const BodyText(
                            text: 'Done',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}
