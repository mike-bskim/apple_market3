import 'package:apple_market3/src/states/user_state.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(">>> build from HomeScreen");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              // 로그아웃하면 '/auth' 로 이동
              UserController.to.setUserAuth(false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
