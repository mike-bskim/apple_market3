import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/data_keys.dart';
import '../states/user_controller.dart';
import '../widgets/expandable_fab.dart';
import 'home/items_screen.dart';
import 'near/map_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint("************************* >>> build from MainScreen");
    return Scaffold(
      floatingActionButton: ExpandableFab(
        // distance between button and children,
        distance: 90,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              Get.toNamed(ROUTE_INPUT);
            },
            shape: const CircleBorder(),
            height: 48,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.edit),
          ),
          MaterialButton(
            onPressed: () {},
            shape: const CircleBorder(),
            height: 48,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.input),
          ),
          MaterialButton(
            onPressed: () {},
            shape: const CircleBorder(),
            height: 48,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      appBar: AppBar(
        // centerTitle: true,
        title: Obx(
          () => Text(
              (UserController.to.userModel.value == null)
                  ? ''
                  : UserController.to.userModel.value!.phoneNumber,
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // 로그아웃하면 '/auth' 로 이동
              // UserController.to.setUserAuth(false);
              // user 상태가 변하면서 스트림이 자동 호출되면서 로그아웃됨
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.text_justify),
          ),
        ],
      ),
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: <Widget>[
          const ItemsScreen(),
          (UserController.to.userModel.value == null)
              ? Container()
              : MapScreen(UserController.to.userModel.value!),
          Container(color: Colors.accents[3]),
          Container(color: Colors.accents[5]),
          Container(color: Colors.accents[7]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 아이콘이 선택되지 않아도 label 이 보이게 하는 옵션
        // shifting 으로 설정하면 클릭시에만 label 이 보임,
        type: BottomNavigationBarType.fixed,
        // 아이콘이 클릭되면 onTap 이 실행되고, 이걸 currentIndex 에 전달해야 함
        onTap: (index) {
          setState(() {
            debugPrint('BottomNavigationBar(index): $index');
            _bottomSelectedIndex = index;
          });
        },
        // 클릭된 화면으로 이동하려면 매핑해야함
        currentIndex: _bottomSelectedIndex,
        // free icons : flaticon.com 에서 다운로드
        items: [
          // 아이콘이 클릭되면 onTap 이 실행됨,
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(_bottomSelectedIndex == 0
                ? 'assets/imgs/house_filled.png'
                : 'assets/imgs/house.png')),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(_bottomSelectedIndex == 1
                ? 'assets/imgs/near-me_filled.png'
                : 'assets/imgs/near-me.png')),
            label: 'near',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(_bottomSelectedIndex == 2
                ? 'assets/imgs/chat_filled.png'
                : 'assets/imgs/chat.png')),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            icon: ImageIcon(AssetImage(_bottomSelectedIndex == 3
                ? 'assets/imgs/user_filled.png'
                : 'assets/imgs/user.png')),
            label: 'me',
          ),
        ],
      ),
    );
  }
}
