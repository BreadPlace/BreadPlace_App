import 'package:flutter/material.dart';

class SearchScreenMain extends StatefulWidget {
  const SearchScreenMain({super.key});

  @override
  State<SearchScreenMain> createState() => _SearchScreenMainState();
}

class _SearchScreenMainState extends State<SearchScreenMain> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Expanded(child: Text('SearchScreenMain'))]);
  }
}
