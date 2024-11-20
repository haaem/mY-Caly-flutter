import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:my_caly_flutter/config/text/title_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // controller
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 버튼 눌렀을 때
  void _login() {
    String id = _idController.text;
    String password = _passwordController.text;
    print('ID: $id, Password: $password');
    if (id.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'ID와 Password를 모두 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.toNamed('/calendar');
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;
    var height = media.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, height*0.25, 20, 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleText(text: 'mY-Caly', weight: FontWeight.w900, textAlign: TextAlign.center, size: 30, color: primaryBlue,),
              SizedBox(height: 60,),
              TitleText(text: 'LOGIN', weight: FontWeight.w800, textAlign: TextAlign.center, size: 20, color: primaryBlue,),
              SizedBox(height: 10,),
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
                  child: BodyText(text: 'Login', color: Colors.white,),
                  alignment: Alignment.center,
                  height: 50,
                  width: width-40,
                  decoration: BoxDecoration(border: Border.all(), color: primaryBlue, borderRadius: BorderRadius.circular(10)),
                ),
                onTap: () {
                  _login();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
