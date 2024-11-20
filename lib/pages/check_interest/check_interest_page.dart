import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../config/color.dart';
import '../../config/text/body_text.dart';
import '../../config/text/title_text.dart';

class CheckInterestPage extends StatefulWidget {
  const CheckInterestPage({super.key});

  @override
  State<CheckInterestPage> createState() => _CheckInterestPageState();
}

class _CheckInterestPageState extends State<CheckInterestPage> {
  final List<String> interests = [
    'Sports',
    'Music',
    'Art',
    'Technology',
    'Travel',
    'Cooking',
    'Gaming',
    'Reading',
    'Fitness',
    'Movies'
  ];
  List<String> selectedInterests = [];

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

  void _send() {
    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one interest.'),
        ),
      );
    } else {
      // 서버로 보내기
      String? major;
      String? grade;
      SharedPreferences.getInstance().then((prefs) {
        major = prefs.getString('selectedMajor');
        grade = prefs.getString('selectedGrade');
      });
      Get.toNamed('/calendar');
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;

    return Scaffold(
      backgroundColor: backgroundColor,
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Row(
                          children: [
                            Container(
                              height: 7,
                              width: (width - 60) / 2,
                              decoration: BoxDecoration(color: primaryGrey),
                            ),
                            Container(
                              height: 7,
                              width: (width - 60) / 2,
                              decoration: BoxDecoration(color: primaryBlue),
                            ),
                          ],
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
                                      ? Color(0xffEAF2FF)
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
                      SizedBox(height: 25,),
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
                            text: 'Next',
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
