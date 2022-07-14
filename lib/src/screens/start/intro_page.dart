import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../constants/common_size.dart';
import '../../utils/logger.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // logger.d("IntroPage >> build");
    // logger.d('current user state: ${context.read<UserProvider>().userState}');
    // var _orgContext = context;
    FocusScope.of(context).unfocus();

    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        final imgSize = size.width - 32;
        final sizeOfPosImg = imgSize * 0.1;

        return SafeArea( // 상태바 아래부터 , 아래 버튼위로 위젯이 위치시킴
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
                      Positioned(
                          width: sizeOfPosImg,
                          height: sizeOfPosImg,
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
                        },
                        style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
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
