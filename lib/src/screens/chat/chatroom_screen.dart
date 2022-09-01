import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/logger.dart';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({Key? key}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d('${Get.parameters['chatroomKey']}');
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.yellowAccent,
        alignment: Alignment.center,
        child: Text('${Get.parameters['chatroomKey']}'),
      ),
    );
  }
}
