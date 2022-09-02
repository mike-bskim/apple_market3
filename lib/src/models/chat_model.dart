import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/data_keys.dart';

/// "chatKey" : "",
/// "msg" : "",
/// "createDate" : "",
/// "userKey" : "",
/// "reference" : ""

// To parse this JSON data, do
//
//     final chatModel2 = chatModel2FromJson(jsonString);

import 'dart:convert';

ChatModel2 chatModel2FromJson(String str) => ChatModel2.fromJson(json.decode(str));

String chatModel2ToJson(ChatModel2 data) => json.encode(data.toJson());

class ChatModel2 {
  String? chatKey; // 자동생성되므로 ? 처리
  String msg;
  DateTime createdDate;
  String userKey;
  DocumentReference? reference;

  ChatModel2({
    // required this.chatKey, // 자동생성되므로 필수처리 제외.
    required this.msg,
    required this.createdDate,
    required this.userKey,
    this.reference,
  });

  factory ChatModel2.fromJson(Map<String, dynamic> json) => ChatModel2(
    // chatKey: json[DOC_CHATKEY], // 자동생성되므로 필수처리 제외.
    msg: json[DOC_MSG],
    createdDate: json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate(),
    userKey: json[DOC_USERKEY],
    // reference: json["reference"],
  );

  Map<String, dynamic> toJson() => {
    // DOC_CHATKEY: chatKey, // 자동생성되므로 필수처리 제외.
    DOC_MSG: msg,
    DOC_CREATEDDATE: createdDate,
    DOC_USERKEY: userKey,
    // "reference": reference,
  };
}


// class ChatModel {
//   String? chatKey;
//   late String msg;
//   late DateTime createDate;
//   late String userKey;
//   DocumentReference? reference;
//
//   ChatModel({
//     // required this.chatKey,
//     required this.msg,
//     required this.createDate,
//     required this.userKey,
//     this.reference,
//   });
//
//   ChatModel.fromJson(Map<String, dynamic> json, this.chatKey, this.reference) {
//     // chatKey = json[DOC_CHATKEY];
//     msg = json[DOC_MSG] ?? '';
//     createDate = json[DOC_CREATEDDATE] == null
//         ? DateTime.now().toUtc()
//         : (json[DOC_CREATEDDATE] as Timestamp).toDate();
//     userKey = json[DOC_USERKEY] ?? '';
//     // reference = json['reference'];
//   }
//
//   ChatModel.fromQuerySnapshot(
//       QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);
//
//   ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     // map[DOC_CHATKEY] = chatKey;
//     map[DOC_MSG] = msg;
//     map[DOC_CREATEDDATE] = createDate;
//     map[DOC_USERKEY] = userKey;
//     // map['reference'] = reference;
//     return map;
//   }
// }
