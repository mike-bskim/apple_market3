import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../constants/data_keys.dart';

/// "item_image" : "item_image",
/// "item_title" : "item_title",
/// "item_key" : "item_key",
/// "item_address" : "item_address",
/// "item_price" : 0.0,
/// "seller_key" : "seller_key",
/// "buyer_key" : "buyer_key",
/// "seller_image" : "seller_image",
/// "buyer_image" : "buyer_image",
/// "geo_fire_point" : "geo_fire_point",
/// "last_msg" : "last_msg",
/// "last_msg_time" : "",
/// "last_msg_user_key" : "last_msg_user_key",
/// "chatroom_key" : "chatroom_key"

// To parse this JSON data, do
//
//     final chatroomModel2 = chatroomModel2FromJson(jsonString);

import 'dart:convert';

ChatroomModel2 chatroomModel2FromJson(String str) => ChatroomModel2.fromJson(json.decode(str));

String chatroomModel2ToJson(ChatroomModel2 data) => json.encode(data.toJson());

class ChatroomModel2 {
  String itemImage;
  String itemTitle;
  String itemKey;
  String itemAddress;
  num itemPrice;
  String sellerKey;
  String buyerKey;
  String sellerImage;
  String buyerImage;
  GeoFirePoint geoFirePoint;
  String lastMsg;
  DateTime lastMsgTime;
  String lastMsgUserKey;
  String chatroomKey;
  bool negotiable;
  DocumentReference? reference;

  ChatroomModel2({
    required this.itemImage,
    required this.itemTitle,
    required this.itemKey,
    required this.itemAddress,
    required this.itemPrice,
    required this.sellerKey,
    required this.buyerKey,
    required this.sellerImage,
    required this.buyerImage,
    required this.geoFirePoint,
    this.lastMsg = '',
    required this.lastMsgTime,
    this.lastMsgUserKey = '',
    required this.chatroomKey,
    required this.negotiable,
    this.reference,
  });

  factory ChatroomModel2.fromJson(Map<String, dynamic> json) => ChatroomModel2(
        itemImage: json[DOC_ITEMIMAGE] ?? '',
        itemTitle: json[DOC_ITEMTITLE] ?? '',
        itemKey: json[DOC_ITEMKEY] ?? '',
        itemAddress: json[DOC_ITEMADDRESS] ?? '',
        itemPrice: json[DOC_ITEMPRICE] ?? 0,
        sellerKey: json[DOC_SELLERKEY] ?? '',
        buyerKey: json[DOC_BUYERKEY] ?? '',
        sellerImage: json[DOC_SELLERIMAGE] ?? '',
        buyerImage: json[DOC_BUYERIMAGE] ?? '',
        geoFirePoint: json[DOC_GEOFIREPOINT] == null
            ? GeoFirePoint(0, 0)
            : GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
                (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude),
        lastMsg: json[DOC_LASTMSG] ?? '',
        lastMsgTime: json[DOC_LASTMSGTIME] == null
            ? DateTime.now().toUtc()
            : (json[DOC_LASTMSGTIME] as Timestamp).toDate(),
        lastMsgUserKey: json[DOC_LASTMSGUSERKEY] ?? '',
        chatroomKey: json[DOC_CHATROOMKEY] ?? '',
        negotiable: json[DOC_NEGOTIABLE] ?? false,
      );

  Map<String, dynamic> toJson() => {
        DOC_ITEMIMAGE: itemImage,
        DOC_ITEMTITLE: itemTitle,
        DOC_ITEMKEY: itemKey,
        DOC_ITEMADDRESS: itemAddress,
        DOC_ITEMPRICE: itemPrice,
        DOC_SELLERKEY: sellerKey,
        DOC_BUYERKEY: buyerKey,
        DOC_SELLERIMAGE: sellerImage,
        DOC_BUYERIMAGE: buyerImage,
        DOC_GEOFIREPOINT: geoFirePoint.data,
        DOC_LASTMSG: lastMsg,
        DOC_LASTMSGTIME: lastMsgTime,
        DOC_LASTMSGUSERKEY: lastMsgUserKey,
        DOC_CHATROOMKEY: chatroomKey,
        DOC_NEGOTIABLE: negotiable,
      };

