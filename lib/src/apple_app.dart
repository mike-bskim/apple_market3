import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'bindings/init_binding.dart';
import 'constants/common_size.dart';
import 'router/locations.dart';
import 'states/user_state.dart';

// beamer 관련
final _routerDelegate = BeamerDelegate(
  initialPath: '/',
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      HomeLocation(),
      AuthLocation(), // 이게 없으면 beamToNamed 이동시 오류 발생함
    ],
  ),
  guards: [
    BeamGuard(
      // '/' 루트 페이지로 이동을 시도하기 전에 check 를 확인하고
      // check 의 리턴값이 ture 면 계속 진행(루트 페이지/HomeScreen() 으로 이동)
      // check 의 리턴값이 false 면 beamToNamed 으로 이동, '/auth'(AuthLocation) 으로 이동
      pathPatterns: ['/'],
      // guardNonMatching: true,
      check: (context, location) {
        debugPrint(
            'userState: ${context.read<UserProvider>().userState.toString()}');
        return context.read<UserProvider>().userState;
        // return context.watch<UserNotifier>().user != null;
      },
      beamToNamed: (origin, target) => '/auth',
      // showPage: BeamPage(key: const ValueKey(LOCATION_AUTH), child: StartScreen()),
    )
  ],
);

class AppleApp extends StatelessWidget {
  AppleApp({Key? key}) : super(key: key);

  // themeData 공통사용하기 위해서
  final themeData = ThemeData(
    primarySwatch: Colors.red,
    // 이걸 대표로 설정하면 기본 분위기가 유사하게 적용
    fontFamily: 'Dohyeon',
    // 배달의민족 도현체
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
          color: Colors.black87, fontSize: 12, fontWeight: FontWeight.normal),
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
  );

  @override
  Widget build(BuildContext context) {
// 여기에서 라우팅 방식을 설정함
    if (routerType == RouterType.beamer) {
      // beamer 라우팅시 설정방법
      return beamRouter(context);
    }
    // getx 라우팅시 설정방법
    return getRouter();
  }

  // getx 라우팅시 설정방법
  GetMaterialApp getRouter() {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apple Market Demo',
      theme: themeData,
      getPages: getPages(),
      // 전체에 필요한 Controller 를 초기 binding 에 추가함
      initialBinding: BindingInjection(),
    );
  }

  // beamer 라우팅시 설정방법
  ChangeNotifierProvider<UserProvider> beamRouter(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) => UserProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Apple Market Demo',
        theme: themeData,
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
        // backButtonDispatcher:
        //     BeamerBackButtonDispatcher(delegate: _routerDelegate),
      ),
    );
  }
}
