import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/apple_app.dart';
import 'src/screens/splash/splash_screen.dart';
import 'src/utils/logger.dart';

void main() {
  // start_screen 에서 provider 를 사용하는데, 값을 변경하는게 아니고 사용만
  // 컨트롤러 자체만 사용 하는 경우는 아래 처럼 확실하게 컴파일러에게 알려줘야 한다
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const SplashScreen();
    return FutureBuilder<Object>(
        future: Future.delayed(const Duration(seconds: 2), () => 100),
        builder: (context, snapshot) {
          // 장면전환을 천천히 부드럽게 처리하는 위젯
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _splashLoadingWidget(snapshot));
        });
  }

// FutureBuilder 에서 딜레이 있음, 딜레이 동안은 SplashScreen(), 딜레이후에는 AppleApp() 로 이동
  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object> snapshot) {
    // future has 3 state, hasError, hasData, waiting
    if (snapshot.hasError) {
      logger.d('error occur while loading ~');
      return const Text('Error Occur');
    } else if (snapshot.hasData) {
      // logger.d('data is ${snapshot.data.toString()}');
      return AppleApp();
    } else {
      return const SplashScreen();
    }
  }
}