  // ChatroomModel2.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
  //     : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);
  //
  // ChatroomModel2.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
  //     : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  static String generateChatRoomKey({required String buyer, required String itemKey}) {
    return '${itemKey}_$buyer';
  }
}

// class ChatroomModel {
//   late String itemImage;
//   late String itemTitle;
//   late String itemKey;
//   late String itemAddress;
//   late num itemPrice;
//   late String sellerKey;
//   late String buyerKey;
//   late String sellerImage;
//   late String buyerImage;
//   late GeoFirePoint geoFirePoint;
//   late String lastMsg;
//   late DateTime lastMsgTime;
//   late String lastMsgUserKey;
//   late String chatroomKey;
//   DocumentReference? reference;
//
//   ChatroomModel(
//       {required this.itemImage,
//       required this.itemTitle,
//       required this.itemKey,
//       required this.itemAddress,
//       required this.itemPrice,
//       required this.sellerKey,
//       required this.buyerKey,
//       required this.sellerImage,
//       required this.buyerImage,
//       required this.geoFirePoint,
//       this.lastMsg = '',
//       required this.lastMsgTime,
//       this.lastMsgUserKey = '',
//       required this.chatroomKey,
//       this.reference});
//
//   ChatroomModel.fromJson(Map<String, dynamic> json, this.chatroomKey, this.reference) {
//     itemImage = json[DOC_ITEMIMAGE] ?? '';
//     itemTitle = json[DOC_ITEMTITLE] ?? '';
//     itemKey = json[DOC_ITEMKEY] ?? '';
//     itemAddress = json[DOC_ITEMADDRESS] ?? '';
//     itemPrice = json[DOC_ITEMPRICE] ?? 0;
//     sellerKey = json[DOC_SELLERKEY] ?? '';
//     buyerKey = json[DOC_BUYERKEY] ?? '';
//     sellerImage = json[DOC_SELLERIMAGE] ?? '';
//     buyerImage = json[DOC_BUYERIMAGE] ?? '';
//     geoFirePoint = json[DOC_GEOFIREPOINT] == null
//         ? GeoFirePoint(0, 0)
//         : GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
//             (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude);
//     lastMsg = json[DOC_LASTMSG] ?? '';
//     lastMsgTime = json[DOC_LASTMSGTIME] == null
//         ? DateTime.now().toUtc()
//         : (json[DOC_LASTMSGTIME] as Timestamp).toDate();
//     lastMsgUserKey = json[DOC_LASTMSGUSERKEY] ?? '';
//     chatroomKey = json[DOC_CHATROOMKEY] ?? '';
//   }
//
//   ChatroomModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);
//
//   ChatroomModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);
//
//   static String generateChatRoomKey(String buyer, String itemKey) {
//     return '${itemKey}_$buyer';
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map[DOC_ITEMIMAGE] = itemImage;
//     map[DOC_ITEMTITLE] = itemTitle;
//     map[DOC_ITEMKEY] = itemKey;
//     map[DOC_ITEMADDRESS] = itemAddress;
//     map[DOC_ITEMPRICE] = itemPrice;
//     map[DOC_SELLERKEY] = sellerKey;
//     map[DOC_BUYERKEY] = buyerKey;
//     map[DOC_SELLERIMAGE] = sellerImage;
//     map[DOC_BUYERIMAGE] = buyerImage;
//     map[DOC_GEOFIREPOINT] = geoFirePoint.data;
//     map[DOC_LASTMSG] = lastMsg;
//     map[DOC_LASTMSGTIME] = lastMsgTime;
//     map[DOC_LASTMSGUSERKEY] = lastMsgUserKey;
//     map[DOC_CHATROOMKEY] = chatroomKey;
//     return map;
//   }
// }
