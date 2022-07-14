import 'package:flutter/material.dart';

import 'start/intro_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          const Center(
            child: Text(
              'AuthScreen',
              style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          // const IntroPage(),
          Container(color: Colors.accents[2]),
          Container(color: Colors.accents[4]),
        ],
      ),
    );
  }
}
