import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../constants/data_keys.dart';

// class UserModel {
//   late String userKey;
//   late String phoneNumber;
//   late String address;
//   late num lat;
//   late num lon;
//   late GeoFirePoint geoFirePoint;
//   late DateTime createdDate;
//
//   // firestore 에서 데이터를 가져요거나, document 데이터를 가져오는 경우라면
//   // DocumentReference 를 넣어줄수 있다. 안넣어주어도 된다.
//   DocumentReference? reference;
//
//   UserModel({
//     required this.userKey,
//     required this.phoneNumber,
//     required this.address,
//     required this.lat,
//     required this.lon,
//     required this.geoFirePoint,
//     required this.createdDate,
//     this.reference,
//   });
//
//   UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference) {
//     userKey = json[DOC_USERKEY];
//     phoneNumber = json[DOC_PHONENUMBER];
//     address = json[DOC_ADDRESS];
//     lat = json[DOC_LAT];
//     lon = json[DOC_LON];
//     geoFirePoint = GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
//         (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude);
//     createdDate = json[DOC_CREATEDDATE] == null
//         ? DateTime.now().toUtc()
//         : (json[DOC_CREATEDDATE] as Timestamp).toDate();
//   }
//
//   // fromSnapshot 은 전달받은 인자를 fromJson 으로 전달한다.
//   // 전달하는 방법은 일반 함수처럼 {} 안에 넣는 방법도 있고,
//   // : this.fromJson() 방식으로 전달 가능하다, 검색 키워드 - '이니셜라이져'
//   UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(
//           snapshot.data()!,
//           snapshot.id,
//           snapshot.reference,
//         );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map[DOC_USERKEY] = userKey;
//     map[DOC_PHONENUMBER] = phoneNumber;
//     map[DOC_ADDRESS] = address;
//     map[DOC_LAT] = lat;
//     map[DOC_LON] = lon;
//     map[DOC_GEOFIREPOINT] = geoFirePoint.data;
//     map[DOC_CREATEDDATE] = createdDate;
//     // map['reference'] = reference;
//     return map;
//   }
//
//   @override
//   String toString() {
//     return 'UserModel {userKey: $userKey, phoneNumber: $phoneNumber, address: $address, lat: $lat, lon: $lon, geoFirePoint: ${geoFirePoint.data['geohash'].toString()}/${geoFirePoint.latitude}/${geoFirePoint.longitude}, createdDate: $createdDate, reference: ${reference.toString()}}';
//   }
// }

// To parse this JSON data, do
//
//     final userModel1 = userModel1FromJson(jsonString);

// UserModel1 userModel1FromJson(String str) => UserModel1.fromJson(json.decode(str));
// String userModel1ToJson(UserModel1 data) => json.encode(data.toJson());

class UserModel1 {
  String userKey;
  String phoneNumber;
  String address;
  num lat;
  num lon;
  GeoFirePoint geoFirePoint;
  DateTime createdDate;

  // firestore 에서 데이터를 가져요거나, document 데이터를 가져오는 경우라면
  // DocumentReference 를 넣어줄수 있다. 안넣어주어도 된다.
  DocumentReference? reference;

  UserModel1({
    required this.userKey,
    required this.phoneNumber,
    required this.address,
    required this.lat,
    required this.lon,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,
  });

  // reference 는 별도로 전달할 예정,
  factory UserModel1.fromJson(Map<String, dynamic> json) => UserModel1(
        userKey: json[DOC_USERKEY],
        phoneNumber: json[DOC_PHONENUMBER],
        address: json[DOC_ADDRESS],
        lat: json[DOC_LAT],
        lon: json[DOC_LON],
        geoFirePoint: json[DOC_GEOFIREPOINT] == null
            ? GeoFirePoint(0, 0)
            : GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
            (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude),
        createdDate: json[DOC_CREATEDDATE] == null
            ? DateTime.now().toUtc()
            : (json[DOC_CREATEDDATE] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        DOC_USERKEY: userKey,
        DOC_PHONENUMBER: phoneNumber,
        DOC_ADDRESS: address,
        DOC_LAT: lat,
        DOC_LON: lon,
        DOC_GEOFIREPOINT: geoFirePoint.data,
        DOC_CREATEDDATE: createdDate,
      };

  @override
  String toString() {
    return 'UserModel1 {userKey: $userKey, phoneNumber: $phoneNumber, address: $address, lat: $lat, lon: $lon, geoFirePoint: ${geoFirePoint.data['geohash'].toString()}/${geoFirePoint.latitude}/${geoFirePoint.longitude}, createdDate: $createdDate, reference: ${reference.toString()}}';
  }

}

/* 모델링 샘플 데이터
{
  "userKey": "userKey",
  "phoneNumber": "phoneNumber",
  "address": "address",
  "lat": 123,
  "lon": 123,
  "geoFirePoint": "geoFirePoint",
  "createdDate": "createdDate",
  "reference": "reference"
}
*/
