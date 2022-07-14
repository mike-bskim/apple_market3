// import 'package:apple_market3/src/middleware/check_auth.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'router/locations.dart';

// beamer 관련
final _routerDelegate = BeamerDelegate(
  guards: [
    BeamGuard(
      // '/' 루트 페이지로 이동을 시도하기 전에 check 를 확인하고
      // check 의 리턴값이 ture 면 계속 진행(루트 페이지/HomeScreen() 으로 이동)
      // check 의 리턴값이 false 면 beamToNamed 으로 이동, '/auth'(AuthLocation) 으로 이동
      pathPatterns: ['/'],
      check: (context, location) {
        return false;
        // return context.watch<UserNotifier>().user != null;
      },
      beamToNamed: (origin, target) => '/auth',
    )
  ],
  locationBuilder: BeamerLocationBuilder(beamLocations: [
    HomeLocation(),
    AuthLocation(), // 이게 없으면 beamToNamed 이동시 오류 발생함
  ]),
);

class AppleApp extends StatelessWidget {
  const AppleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// 여기에서 라우팅 방식을 설정함
    // getx 라우팅시 설정방법
    // return getRouter();
    // beamer 라우팅시 설정방법
    return beamRouter();
  }

  // getx 라우팅시 설정방법
  GetMaterialApp getRouter() {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apple Market Demo',
      theme: ThemeData(
        primarySwatch: Colors.red, // 이걸 대표로 설정하면 기본 분위기가 유사하게 적용
        fontFamily: 'Dohyeon', // 배달의민족 도현체
        hintColor: Colors.grey[350],
        textTheme: const TextTheme(
          headline3: TextStyle(
            fontFamily: 'Dohyeon',
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          button: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.black87, fontSize: 15),
          subtitle2: TextStyle(color: Colors.grey, fontSize: 13),
          bodyText1: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.normal),
          bodyText2: TextStyle(
              color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w100),
        ),
        // inputDecorationTheme: const InputDecorationTheme(
        //   enabledBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(color: Colors.transparent),
        //   ),
        // ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              primary: Colors.white,
              minimumSize: const Size(10, 48)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          titleTextStyle: TextStyle(color: Colors.black87),
          actionsIconTheme: IconThemeData(color: Colors.black87),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black54,
        ),
      ),
      getPages: getPages(),
    );
  }

  // beamer 라우팅시 설정방법
  MaterialApp beamRouter() {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Apple Market Demo',
      theme: ThemeData(
        primarySwatch: Colors.red, // 이걸 대표로 설정하면 기본 분위기가 유사하게 적용
        fontFamily: 'Dohyeon', // 배달의민족 도현체
        hintColor: Colors.grey[350],
        textTheme: const TextTheme(
          headline3: TextStyle(
            fontFamily: 'Dohyeon',
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          button: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.black87, fontSize: 15),
          subtitle2: TextStyle(color: Colors.grey, fontSize: 13),
          bodyText1: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.normal),
          bodyText2: TextStyle(
              color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w100),
        ),
        // inputDecorationTheme: const InputDecorationTheme(
        //   enabledBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(color: Colors.transparent),
        //   ),
        // ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              primary: Colors.white,
              minimumSize: const Size(10, 48)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          titleTextStyle: TextStyle(color: Colors.black87),
          actionsIconTheme: IconThemeData(color: Colors.black87),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black54,
        ),
      ),
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}
