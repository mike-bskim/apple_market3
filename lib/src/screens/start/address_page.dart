import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import '../../constants/common_size.dart';
import '../../constants/shared_pref_key.dart';
import '../../models/address_from_location_model.dart';
import '../../models/address_model.dart';
import '../../models/location_from_address_model.dart';
import '../../utils/logger.dart';
import 'address_service.dart';
import 'google_map_service.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController _addressController = TextEditingController();
  var uuid = const Uuid(); // sessionToken 에 할당할 예정
  late String sessionToken;
  var googleMapServices = GoogleMapServices(sessionToken: const Uuid().v4());

  // 더미 객체 생성로 생성하지 않고 nullable 로 처리
  Position? position;

  // 국내 임의의 위도/경도 정보를 할당
  Position fakePosition = Position(
      latitude: 37.5377469,
      longitude: 126.9643189,
      timestamp: DateTime.now(),
      accuracy: 20.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  // reverse geocoding, 좌표에 주소로 변경시 사용하는 모델
  // AddressFromLocation? myAddress;
  // geocoding, 좌표에 주소로 변경시 사용하는 모델
  LocationFromAddress? myLocation;

  // reverse geocoding, 좌표에 주소로 변경시 사용하는 모델, 리스트 타입
  final List<AddressFromLocation> _addressModelXYList = [];

  // 도로명 주소 모델, 내부 배열에 해당 주소들 포함됨
  AddressModel? _addressModel;

  // 현재위치 찾기 로딩중인지 확인 flag
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    sessionToken = uuid.v4();
    _checkGPSAvailability();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _checkGPSAvailability() async {
// gps 사용 허가 확인
    LocationPermission geolocationStatus = await Geolocator.checkPermission();
    // debugPrint('geolocationStatus: [$geolocationStatus]');

    // GeolocationStatus.granted
    if (geolocationStatus == LocationPermission.denied ||
        geolocationStatus == LocationPermission.deniedForever) {
      showDialog(
        // 다이얼로그 밖 영역 클릭시 사라지지 않게 처리
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('GPS 사용 불가'),
            content: const Text('GPS 사용 불가로 앱을 사용할 수 없습니다'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ).then((_) => Navigator.pop(context));
    } else {
      // 디바이스의 현재 GPS 위치 리턴, 현재는 가짜 위치를 사용중
      await _getGPSLocation();
    }
  }

// 디바이스의 현재 GPS 위치 리턴, 현재는 가짜 위치를 사용중
  Future<void> _getGPSLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // fake GPS, 현재는 가짜 위치를 사용중
    position = fakePosition;
    logger.d('myPosition(_getGPSLocation) : $position');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(">>> build from AddressPage");

    return SafeArea(
      // padding 대신에 minimum 으로 설정 가능, 위/아래 글씨가 잘리는것도 방지하자
      minimum: const EdgeInsets.symmetric(horizontal: padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
//도로명 검색하기
          TextFormField(
            controller: _addressController,
            // 키보드의 엔터키를 터치하면 실행, 입력된 단어를 포함한 주소를 리턴
            onFieldSubmitted: onClickTextField,
            decoration: InputDecoration(
              // icon 으로도 가능하지만 여기서는 prefixIcon 으로 설정함
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              // 아이콘 주변 공간을 조절 가능
              prefixIconConstraints: const BoxConstraints(minWidth: 24, maxHeight: 24),
              // 문자 입력 박스의 아웃라인 설정
              border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              // focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              hintText: '도로명으로 검색...',
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(height: padding_08),
// 현재 위치 찾기
          TextButton.icon(
            label: Text(
              // 로딩중일때는 다른 문자를 표시함
              _isGettingLocation ? '위치 찾는중 ~~' : '현재위치 찾기',
              style: Theme.of(context).textTheme.button,
            ),
            // 디바이스의 GPS 좌표에 해당 하는 주소와 주변 주소를 리트스 형식으로 리턴
            onPressed: myAddresses, //myLocation,
            // 로딩중일때는 다른 아이콘을 표시함
            icon: _isGettingLocation
                ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                : const Icon(CupertinoIcons.compass, color: Colors.white, size: 20),
          ),
//도로명 검색 결과 표시,
          if (_addressModel != null)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: padding_16),
                itemCount: (_addressModel == null) ? 0 : _addressModel!.results.juso.length,
                itemBuilder: (context, index) {
                  if (_addressModel == null) {
                    return Container();
                  }
                  // 동정보, 지번 정보 추출하기 위함
                  var subAddress = _addressModel!.results.juso[index].jibunAddr.split(' ');
                  return ListTile(
                    onTap: () async {
                      // 주소를 좌표로 변환하는 함수
                      myLocation = await GoogleMapServices.getLocationFromAddress(
                          _addressModel!.results.juso[index].roadAddrPart1);
                      debugPrint(myLocation!.results[0].formattedAddress);
                      debugPrint(myLocation!.results[0].geometry.location.toString());
                      _saveAddressAndGoToNextPage(
                        _addressModel!.results.juso[index].roadAddrPart1,
                        myLocation!.results[0].geometry.location.lat,
                        myLocation!.results[0].geometry.location.lng,
                      );
                    },
                    title: Text(_addressModel!.results.juso[index].roadAddrPart1),
                    subtitle: Text('${subAddress[2]} ${subAddress[3]}'),
                  );
                },
              ),
            ),
          // if (_addressModel != null)
          //   Expanded(
          //     child: ListView.builder(
          //       padding: const EdgeInsets.symmetric(vertical: padding_16),
          //       // shrinkWrap: true,
          //       itemCount: (_addressModel == null ||
          //           _addressModel!.result == null ||
          //           _addressModel!.result!.items == null)
          //           ? 0
          //           : _addressModel!.result!.items!.length,
          //       itemBuilder: (context, index) {
          //         if (_addressModel == null ||
          //             _addressModel!.result == null ||
          //             _addressModel!.result!.items == null ||
          //             _addressModel!.result!.items![index].address == null ||
          //             _addressModel!.result!.items![index].address!.parcel == null) {
          //           return Container();
          //         }
          //         return ListTile(
          //           onTap: () {
          //             _saveAddressAndGoToNextPage(
          //               _addressModel!.result!.items![index].address!.road ?? '',
          //               num.parse(_addressModel!.result!.items![index].point!.y ?? '0'),
          //               num.parse(_addressModel!.result!.items![index].point!.x ?? '0'),
          //             );
          //           },
          //           leading: ExtendedImage.asset('assets/imgs/apple.png'),
          //           title: Text(_addressModel!.result!.items![index].address!.road ?? ''),
          //           subtitle: Text(_addressModel!.result!.items![index].address!.parcel ?? ''),
          //         );
          //       },
          //     ),
          //   ),
//현재위치 검색 결과 표시
          if (_addressModelXYList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: padding_16),
                // shrinkWrap: true,
                itemCount: _addressModelXYList.length,
                itemBuilder: (context, index) {
                  if (_addressModelXYList[index].results.isEmpty) {
                    //_addressModelXYList[index].results == null ||
                    return Container();
                  }
                  var zipcode = _addressModelXYList[index].results[0].addressComponents.length;
                  var shortAddress = _addressModelXYList[index]
                      .results[0]
                      .formattedAddress
                      .replaceFirst('대한민국 ', '');
                  return ListTile(
                    onTap: () {
                      debugPrint(_addressModelXYList[index].results[0].formattedAddress);
                      debugPrint(
                          _addressModelXYList[index].results[0].geometry.location.toString());
                      _saveAddressAndGoToNextPage(
                        _addressModelXYList[index].results[0].formattedAddress,
                        _addressModelXYList[index].results[0].geometry.location.lat,
                        _addressModelXYList[index].results[0].geometry.location.lng,
                      );

                      // _saveAddressAndGoToNextPage(_addressModelXYList[index].result![0].text ?? '',
                      //   num.parse(_addressModelXYList[index].input!.point!.y ?? '0') ,
                      //   num.parse(_addressModelXYList[index].input!.point!.x ?? '0') ,);
                    },
                    // leading: ExtendedImage.asset('assets/imgs/apple.png'),
                    title: Text(shortAddress),
                    subtitle: Text(_addressModelXYList[index]
                        .results[0]
                        .addressComponents[zipcode - 1]
                        .longName),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

// 디바이스의 GPS 좌표에 해당 하는 주소와 주변 주소를 리트스 형식으로 리턴
  void myAddresses() async {
    _addressModel = null;
    _addressModelXYList.clear();
    _addressController.text = '';

    setState(() {
      _isGettingLocation = true;
    });

    // myAddress = await GoogleMapServices.getAddressFromLocation(
    //     position!.latitude, position!.longitude);
    List<AddressFromLocation> addressModelXY =
        await GoogleMapServices.getAddressFromLocation5(position!.latitude, position!.longitude);
    _addressModelXYList.addAll(addressModelXY);

    // debugPrint(myAddress!.results[0].formattedAddress.toString());
    // debugPrint('$position');
    setState(() {
      _isGettingLocation = false;
    });
  }

  _saveAddressAndGoToNextPage(String address, num lat, num lon) async {
    await _saveAddressOnSharedPreference(address, lat, lon);
    // "flutter do not use build contexts across async gaps"
    // 상기 경고가 나와서 mounted 조건을 추가함
    if (!mounted) return;
    context.read<PageController>().animateToPage(2,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  _saveAddressOnSharedPreference(String address, num lat, num lon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('save Address: $address.');
    await prefs.setString(SHARED_ADDRESS, address);
    await prefs.setDouble(SHARED_LAT, lat.toDouble());
    await prefs.setDouble(SHARED_LON, lon.toDouble());
  }

  void onClickTextField(text) async {
    _addressModelXYList.clear();
    _addressModel = await AddressService().searchAddressByStr(text);
    setState(() {});
  }

// void onClickSearchAddress() async {
//   final text = _addressController.text;
//   logger.d('text:$text');
//   // if (text.isNotEmpty) {
//   //   FocusScope.of(context).unfocus();
//   //   _addressModel = await AddressService().searchAddressByStr(text);
//   //   setState(() {});
//   // }
//   logger.d('address_page >> on Text Button Clicked !!!');
// }

// void myLocation() async {
//   _addressModel = null;
//   _addressModelXYList.clear();
//
//   setState(() {
//     _isGettingLocation = true;
//   });
//   Location location = Location();
//
//   bool _serviceEnabled;
//   PermissionStatus _permissionGranted;
//   LocationData _locationData;
//
//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {
//       return;
//     }
//   }
//
//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {
//       return;
//     }
//   }
//
//   _locationData = await location.getLocation();
//   logger.d('_locationData: ${_locationData.toString()}');
//   List<AddressModelXY> _addressModelXY = await AddressService().findAddressByCoordinate(
//     // log: _locationData.longitude!, lat: _locationData.latitude!);
//       log: 126.978275264,
//       lat: 37.566642192);
//   _addressModelXYList.addAll(_addressModelXY);
//
//   setState(() {
//     _isGettingLocation = false;
//   });
// }
}
