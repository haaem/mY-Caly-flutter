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
    // debugPrint('ID: $id, Password: $password');
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
                        const TitleText(text: 'SIGNUP', weight: FontWeight.w800, textAlign: TextAlign.center, size: 15, color: primaryBlack,),
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
