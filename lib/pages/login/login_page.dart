import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:my_caly_flutter/config/text/title_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const storage = FlutterSecureStorage();

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
      Navigator.pushNamed(context, '/calendar');
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
        debugPrint('Response Data: ${response.data}');

        if (response.data is Map && response.data.containsKey('access_token')) {
          String token = response.data['access_token'];
          var val = jsonEncode(Login(id, password, token));

          await storage.write(key: 'login', value: val);
          Get.toNamed('/check_major');
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
    } on DioError catch (e) {
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, height*0.25, 20, 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TitleText(text: 'mY-Caly', weight: FontWeight.w900, textAlign: TextAlign.center, size: 30, color: primaryBlue,),
              const SizedBox(height: 60,),
              const TitleText(text: 'LOGIN', weight: FontWeight.w800, textAlign: TextAlign.center, size: 20, color: primaryBlue,),
              const SizedBox(height: 10,),
              // ID
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(color: Colors.black26),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20), // 간격
              // Password
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black26),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20), // 간격
              // 로그인 버튼
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: width-40,
                  decoration: BoxDecoration(border: Border.all(), color: primaryBlue, borderRadius: BorderRadius.circular(10)),
                  child: const BodyText(text: 'Login', color: Colors.white,),
                ),
                onTap: () {
                  _login();
                },
              ),
              const SizedBox(height: 20,),
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
