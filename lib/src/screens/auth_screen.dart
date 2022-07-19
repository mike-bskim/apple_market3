import 'package:flutter/material.dart';

import 'start/address_page.dart';
import 'start/intro_page.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        // 이부분이 활성화 되면 사용자가 화면을 좌/우로 스크롤하지 못하게 설정 가능
        // physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          IntroPage(pageController: _pageController),
          const AddressPage(),
          Container(color: Colors.accents[4]),
        ],
      ),
    );
  }
}
