import 'package:apple_market3/src/models/item_model.dart';
import 'package:apple_market3/src/models/user_model.dart';
import 'package:apple_market3/src/repo/item_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

import '../../constants/data_keys.dart';

/*
toLatLng(Offset position) → LatLng
Converts XY coordinates to LatLng.

toOffset(LatLng location) → Offset
Converts LatLng coordinates to XY Offset.
*/

class MapScreen extends StatefulWidget {
  final UserModel1 _userModel;

  const MapScreen(this._userModel, {Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;

  Offset? _dragStart;
  double _scaleData = 1.0;

  // 터치하는 순간만 실행, 드래그 해도 최초 터치 지점을 표시,
  _scaleStart(ScaleStartDetails details) {
    // focalPoint: Offset(191.2, 426.9), 스크린을 터치한 시작점,
    // localFocalPoint: Offset(191.2, 346.9), pointersCount: 1)
    _dragStart = details.focalPoint;
    _scaleData = 1.0;
    debugPrint('_scaleStart ${_dragStart.toString()} / ${details.toString()}');
  }

  // 드레그 하는 동안 계속 실행됨,
  _scaleUpdate(ScaleUpdateDetails details, MapTransformer transformer) {
    // debugPrint('_scaleUpdate ${details.focalPoint.toString()}');
    var _scaleDiff = details.scale - _scaleData;
    _scaleData = details.scale;
    _mapController.zoom += _scaleDiff;

    if (_scaleDiff > 0) {
      _mapController.zoom += 0.02;
    } else if (_scaleDiff < 0) {
      _mapController.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      transformer.drag(diff.dx, diff.dy);
      // debugPrint('_scaleUpdate/diff ${diff.dx}/${diff.dy}');
    }
    setState(() {});
    // debugPrint('_scaleUpdate ${_mapController.center.latitude}/${_mapController.center.longitude}');
  }

  // 마커 위치/색상 설정, x/y 자표로 입력
  Widget _buildMarkerWidget(Offset offset, {Color color = Colors.red}) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      width: 24,
      height: 24,
      child: Icon(
        Icons.location_on,
        color: color,
      ),
    );
  }

