import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../middleware/check_auth.dart';
import '../screens/start/start_screen.dart';
import '../screens/home/home_screen.dart';

// GETx 관련
List<GetPage<dynamic>> getPages() {
  return [
    GetPage(
      name: '/',
      page: () => const HomeScreen(),
      middlewares: [CheckAuth()], // 미들웨어를 먼저 확인하고 "page:" 로 이동함
    ),
    GetPage(
      name: '/auth',
      page: () => StartScreen(),
      transition: Transition.fadeIn,
    ),
    // GetPage(name: '/user/:uid', pages: () => const UserInfoPage()),
  ];
}

// ********************** 이하는 Beamer 관련
// ignore_for_file: constant_identifier_names
const LOCATION_HOME = 'home';
const LOCATION_AUTH = 'auth';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
          key: ValueKey(LOCATION_HOME),
          title: LOCATION_HOME,
          child: HomeScreen()),
    ];
  }

  // 페이지 이동은 아래 2가지로 가능한데, 2번째는 pathPatterns => ['/'] 설정을 근거로 가능
  // BeamPage(child: StartScreen())
  // beamToNamed: (origin, target) => '/',
  @override
  List<Pattern> get pathPatterns => ['/'];
}

class AuthLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(key: const ValueKey(LOCATION_AUTH), child: StartScreen()),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/auth'];
}
