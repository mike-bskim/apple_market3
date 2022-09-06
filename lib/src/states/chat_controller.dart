import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat_model.dart';
import '../models/chatroom_model.dart';
import '../repo/chat_service.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final String _chatroomKey;
  // 형선언을 직접해줘야 오류가 발생하지 않음
  final RxList<ChatModel2> _chatList = <ChatModel2>[].obs;
  final Rxn<ChatroomModel2> _chatroomModel = Rxn<ChatroomModel2>();

  // 형선언을 직접해줘야 오류가 발생하지 않음
  List<ChatModel2> get chatList => _chatList;
  Rxn<ChatroomModel2> get chatroomModel => _chatroomModel;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    debugPrint('************************* >>> ChatController >> onReady');
    debugPrint('>>> ChatController >> onReady .. [$_chatroomKey]');
    // logger.d('(onReady)user status - $user');
  }

  ChatController(this._chatroomKey) {
    // todo: connect chatroom
    ChatService().connectChatroom(_chatroomKey).listen((chatroomModel) {
      // stream 처리해서 변경시 자동 호출됨
      _chatroomModel.value = chatroomModel;

      if (_chatList.isEmpty) {
        // todo: fetch 10 latest chats, if chat list is empty
        ChatService().getChatList(_chatroomKey).then((chatList) {
          _chatList.addAll(chatList);
          // _chatList.addAll(chatList.reversed);
          // notifyListeners();
        });
      } else {
        // todo: when new chatroom arrive, fetch latest chats
        if (_chatList[0].reference == null) {
          _chatList.removeAt(0);
        }
        ChatService().getLatestChats(_chatroomKey, _chatList[0].reference!).then((latestChats) {
          _chatList.insertAll(0, latestChats);
          // _chatList.addAll(latestChats.reversed);
          // notifyListeners();
        });
      }
    });
  }

  void addNewChat(ChatModel2 chatModel) {
    // logger.d('chatroomKey>>>' + chatroomKey.toString());

    _chatList.insert(0, chatModel);

    ChatService().createNewChat(_chatroomKey, chatModel);
    // ChatService().createNewChat(chatroomKey, chatModel);
  }


}