  Widget _buildImgWidget(Offset offset, ItemModel2 itemModel, LatLng centerLatLng) {
    final distance = GeoFirePoint.kmDistanceBetween(
      to: Coordinates(itemModel.geoFirePoint.latitude, itemModel.geoFirePoint.longitude),
      from: Coordinates(centerLatLng.latitude, centerLatLng.longitude),
    );

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      width: 50,
      height: 100,
      child: InkWell(
        onTap: () {
          debugPrint('${itemModel.userKey}, ${itemModel.title}, distance :[$distance]');
          Get.toNamed(ROUTE_ITEM_DETAIL,
              arguments: {'itemKey': itemModel.itemKey},
              // 같은 페이지는 호출시, 중복방지가 기본설정인, false 하면 중복 호출 가능,
              preventDuplicates: false);
          // context.beamToNamed('/$LOCATION_ITEM/:${itemModel.itemKey}');
        },
        child: Column(
          children: [
            ExtendedImage.network(
              width: 32,
              height: 32,
              itemModel.imageDownloadUrls[0],
              shape: BoxShape.circle,
              fit: BoxFit.cover,
            ),
            Text(
              '$distance km',
              style: const TextStyle(color: Colors.black, fontSize: 10.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // ------------------- 테스트 데이터 자동 입력 코드 -------------------
    // generateData(widget._userModel.userKey, widget._userModel.geoFirePoint);

    // 맵컨트롤러의 초기 좌표를 설정
    _mapController = MapController(
      location: LatLng(
        widget._userModel.geoFirePoint.latitude,
        widget._userModel.geoFirePoint.longitude,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _mapController.dispose();
    super.dispose();
  }

  // 버전이 업데이트 되며서 변경된 위젯명, Map -> TileLayer, MapLayoutBuilder -> MapLayout
  @override
  Widget build(BuildContext context) {
    // debugPrint("************************* >>> build from MapScreen");
    return MapLayout(
      builder: (context, transformer) {
        // 위도/경도 정보를 화면상의 위치(x,y 좌표)로 변경, fromLatLngToXYCoords -> toOffset
        var myLatLng = LatLng(
          widget._userModel.geoFirePoint.latitude,
          widget._userModel.geoFirePoint.longitude,
        );

        final Offset myLocationOnMap = transformer.toOffset(myLatLng);

        final myLocationWidget = _buildMarkerWidget(myLocationOnMap);

        Size _size = MediaQuery.of(context).size;
        final middleOnScreen = Offset(_size.width / 2, _size.height / 2);
        // x/y 좌표 체크.
        final List centerLocationWidget = [
          _buildMarkerWidget(middleOnScreen, color: Colors.black87),
          _buildMarkerWidget(const Offset(0, 0), color: Colors.black87),
          _buildMarkerWidget(Offset(_size.width - 20, 0), color: Colors.black87),
          _buildMarkerWidget(Offset(0, _size.height - 160), color: Colors.black87),
          _buildMarkerWidget(Offset(_size.width - 20, _size.height - 160), color: Colors.black87),
        ];

        // toLatLng(Offset position) → LatLng
        // Converts XY coordinates to LatLng.
        // fromXYCoordsToLatLng -> toLatLng
        // 화면의 중간점(x,y 좌표)를 위도/경도 로 변환,
        final middleLatLngOnMap = transformer.toLatLng(middleOnScreen);
        // Screen size : [384.0, 838.4]
        // debugPrint('Screen size : [${_size.width}, ${_size.height}]');
        // debugPrint(
        //     'Screen center : [${latLngOnMap.latitude.toString()}] [${latLngOnMap.longitude.toString()}]');

        return FutureBuilder<List<ItemModel2>>(
            future: ItemService().getNearByItems(widget._userModel.userKey, middleLatLngOnMap),
            builder: (context, snapshot) {
              List<Widget> nearByItems = [];
              if (snapshot.hasData) {
                for (var item in snapshot.data!) {
                  final offset = transformer
                      .toOffset(LatLng(item.geoFirePoint.latitude, item.geoFirePoint.longitude));
                  // nearByItems.add(_buildMarkerWidget(offset));
                  nearByItems.add(_buildImgWidget(offset, item, middleLatLngOnMap));
                }
              }

              return Stack(
                children: [
                  GestureDetector(
                    onScaleStart: _scaleStart,
                    onScaleUpdate: (details) => _scaleUpdate(details, transformer),
                    child: TileLayer(
                      // Map TileLayer
                      builder: (context, x, y, z) {
                        //Google Maps
                        final url =
                            'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                        return ExtendedImage.network(
                          url,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  myLocationWidget,
                  ...centerLocationWidget,
                  ...nearByItems,
                ],
              );
            });
      },
      controller: _mapController,
    );
  }

// ------------------- 테스트 데이터 자동 입력 코드 -------------------

// Future<List<String>> generateData(
//     String userKey, GeoFirePoint geoFirePoint) async {
//   List<String> itemKeys = [];
//
//   DateTime now = DateTime.now().toUtc();
//   const numOfItem = 15;
//   await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
//     for (int i = 0; i < numOfItem; i++) {
//       final String itemKey = ItemModel2.generateItemKey(userKey);
//       logger.d('RandomeData - $itemKey');
//       itemKeys.add(itemKey);
//       final DocumentReference postRef =
//       FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
//
//       final DocumentReference userItemDocReference = FirebaseFirestore
//           .instance
//           .collection(COL_USERS)
//           .doc(userKey)
//           .collection(COL_USER_ITEMS)
//           .doc(itemKey);
//
//       var rng = Random();
//       GeoPoint geoPoint = geoFirePoint.data['geopoint'];
//       final newGeoData = GeoFirePoint(
//           geoPoint.latitude + (0.001 * (rng.nextInt(100) - 50)),
//           geoPoint.longitude + (0.001 * (rng.nextInt(100) - 50)));
//
//       ItemModel2 item = ItemModel2(
//         userKey: userKey,
//         itemKey: itemKey,
//         userPhone: widget._userModel.phoneNumber, //'+821040155592',
//         imageDownloadUrls: ['https://picsum.photos/200'],
//         title: 'second + ${i+1}',
//         category: categoriesMapEngToKor.keys
//             .elementAt(i % categoriesMapEngToKor.keys.length),
//         price: 100 * i,
//         negotiable: i % 2 == 0,
//         detail: 'second detail + ${i+1}',
//         address: 'second address + ${i+1}',
//         geoFirePoint: newGeoData,
//         createdDate: now.subtract(Duration(days: i)),
//       );
//
//       tx.set(postRef, item.toJson());
//       tx.set(userItemDocReference, item.toMinJson());
//     }
//   });
//   return itemKeys;
// }
//
// final List<String> nouns = [
//   'time',
//   'year',
//   'people',
//   'way',
//   'day',
//   'man',
//   'thing',
//   'woman',
//   'life',
//   'child',
//   'world',
//   'school',
//   'state',
//   'family',
//   'student',
//   'group',
//   'country',
//   'problem',
//   'hand',
//   'part',
//   'place',
//   'case',
//   'week',
//   'company',
//   'system',
//   'program',
//   'question',
//   'work',
//   'government',
//   'number',
//   'night',
//   'point',
//   'home',
//   'water',
//   'room',
//   'mother',
//   'area',
//   'money',
//   'story',
//   'fact',
//   'month',
//   'lot',
//   'right',
//   'study',
//   'book',
//   'eye',
//   'job',
//   'word',
//   'business'
// ];

// ------------------- 테스트 데이터 자동 입력 코드 -------------------

}
