import 'package:flutter/material.dart';

class LoginScreenMain extends StatefulWidget {
  const LoginScreenMain({super.key});

  @override
  State<LoginScreenMain> createState() => _LoginScreenMainState();
}

class _LoginScreenMainState extends State<LoginScreenMain> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Expanded(child: Text('MypageScreenMain'))]);
  }
}
