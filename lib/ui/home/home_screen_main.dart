import 'package:bread_place/ui/common_widgets/primary_button.dart';
import 'package:bread_place/ui/common_widgets/secondary_button.dart';
import 'package:flutter/material.dart';

class HomeScreenMain extends StatelessWidget {
  const HomeScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Text('HomeScreenMain')),
        const SizedBox(height: 50),
        PrimaryButton(text: 'PrimaryButton', onPressed: () {}),
        const SizedBox(height: 10),
        SecondaryButton(text: 'SecondaryButton', onPressed: () {}),
      ],
    );
  }
}
