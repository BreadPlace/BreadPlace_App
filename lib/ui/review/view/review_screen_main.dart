import 'package:flutter/material.dart';

class ReviewScreenMain extends StatefulWidget {
  const ReviewScreenMain({super.key});

  @override
  State<ReviewScreenMain> createState() => _ReviewScreenMainState();
}

class _ReviewScreenMainState extends State<ReviewScreenMain> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Expanded(child: Text('ReviewScreenMain'))]);
  }
}
