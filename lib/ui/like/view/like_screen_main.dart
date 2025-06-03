import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/like/widget/liked_bakery_container.dart';
import 'package:flutter/material.dart' hide Viewport;


class LikeScreenMain extends StatefulWidget {
  const LikeScreenMain({super.key});

  @override
  State<LikeScreenMain> createState() => _LikeScreenMainState();
}

class _LikeScreenMainState extends State<LikeScreenMain> {
  final dummyList = List.generate(10, (i) => Bakery(
    id: '$i',
    displayName: '테스트 베이커리 $i',
    languageCode: 'ko',
    formattedAddress: '서울시 어디 $i',
    formattedPhoneNumber: '010-0000-$i',
    location: Location.empty(),
    viewport: Viewport.empty(),
    plusCode: PlusCode.empty(),
    types: [],
    googleMapsUri: '',
    photoUri: '',
    photoId: '',
  ));

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(top: 8),
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: LikedBakeryContainer(bakery: dummyList[index]),
        );
      },
    );
  }
}