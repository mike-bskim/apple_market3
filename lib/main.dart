import 'package:flutter/material.dart';

import 'src/apple_app.dart';
import 'src/screens/splash_screen.dart';
import 'src/utils/logger.dart';

void main() {
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
