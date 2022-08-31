import 'dart:async';

import 'package:apple_market3/src/models/user_model.dart';
import 'package:flutter/material.dart';

// LatLng 함수가 google_maps_flutter 와 충돌되어 별칭 추가. 변경 이유는 실사용 부분 참고,
import 'package:latlng/latlng.dart' as map_lat_lng;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/data_keys.dart';
import '../../models/item_model.dart';
import '../../repo/item_service.dart';
import '../../utils/logger.dart';

class GoogleMapScreen extends StatefulWidget {
  final UserModel1 _userModel;

  const GoogleMapScreen(this._userModel, {Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  MapType _googleMapType = MapType.normal;
  int _mapType = 0;
  final Set<Marker> _markers = {};
  late final CameraPosition _initialCameraPosition;
  Marker? userMarker;

  @override
  void initState() {
    // 초기 맵 위치 설정
    _initialCameraPosition = CameraPosition(
      target: LatLng(
        widget._userModel.geoFirePoint.latitude,
        widget._userModel.geoFirePoint.longitude,
      ),
      zoom: 14,
    );

    userMarker = setMarker(
      latLng: LatLng(
        widget._userModel.geoFirePoint.latitude,
        widget._userModel.geoFirePoint.longitude,
      ),
      color: BitmapDescriptor.hueBlue,
    );
    _markers.add(userMarker!);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Marker setMarker({required LatLng latLng, required double color}) {
    return Marker(
      markerId: const MarkerId('myInitPosition'),
      position: latLng,
      infoWindow: const InfoWindow(title: 'My Position', snippet: 'Where am I?'),
      icon: BitmapDescriptor.defaultMarkerWithHue(color),
    );
  }

  // 마커 위치/색상 설정, x/y 자표로 입력
  Widget _buildMarkerWidget(Offset offset, {Color color = Colors.red}) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      width: 32,
      height: 32,
      child: Icon(
        Icons.location_on,
        color: color,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    // 이제 이 콘트롤을 프로그램애서 사용하기 위한 준비 완료.
    _googleMapController.complete(controller);
  }

  // 지도 타입 설정,
  void _changeMapType() {
    setState(() {
      _mapType++;
      _mapType = _mapType % 4;

      switch (_mapType) {
        case 0:
          _googleMapType = MapType.normal;
          break;
        case 1:
          _googleMapType = MapType.satellite;
          break;
        case 2:
          _googleMapType = MapType.terrain;
          break;
        case 3:
          _googleMapType = MapType.hybrid;
          break;
        default:
          _googleMapType = MapType.normal;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 여기서 mapLatLng 별칭 처리한 이유는 getNearByItemsGoogle 함수에서 사용하는 LatLng 버전이 달라서임,
    // 해당 LatLng 타입은 google_maps_flutter.dart 것이 아니고 latlng.dart 것을 참고하기때문입니다,
    var myLatLng = map_lat_lng.LatLng(
      widget._userModel.geoFirePoint.latitude,
      widget._userModel.geoFirePoint.longitude,
    );

    // 화면 중심을 표시하려하는데, 자꾸 아랫쪽으로 치우친다.
    Size _size = MediaQuery.of(context).size;
    final middleOnScreen = Offset(_size.width / 2, _size.height / 2);
    // logger.d('middleOnScreen: $middleOnScreen');

    return Scaffold(
      body: FutureBuilder<List<ItemModel2>>(
        future: ItemService().getNearByItemsGoogle(widget._userModel.userKey, myLatLng),
        builder: (context, snapshot) {
          _markers.clear();
          // 로그인 사용자 위치를 화면에 추가합니다.
          _markers.add(userMarker!);
          // _markers.add(setMarker(latLng: _currentCenter, color: BitmapDescriptor.hueOrange));

          if (snapshot.hasData) {
            for (var item in snapshot.data!) {
              // final offset = transformer
              //     .toOffset(LatLng(item.geoFirePoint.latitude, item.geoFirePoint.longitude));
              // nearByItems.add(_buildImgWidget(offset, item, myLatLng));
              _markers.add(
                Marker(
                  // markerId: MarkerId(foundPlaces[i]['id']),
                  markerId: MarkerId(item.itemKey),
                  position: LatLng(
                    item.geoFirePoint.latitude,
                    item.geoFirePoint.longitude,
                  ),
                  infoWindow: InfoWindow(
                    title: item.title,
                    snippet: 'test',
                  ),
                  icon: BitmapDescriptor.fromBytes(item.iconBytes!),
                  //Icon for Marker
                  onTap: () {
                    logger.d('Marker clicked:[${item.title}]');
                    Get.toNamed('/$ROUTE_ITEM_DETAIL',
                        arguments: {'itemKey': item.itemKey},
                        // 같은 페이지는 호출시, 중복방지가 기본설정인, false 하면 중복 호출 가능,
                        preventDuplicates: false);
                  },
                ),
              );
            }
          }

          return Stack(
            children: <Widget>[
              GoogleMap(
                mapType: _googleMapType,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                markers: _markers,
              ),
              Container(
                margin: const EdgeInsets.only(top: 60, right: 10),
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: 'btn_googleMap',
                      label: Text('$_googleMapType'),
                      icon: const Icon(Icons.map),
                      elevation: 8,
                      backgroundColor: Colors.red[400],
                      onPressed: _changeMapType,
                    ),
                  ],
                ),
              ),
              _buildMarkerWidget(middleOnScreen),
            ],
          );
        },
      ),
    );
  }
}
