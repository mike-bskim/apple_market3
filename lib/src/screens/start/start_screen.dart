import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'address_page.dart';
import 'auth_page.dart';
import 'intro_page.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  // ~Controller() 끝나는 변수들은 항상 dispose 해야 한다
  // 단, StatelessWidget 에서는 제외
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    debugPrint("************************* >>> build from StartScreen");
    // 일반적으로 Provider 를 잘 사용하지 않지만
    // 여기선 하위 페이지들에게 적용하기 위해서 변수를 전달하는 것 보단
    // Provider 로 처리하는게 더 좋아서 적용함
    // 2가지 방법중 첫째는
    // return Provider<PageController>(
    //     create: (context) => PageController(),
    // 2가지 방법중 두번째는
    // return Provider<PageController>.value(
    //     value: _pageController,
    // 상황에 맞게 처리하면 된다다
    // 현재 상황에서는 두번째 방식이 적합하다
    // 이유는 Provider, PageView 에서 같은 컨트롤러를 사용해야 하기 때문입니다
    return Provider<PageController>.value(
      value: _pageController,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          // 이부분이 활성화 되면 사용자가 화면을 좌/우로 스크롤하지 못하게 설정 가능
          // physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            IntroPage(),
            AddressPage(),
            AuthPage(),
          ],
        ),
      ),
    );
  }
}
