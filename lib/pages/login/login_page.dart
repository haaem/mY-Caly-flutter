import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:my_caly_flutter/config/text/title_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controller
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final dio = Dio();

  static final storage = const FlutterSecureStorage();
  dynamic userInfo = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key:'login');
    // user의 정보가 있다면 calendar 페이지로
    if (userInfo != null) {
      Get.offAllNamed('/calendar');
    }
  }
  
  _sendNotiToken(String id) async {
    String? token;
    SharedPreferences.getInstance().then((prefs) {
      token = prefs.getString('notificationToken');
    });
    if (token != null) {
      try {
        final response = await dio.put(
            'http://3.36.111.1/api/notification/register_token',
            queryParameters: {
              'username': id,
              'fcm_token': token
            }
        );
        if (response.statusCode != 200) {
          debugPrint('Invalid response format: ${response.data}');
          throw Exception('Invalid response format');
        }
      } catch (e) {
        print("Failed to send token: $e");
      }
    }
  }

  // 로그인 버튼 눌렀을 때
  void _login() async {
    try {
      String id = _idController.text;
      String password = _passwordController.text;

      if (id.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Error',
          'ID와 Password를 모두 입력해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await dio.request(
        'http://3.36.111.1/api/users/login',
        options: Options(
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
        ),
        queryParameters: {'username': id, 'password': password},
      );

      if (response.statusCode == 200) {
        //debugPrint('Response Data: ${response.data}');

        if (response.data is Map && response.data.containsKey('access_token')) {
          String token = response.data['access_token'];
          var val = jsonEncode(Login(id, password, token));
          await storage.write(key: 'login', value: val);

          await _sendNotiToken(id);

          final responseDetails = await dio.get(
            'http://3.36.111.1/api/users/$id/details',
            options: Options(
              headers: {'Content-Type': 'application/json'},
            ),
            queryParameters: {'username': id},
          );

          if (responseDetails.statusCode == 200) {
            final data = responseDetails.data;
            final String? college = data['college'];
            final List<String> tags = data['interested_tags'] != null
                ? List<String>.from(data['interested_tags'])
                : [];

            if (college == null || tags.isEmpty) {
              Get.toNamed('/check_major');
            } else {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('selectedMajor', college);
              await prefs.setStringList('selectedTags', tags);
              // print("tags들은 이거야"+tags.toString());
              Get.offAllNamed('/calendar');
            }
          } else {

            Get.snackbar(
              'Error',
              '서버에서 데이터를 가져오는 데 실패했습니다.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          debugPrint('Invalid response format: ${response.data}');
          throw Exception('Invalid response format');
        }
      } else {
        Get.snackbar(
          'Error',
          'ID 혹은 Password가 틀렸습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error: ${e.response?.statusCode} - ${e.response?.data}');
      Get.snackbar(
        'Error',
        '서버와 통신 중 문제가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('Unhandled Error: $e');
      Get.snackbar(
        'Error',
        '알 수 없는 오류가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;
    var height = media.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const TitleText(text: 'mY-Caly', weight: FontWeight.w900, textAlign: TextAlign.center, size: 30, color: primaryBlue,),
              // SizedBox(height: height*0.1,),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: const Color(0xffD8E6F6),
                  height: 155,
                  width: width-66,
                  child: Column(
                    children: [
                      const SizedBox(height: 18,),
                      const TitleText(text: 'LOGIN', weight: FontWeight.w800, textAlign: TextAlign.center, size: 15, color: primaryBlack,),
                      const SizedBox(height: 10,),
                      // ID
                      SizedBox(
                        height: 35,
                        width: width-100,
                        child: TextField(
                          controller: _idController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'ID',
                            labelStyle: const TextStyle(color: Colors.black26, fontSize: 15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Password
                      SizedBox(
                        height: 35,
                        width: width-100,
                        child: TextField(
                          controller: _passwordController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.black26, fontSize: 15),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // 로그인 버튼
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: width-66,
                  decoration: BoxDecoration(border: Border.all(), color: primaryBlue, borderRadius: BorderRadius.circular(10)),
                  child: const BodyText(text: 'Login', color: Colors.white,),
                ),
                onTap: () {
                  _login();
                },
              ),
              const SizedBox(height: 17,),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/signup');
                },
                child: const BodyText(
                  text: 'Sign Up',
                  color: primaryGrey,
                  underline: true,
                  size: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
