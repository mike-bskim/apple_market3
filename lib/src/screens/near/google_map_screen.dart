import 'dart:async';
import 'dart:typed_data';

import 'package:apple_market3/src/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../keys.dart';
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
  final Completer<GoogleMapController> _controller = Completer();
  MapType _googleMapType = MapType.normal;
  int _mapType = 0;
  final Set<Marker> _markers = {};
  late final CameraPosition _initialCameraPosition;
  late final userMarker;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(
        widget._userModel.geoFirePoint.latitude,
        widget._userModel.geoFirePoint.longitude,
      ),
      zoom: 14,
    );
    userMarker = Marker(
      markerId: const MarkerId('myInitPosition'),
      position: LatLng(
        widget._userModel.geoFirePoint.latitude,
        widget._userModel.geoFirePoint.longitude,
      ),
      infoWindow: const InfoWindow(title: 'My Position', snippet: 'Where am I?'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    _markers.add(userMarker);
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
          // Get.toNamed(
          //     ROUTE_ITEM_DETAIL,
          //     arguments: {'itemKey': itemModel.itemKey},
          //     // 같은 페이지는 호출시, 중복방지가 기본설정인, false 하면 중복 호출 가능,
          //     preventDuplicates: false
          // );
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

  void _onMapCreated(GoogleMapController controller) {
    // 이제 이 콘트롤을 프로그램애서 사용하기 위한 준비 완료.
    _controller.complete(controller);
  }

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
    var myLatLng = LatLng(
      widget._userModel.geoFirePoint.latitude,
      widget._userModel.geoFirePoint.longitude,
    );

    return Scaffold(
      body: FutureBuilder<List<ItemModel2>>(
          future: ItemService().getNearByItems(widget._userModel.userKey, myLatLng),
          builder: (context, snapshot) {
            List<Widget> nearByItems = [];
            _markers.clear();
            _markers.add(userMarker);
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
                    // icon: BitmapDescriptor.fromBytes(item.iconBytes!,
                    //     size: const Size(16.0, 16.0)), //Icon for Marker
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
                        heroTag: 'btn1',
                        label: Text('$_googleMapType'),
                        icon: const Icon(Icons.map),
                        elevation: 8,
                        backgroundColor: Colors.red[400],
                        onPressed: _changeMapType,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
