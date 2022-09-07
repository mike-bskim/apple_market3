import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/data_keys.dart';
import '../models/chat_model.dart';
import '../models/chatroom_model.dart';

class ChatService {
// 싱글톤 패턴 적용
  static final ChatService _chatService = ChatService._internal();

  factory ChatService() => _chatService;

  ChatService._internal();

// 채팅룸을 만드는 함수
  Future createNewChatroom(ChatroomModel2 chatroomModel) async {
    var chatroomKey = ChatroomModel2.generateChatRoomKey(
        buyer: chatroomModel.buyerKey, itemKey: chatroomModel.itemKey);

    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    final DocumentSnapshot documentSnapshot = await docRef.get();

    if (!documentSnapshot.exists) {
      await docRef.set(chatroomModel.toJson());
    }
  }

// 채팅룸 내부에 메시지를 저장하는 함수. 채팅룸 내부에 sub collection 구조로 저장.
  Future createNewChat(String chatroomKey, ChatModel2 chatModel) async {
    // col chatRoom > doc chartoomKey > col chats > doc ...
    // 실제 채팅이 저장되는 위치
    DocumentReference<Map<String, dynamic>> chatDocRef = FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .doc();

    DocumentReference<Map<String, dynamic>> chatroomDocRef =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    // await chatDocRef.set(chatModel.toJson());

    // 실제 채팅을 저장하고,
    // 동시에 채팅룸 정보가 저장된 doc 에 마지막 메시지 정보를 업뎃하여 화면표시가 쉽게 처리.
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(chatDocRef, chatModel.toJson());
      transaction.update(chatroomDocRef, {
        DOC_LASTMSG: chatModel.msg,
        DOC_LASTMSGTIME: chatModel.createdDate,
        DOC_LASTMSGUSERKEY: chatModel.userKey
      });
    });
  }

//todo: get chatroom detail
  // 스트림으로 모든 채팅을 처리하려면 비용적으로나 시간적(데이터 받는)으로 비용이 너무 큼,
  // 1. 채팅룸의 doc 을 스트림으로 연결하고 변경이 생기면 최근 메시지만 받는다,
  // 2. 새로운 메시지가 생기면 새로운 메시지들만 가져온다(중복해서 가져오지 않기)
  // 3. 스크롤링을 해서 마지막 메시지를 표시하면 다시 직전의 메시지 10개를 가져오게 처리할 것,

  // DocumentSnapshot<Map<String, dynamic>> 받는 값을 의미.
  // ChatroomModel2 출력 결과를 의미.
  var snapshotToChatroom =
      StreamTransformer<DocumentSnapshot<Map<String, dynamic>>, ChatroomModel2>.fromHandlers(
          handleData: (snapshot, sink) {
    // ChatroomModel chatroom = ChatroomModel.fromSnapshot(snapshot);
    ChatroomModel2 chatroom = ChatroomModel2.fromJson(snapshot.data()!);
    chatroom.chatroomKey = snapshot.id;
    chatroom.reference = snapshot.reference;

    sink.add(chatroom);
  });

  Stream<ChatroomModel2> connectChatroom(String chatroomKey) {
    // transform 통해서 DocumentSnapshot 을 ChatroomModel2 로 변환이 필요함
    return FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .snapshots()
        .transform(snapshotToChatroom);
  }

//todo: get char list
  Future<List<ChatModel2>> getChatList(String chatroomKey) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .limit(10)
        .get();

    List<ChatModel2> chatList = [];

    for (var docSnapshot in snapshot.docs) {
      // ChatModel2 chatModel = ChatModel2.fromQuerySnapshot(docSnapshot);
      ChatModel2 chatModel = ChatModel2.fromJson(docSnapshot.data());
      chatModel.chatKey = docSnapshot.id;
      chatModel.reference = docSnapshot.reference;
      chatList.add(chatModel);
    }
    return chatList;
  }

//todo: latest chats
  Future<List<ChatModel2>> getLatestChats(
      String chatroomKey, DocumentReference currentLatestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        // .endAtDocument(await currentLatestChatRef.get())
        .endBeforeDocument(await currentLatestChatRef.get())
        .get();

    List<ChatModel2> chatList = [];

    for (var docSnapshot in snapshot.docs) {
      // ChatModel2 chatModel = ChatModel2.fromQuerySnapshot(docSnapshot);
      ChatModel2 chatModel = ChatModel2.fromJson(docSnapshot.data());
      chatModel.chatKey = docSnapshot.id;
      chatModel.reference = docSnapshot.reference;
      chatList.add(chatModel);
    }
    return chatList;
  }

//todo: older chats
  Future<List<ChatModel2>> getOlderChats(
      String chatroomKey, DocumentReference oldestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .startAfterDocument(await oldestChatRef.get())
        .limit(10)
        .get();

    List<ChatModel2> chatList = [];

    for (var docSnapshot in snapshot.docs) {
      // ChatModel2 chatModel = ChatModel2.fromQuerySnapshot(docSnapshot);
      ChatModel2 chatModel = ChatModel2.fromJson(docSnapshot.data());
      chatModel.chatKey = docSnapshot.id;
      chatModel.reference = docSnapshot.reference;
      chatList.add(chatModel);
    }
    return chatList;
  }

  Future<List<ChatroomModel2>> getMyChatList(String myUserKey) async {
    List<ChatroomModel2> chatrooms = [];

    // todo: I am as a buyer
    QuerySnapshot<Map<String, dynamic>> buying = await FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .where(DOC_BUYERKEY, isEqualTo: myUserKey)
        .get();

    // todo: I am as a seller
    QuerySnapshot<Map<String, dynamic>> selling = await FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .where(DOC_SELLERKEY, isEqualTo: myUserKey)
        .get();

    for (var documentSnapshot in buying.docs) {
      ChatroomModel2 chatroom = ChatroomModel2.fromJson(documentSnapshot.data());
      chatroom.chatroomKey = documentSnapshot.id;
      chatroom.reference = documentSnapshot.reference;
      chatrooms.add(chatroom);
    }
    for (var documentSnapshot in selling.docs) {
      ChatroomModel2 chatroom = ChatroomModel2.fromJson(documentSnapshot.data());
      chatroom.chatroomKey = documentSnapshot.id;
      chatroom.reference = documentSnapshot.reference;
      chatrooms.add(chatroom);
    }

    // 정렬하는 기능,
    chatrooms.sort((a, b) => (b.lastMsgTime).compareTo(a.lastMsgTime));

    return chatrooms;
  }
}
