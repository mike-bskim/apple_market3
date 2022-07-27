import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/common_size.dart';
import '../../utils/logger.dart';

class IntroPage extends StatelessWidget {
  // final PageController pageController;

  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(">>> build from IntroPage");
    // if (routerType == RouterType.getX){
    //   debugPrint('** current user state(GetX): ${UserController.to.userState}');
    // } else {
    //   debugPrint('** current user state(Provider): ${context.read<UserProvider>().userState}');
    // }
    // var _orgContext = context;
    FocusScope.of(context).unfocus();

    // 모바일 화면의 비율을 정할때 편한 위젯
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        final imgSize = size.width - padding_16 * 2;
        final sizeOfPosImg = imgSize * 0.1;

        return SafeArea(
          // 상태바 아래부터 , 아래 버튼위로 위젯이 위치시킴
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding_16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Apple Market',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(
                  width: imgSize,
                  height: imgSize,
                  child: Stack(
                    children: <Widget>[
                      ExtendedImage.asset('assets/imgs/carrot_intro.png'),
                      // Stack 안에서만 사용 가능함
                      Positioned(
                          // 가로 세로 길이 설정, 사이즈 설정
                          width: sizeOfPosImg,
                          height: sizeOfPosImg,
                          // 왼쪽과 위쪽의 간격 설정
                          left: imgSize * 0.45,
                          top: imgSize * 0.45,
                          child: ExtendedImage.asset('assets/imgs/carrot_intro_pos.png')),
                    ],
                  ),
                ),
                Text(
                  '우리 동네 중고 직거래 사과마켓',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  '사과 마켓은 동네 직거래 마켓이에요\n'
                  '내 동네를 설정하고 시작해보세요',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Column(
                  // 버튼을 글씨에 맞추지않고 최대한 늘리는 설정
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: padding_16),
                      child: TextButton(
                        onPressed: () async {
                          // _goToNextPage(_orgContext);
                          // context.read<PageController>().animateToPage(1,
                          //     duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          logger.d('on Intro page, text Button Clicked !!!');
                          context.read<PageController>().animateToPage(1,
                              duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        },
                        style:
                            TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                        child: Text(
                          '내 동네 설정하고 시작하기',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
