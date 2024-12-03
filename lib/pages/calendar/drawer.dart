import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:my_caly_flutter/config/text/title_text.dart';
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // id
                _makeString(_getId(), primaryBlack, 35),
                const SizedBox(height: 10,),
                // major and tags
                _makeString(_getMajor(), Colors.black45, 18),
                const SizedBox(height: 5,),
                FutureBuilder<List<String>>(
                  future: _getTags(),
                  builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.join(', '),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: Colors.black45
                        )
                      );
                    } else {
                      return const Text('No data available');
                    }
                  },
                ),
                const SizedBox(height: 30,),
                // check major 버튼
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/check_major');
                  },
                  child: Container(
                    height: 30,
                    width: 60,
                    color: primaryBlue,
                    child: Center(
                      child: BodyText(text: 'change', color: Colors.white,),
                    ),
                  ),
                )
              ],
            ),
          ),
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
            weight: FontWeight.w300,
            color: color,
          );
        }
        return const Text('No data available');
      },
    );
  }
}
