import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'dart:convert';

import '../constants/data_keys.dart';

// 개념정리용 참고 영상.
// https://www.youtube.com/watch?v=dYzbnge59TM
// https://www.youtube.com/watch?v=xFi43Ushq9I
// https://funncy.github.io/flutter/2021/03/06/firestore/
// https://firebase.flutter.dev/docs/firestore/usage/
// https://scarygami.medium.com/cloud-firestore-quicktip-documentsnapshot-vs-querysnapshot-70aef6d57ab3

/* 모델링 샘플 데이터
{
"itemKey":"itemKey",
"userKey":"userKey",
"userPhone":"userPhone",
"imageDownloadUrls":["aaa"],
"title":"title",
"category":"category",
"price":0.0,
"negotiable":true,
"detail":"detail",
"address":"address",
"geoFirePoint":"geoFirePoint",
"createdDate":"createdDate",
"reference":"referenc"
}
*/

// https://app.quicktype.io/ 사이트를 이용해서 변환 후, 약간의 수작업,
//     final itemModel2 = itemModel2FromJson(jsonString);

ItemModel2 itemModel2FromJson(String str) => ItemModel2.fromJson(json.decode(str));

String itemModel2ToJson(ItemModel2 data) => json.encode(data.toJson());

class ItemModel2 {
  String itemKey;
  String userKey;
  String userPhone;
  List<String> imageDownloadUrls;
  String title;
  String category;
  num price;
  bool negotiable;
  String detail;
  String address;
  GeoFirePoint geoFirePoint;
  DateTime createdDate;
  DocumentReference? reference;
  Uint8List? iconBytes;

  ItemModel2({
    required this.itemKey,
    required this.userKey,
    required this.userPhone,
    required this.imageDownloadUrls,
    required this.title,
    required this.category,
    required this.price,
    required this.negotiable,
    required this.detail,
    required this.address,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,
    this.iconBytes,
  });

  factory ItemModel2.fromJson(Map<String, dynamic> json) => ItemModel2(
        itemKey: json[DOC_ITEMKEY] ?? '',
        userKey: json[DOC_USERKEY] ?? '',
        userPhone: json[DOC_USERPHONE] ?? '',
        imageDownloadUrls: List<String>.from(json[DOC_IMAGEDOWNLOADURLS].map((x) => x)),
        title: json[DOC_TITLE] ?? '',
        category: json[DOC_CATEGORY] ?? 'none',
        price: json[DOC_PRICE] ?? 0,
        negotiable: json[DOC_NEGOTIABLE] ?? false,
        detail: json[DOC_DETAIL] ?? '',
        address: json[DOC_ADDRESS] ?? '',
        geoFirePoint: json[DOC_GEOFIREPOINT] == null
            ? GeoFirePoint(0, 0)
            : GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
                (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude),
        createdDate: json[DOC_CREATEDDATE] == null
            ? DateTime.now().toUtc()
            : (json[DOC_CREATEDDATE] as Timestamp).toDate(),
        // reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        DOC_ITEMKEY: itemKey,
        DOC_USERKEY: userKey,
        DOC_USERPHONE: userPhone,
        DOC_IMAGEDOWNLOADURLS: List<dynamic>.from(imageDownloadUrls.map((x) => x)),
        DOC_TITLE: title,
        DOC_CATEGORY: category,
        DOC_PRICE: price,
        DOC_NEGOTIABLE: negotiable,
        DOC_DETAIL: detail,
        DOC_ADDRESS: address,
        DOC_GEOFIREPOINT: geoFirePoint.data,
        DOC_CREATEDDATE: createdDate,
        // "reference": reference,
      };

  Map<String, dynamic> toMinJson() => {
        DOC_IMAGEDOWNLOADURLS: imageDownloadUrls.sublist(0, 1),
        //List<dynamic>.from(imageDownloadUrls.map((x) => x)),
        DOC_TITLE: title,
        DOC_PRICE: price,
      };

  static String generateItemKey(String uid) {
    String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();

    return '${uid}_$timeInMilli';
  }
}

// Json to Dart 플러그인을 이용해서 변환 후, 약간의 수작업,

/// itemKey : "itemKey"
/// userKey : "userKey"
/// userPhone : "userPhone"
/// imageDownloadUrls : ["aaa"]
/// title : "title"
/// category : "category"
/// price : 0.0
/// negotiable : true
/// detail : "detail"
/// address : "address"
/// geoFirePoint : "geoFirePoint"
/// createdDate : "createdDate"
/// reference : "referenc"

// class ItemModel {
// // late 키워드 없으면 초기화에서 required 선언해도 오류발생함,
//   late String itemKey;
//   late String userKey;
//   late String userPhone;
//   late List<String> imageDownloadUrls;
//   late String title;
//   late String category;
//   late num price;
//   late bool negotiable;
//   late String detail;
//   late String address;
//   late GeoFirePoint geoFirePoint;
//   late DateTime createdDate;
//   DocumentReference? reference;
//
//   ItemModel({
//     required this.itemKey,
//     required this.userKey,
//     required this.userPhone,
//     required this.imageDownloadUrls,
//     required this.title,
//     required this.category,
//     required this.price,
//     required this.negotiable,
//     required this.detail,
//     required this.address,
//     required this.geoFirePoint,
//     required this.createdDate,
//     this.reference,
//   });
//
//   ItemModel.fromJson(Map<String, dynamic> json, this.itemKey, this.reference) {
//     itemKey = json['itemKey'] ?? '';
//     userKey = json['userKey'] ?? '';
//     userPhone = json['userPhone'] ?? '';
//     imageDownloadUrls =
//         json['imageDownloadUrls'] != null ? json['imageDownloadUrls'].cast<String>() : [];
//     title = json['title'] ?? '';
//     category = json['category'] ?? 'none';
//     price = json['price'] ?? 0;
//     negotiable = json['negotiable'] ?? false;
//     detail = json['detail'] ?? '';
//     address = json['address'] ?? '';
//     geoFirePoint = json[DOC_GEOFIREPOINT] == null
//         ? GeoFirePoint(0, 0)
//         : GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
//             (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude);
//     createdDate = json[DOC_CREATEDDATE] == null
//         ? DateTime.now().toUtc()
//         : (json[DOC_CREATEDDATE] as Timestamp).toDate();
//     // reference = json['reference'];
//   }
//
// // DocumentSnapshot.data 는 null 가능하므로 ! 처리 필요함, doc().get() 인 경우 리턴타입임,
//   ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);
//
// // QueryDocumentSnapshot.data 는 null 불가능(! 필요없음), collection().get() 인 경우 리턴타입임,
//   ItemModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['itemKey'] = itemKey;
//     map['userKey'] = userKey;
//     map['userPhone'] = userPhone;
//     map['imageDownloadUrls'] = imageDownloadUrls;
//     map['title'] = title;
//     map['category'] = category;
//     map['price'] = price;
//     map['negotiable'] = negotiable;
//     map['detail'] = detail;
//     map['address'] = address;
//     map['geoFirePoint'] = geoFirePoint.data;
//     map['createdDate'] = createdDate;
//     // map['reference'] = reference;
//     return map;
//   }
//
//   static String generateItemKey(String uid) {
//     String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();
//
//     return '${uid}_$timeInMilli';
//   }
// }
