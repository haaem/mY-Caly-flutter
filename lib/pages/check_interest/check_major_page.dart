import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:my_caly_flutter/config/text/title_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckMajorPage extends StatefulWidget {
  const CheckMajorPage({super.key});

  @override
  State<CheckMajorPage> createState() => _CheckMajorPageState();
}

class _CheckMajorPageState extends State<CheckMajorPage> {
  final List<String> majors = ['기계공학부', '전기전자공학부', '신소재공학부', '건축공학과',
    '도시공학과','화학생명공학부','산업공학과', '디스플레이융합공학과', '컴퓨터과학과', '인공지능학과', '첨단융합공학부'];
  // final List<String> grades = ['1학년', '2학년', '3학년', '4학년'];

  String? selectedMajor;
  String? selectedGrade;

  void _saveMajor(String major) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('selectedMajor', major);
      // prefs.setString('selectedGrade', grade);
      // print("Saved Major: $major");
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Row(
                      children: [
                        Container(
                          height: 7,
                          width: (width-60)/2,
                          decoration: const BoxDecoration(color: primaryBlue),
                        ),
                        Container(
                          height: 7,
                          width: (width-60)/2,
                          decoration: const BoxDecoration(color: primaryGrey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const TitleText(text: 'Personalize your major', color: primaryBlack, size: 23, weight: FontWeight.w900,),
                  const SizedBox(height: 10,),
                  const BodyText(text: 'Choose your major.', color: Colors.grey),
                  const SizedBox(height: 80,),
                  // 전공 선택
                  const BodyText(text: 'Select your Major:', color: primaryBlack),
                  DropdownButton<String>(
                    value: selectedMajor,
                    hint: const Text('Select Major'),
                    isExpanded: true,
                    items: majors.map((String major) {
                      return DropdownMenuItem<String>(
                        value: major,
                        child: Text(major),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedMajor = value;
                      });
                    },
                  ),
                  // const SizedBox(height: 30,),
                  // 학년 선택
                  // const BodyText(text: 'Select your Grade:', color: primaryBlack),
                  // const SizedBox(height: 10),
                  // DropdownButton<String>(
                  //   value: selectedGrade,
                  //   hint: const Text('Select Grade'),
                  //   isExpanded: true,
                  //   items: grades.map((String grade) {
                  //     return DropdownMenuItem<String>(
                  //       value: grade,
                  //       child: Text(grade),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? value) {
                  //     setState(() {
                  //       selectedGrade = value;
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: 30,),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: width-40,
                      decoration: BoxDecoration(border: Border.all(), color: primaryBlue, borderRadius: BorderRadius.circular(10)),
                      child: const BodyText(text: 'Next', color: Colors.white,),
                    ),
                    onTap: () {
                      // if (selectedMajor != null && selectedGrade != null) {
                      if (selectedMajor != null) {
                        _saveMajor(selectedMajor!);
                        Get.toNamed('/check_interest');
                      } else {
                        // 전공이나 학년이 선택되지 않은 경우
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select your major')),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
        )
      ),
    );
  }
}
