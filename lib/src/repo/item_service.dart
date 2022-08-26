import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/data_keys.dart';
import '../models/item_model.dart';
import '../utils/logger.dart';

class ItemService {
  // 싱글톤 디자인 패턴 ***************************************
  // 인스턴스가 한번만 생성되고, 2번째 생성시에는 처음 생성한 인스턴스를 리턴,
  static final ItemService _itemService = ItemService._internal();

  factory ItemService() => _itemService;

  ItemService._internal();

  Future createNewItem(ItemModel2 itemModel, String itemKey, String userKey) async {
    // 신규 작성글을 업로드하기 위한 위치 설정
    DocumentReference<Map<String, dynamic>> itemDocRef =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot documentSnapshot = await itemDocRef.get();

    // 신규 작성글을 사용자 정보의 하위 콜랙션에 추가, No SQL 에서는 역정규화 하는것이 좋을때가 있음,
    DocumentReference<Map<String, dynamic>> userItemDocRef = FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ITEMS)
        .doc(itemKey);

    // 신규 작성글이 없다면 저장,
    if (!documentSnapshot.exists) {
      // await itemDocRef.set(itemModel.toJson());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // 2개중에 하나라도 오류가 발생하면 모두 롤백한다,
        transaction.set(itemDocRef, itemModel.toJson());
        transaction.set(userItemDocRef, itemModel.toMinJson());
      });
    }
  }

  Future<ItemModel2> getItem(String itemKey) async {
    if (itemKey[0] == ':') {
      String orgItemKey = itemKey;
      itemKey = itemKey.substring(1);
      logger.d('[${orgItemKey.substring(0, 10)}...], ==>> [${itemKey.substring(0, 9)}...]');
    }
    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await docRef.get();

    // fromSnapshot 을 대체하려면, 2줄 코딩으로 변경필요함,
    ItemModel2 itemModel = ItemModel2.fromJson(documentSnapshot.data()!);
    itemModel.reference = documentSnapshot.reference;
    itemModel.itemKey = documentSnapshot.id;

    return itemModel;
  }

  Future<List<ItemModel2>> getItems(String userKey) async {
    logger.d('userKey[' + userKey.toString() + ']');
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(COL_ITEMS);
    // collection.get() is Future, collection.snapshots() is Stream
    // 모든 게시글 가져오기
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference.get();
    // 자신의 게시글 제외하고 가져오기
    // QuerySnapshot<Map<String, dynamic>> snapshots =
    //     await collectionReference.where(DOC_USERKEY, isNotEqualTo: userKey).get();

    List<ItemModel2> items = [];

    for (var snapshot in snapshots.docs) {
      //fromQuerySnapshot 대체품 만들것,
      // ItemModel2 itemModel = ItemModel2.fromQuerySnapshot(snapshot);
      ItemModel2 itemModel = ItemModel2.fromJson(snapshot.data());
      itemModel.reference = snapshot.reference;
      itemModel.itemKey = snapshot.id;
      items.add(itemModel);
    }

    return items;
  }

  Future<List<ItemModel2>> getUserItems({required String userKey, String? itemKey}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(COL_USERS).doc(userKey).collection(COL_USER_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference.get();
    List<ItemModel2> items = [];

    for (var snapshot in snapshots.docs) {
      // ItemModel2 itemModel = ItemModel2.fromQuerySnapshot(snapshot);
      ItemModel2 itemModel = ItemModel2.fromJson(snapshot.data());
      itemModel.reference = snapshot.reference;
      itemModel.itemKey = snapshot.id;

      if (itemKey == null || itemModel.itemKey != itemKey) {
        items.add(itemModel);
      }
    }

    // logger.d(items[0].toJson());
    return items;
  }

  Future<List<ItemModel2>> getNearByItems(String userKey, LatLng latLng) async {
    // GeoFlutterFire is an open-source library that allows you to store
    // and query firestore documents based on their geographic location.
    final geo = Geoflutterfire();
    final itemCol = FirebaseFirestore.instance.collection(COL_ITEMS);

    GeoFirePoint center = GeoFirePoint(latLng.latitude, latLng.longitude);
    double radius = 2; // unit is km
    var field = 'geoFirePoint';

    // within - 리턴 타입 Stream, first - 리턴 타입 Future,
    List<DocumentSnapshot<Map<String, dynamic>>> snapshots = await geo
        .collection(collectionRef: itemCol)
        .within(center: center, radius: radius, field: field)
        .first;

    List<ItemModel2> items = [];
    for (var snapshot in snapshots) {
      ItemModel2 itemModel = ItemModel2.fromJson(snapshot.data()!);
      itemModel.itemKey = snapshot.id;
      itemModel.reference = snapshot.reference;
      String imgUrl = itemModel.imageDownloadUrls[0];
      itemModel.iconBytes =
      (await NetworkAssetBundle(Uri.parse(imgUrl)).load(imgUrl)).buffer.asUint8List();
      //todo: remove my own item, 내가 등록한 게시글 제외,
      if (itemModel.userKey != userKey) {
        items.add(itemModel);
      }
    }

    return items;
  }

  //asset 만 적용 가능,
  Future<Uint8List> getBytesFromAsset({required String path,required int width})async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
        format: ui.ImageByteFormat.png))!
        .buffer.asUint8List();
  }

}
