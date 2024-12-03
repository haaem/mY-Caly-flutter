import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:my_caly_flutter/config/text/title_text.dart';
import 'package:my_caly_flutter/pages/calendar/tag_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  static const storage = FlutterSecureStorage();
  String? id;

  Future<String> _getId() async {
    var userInfo = await storage.read(key: 'login');
    var decoded = jsonDecode(userInfo!);
    id = decoded['id'];
    return id!;
  }

  Future<String> _getMajor() async {
    final prefs = await SharedPreferences.getInstance();
    String? major = prefs.getString('selectedMajor');
    if (major == null) {
      throw Exception("Major not found in SharedPreferences");
    }
    return major;
  }

  Future<List<String>> _getTags() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? tags = prefs.getStringList('selectedTags');
    if (tags == null) {
      throw Exception("Tags not found in SharedPreferences");
    }
    return tags;
  }

  static Future<void> _logout() async {
    try {
      await storage.deleteAll();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint('Logout Error: $e');
      Get.snackbar(
        'Error',
        '로그아웃 중 문제가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;

    return SizedBox(
      width: width*0.8,
      child: Drawer(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // id
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30,30,30,20),
                      child: _makeString(_getId(), primaryBlack, 32),
                    ),
                    Container(
                      height: 1,
                      color: primaryGrey,
                    ),
                    // major and tags
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BodyText(text: '연세대학교', size: 20, color: primaryBlack, weight: FontWeight.w500,),
                          const SizedBox(height: 8,),
                          _makeString(_getMajor(), primaryBlack, 20),
                          const SizedBox(height: 25,),
                          FutureBuilder<List<String>>(
                            future: _getTags(),
                            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                              // 로딩 중일 때
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              else if (snapshot.hasData) {
                                List<String> tags = snapshot.data!;

                                return Wrap(
                                  spacing: 15,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.start,
                                  children: tags.map((tag) => TagBox(tag: tag)).toList(),
                                );
                              }
                              return const Text('No tags available');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25,),
                    Container(
                      height: 1,
                      color: primaryGrey,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // check major 버튼
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/check_major');
                    },
                    child: BodyText(text: 'Edit major', color: Colors.black45, underline: true,),
                  ),
                  Container(width: 1, height: 15,color: primaryGrey, margin: const EdgeInsets.symmetric(horizontal: 7)),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/check_interest');
                    },
                    child: BodyText(text: 'Edit interest', color: Colors.black45, underline: true,),
                  ),
                  Container(width: 1, height: 15, color: primaryGrey, margin: const EdgeInsets.symmetric(horizontal: 7),),
                  GestureDetector(
                    onTap: () {
                      _logout();
                    },
                    child: const Row(
                      children: [
                        BodyText(text: 'Logout', color: Colors.black45, underline: true,),
                        SizedBox(width: 1,),
                        Icon(Icons.logout_rounded, color: Colors.black45, size: 16,)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<String?> _makeString(Future<String> str, Color color, double size) {
    return FutureBuilder<String?>(
      future: str,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        else if (snapshot.hasData) {
          return TitleText(
            text: snapshot.data!,
            size: size,
            weight: FontWeight.w500,
            color: color,
          );
        }
        return const Text('No data available');
      },
    );
  }
}
