import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/color.dart';
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
    Get.toNamed('/calendar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleText(text: 'mY-Caly', weight: FontWeight.w900, textAlign: TextAlign.center, size: 30, color: primaryBlue,),
            SizedBox(height: 30,),
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
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
