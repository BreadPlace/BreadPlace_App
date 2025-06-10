import 'package:flutter/material.dart';

class MypageScreenMain extends StatefulWidget {
  const MypageScreenMain({super.key});

  @override
  State<MypageScreenMain> createState() => _MypageScreenMainState();
}

class _MypageScreenMainState extends State<MypageScreenMain> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text("Mypage Screen"),
      ],
    );
  }
}
