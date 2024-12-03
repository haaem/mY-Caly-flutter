import 'package:flutter/material.dart';
import '../../config/color.dart';
import '../../config/text/body_text.dart';
import '../../config/text/title_text.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final dio = Dio();

  final TextEditingController _idController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void _signup() async {
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
    //debugPrint('ID: $id, Password: $password');
    final response = await dio.request(
      'http://3.36.111.1/api/users/signup',
      options: Options(
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: {'username': id, 'password': password},
    );
    if (response.statusCode == 200) {
      Get.toNamed('/login');
    } else {
      throw Exception('Failed to sign up');
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;
    var height = media.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, height*0.25, 20, 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TitleText(text: 'mY-Caly', weight: FontWeight.w900, textAlign: TextAlign.center, size: 30, color: primaryBlue,),
                const SizedBox(height: 60,),
                const TitleText(text: 'Sign Up', weight: FontWeight.w800, textAlign: TextAlign.center, size: 20, color: primaryBlue,),
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
                    child: const BodyText(text: 'Sign Up', color: Colors.white,),
                  ),
                  onTap: () {
                    _signup();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
