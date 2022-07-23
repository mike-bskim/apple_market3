import 'package:apple_market3/src/models/address_from_location_model.dart';
import 'package:apple_market3/src/models/location_from_address_model.dart';
import 'package:dio/dio.dart';

import '../../../keys.dart';
import '../../utils/logger.dart';


class GoogleMapServices {
  final String sessionToken;

  GoogleMapServices({required this.sessionToken});

// // 검색어 관련 추천 결과를 리턴
//   Future<List> getSuggestions(String query) async {
//     const String baseUrl =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//     String type = 'establishment';
//     String url =
//         '$baseUrl?input=$query&key=$googleApiKey&type=$type&language=ko&components=country:kr&sessiontoken=$sessionToken';
//
//     debugPrint('url: $url');
//     debugPrint('Autocomplete(sessionToken): $sessionToken');
//
//     var response = await Dio().get(url).catchError((e) {
//       logger.e(e.message);
//     });
//     final responseData = json.decode(response.body);
//     final predictions = responseData['predictions'];
//
//     List<Place> suggestions = [];
//
//     for (int i = 0; i < predictions.length; i++) {
//       final place = Place.fromJson(response.data[i]);
//       suggestions.add(place);
//       // debugPrint('${suggestions[i].description}, ${suggestions[i].placeId}');
//       // debugPrint('${place.description}, ${place.placeId}');
//     }
//
//     return suggestions;
//   }
//
// // token 은 sessionToken 값이고, 지명 id 를 전달하여 상세 정보를 리턴
//   Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
//     const String baseUrl =
//         'https://maps.googleapis.com/maps/api/place/details/json';
//     String url =
//         '$baseUrl?key=$googleApiKey&place_id=$placeId&language=ko&sessiontoken=$token';
//
//     debugPrint('Place Detail(sessionToken): $sessionToken');
//     var response = await Dio().get(url).catchError((e) {
//       logger.e(e.message);
//     });
//
//     // final responseData = json.decode(response.data);
//     // final result = responseData['result'];
//
//     final PlaceDetail placeDetail = PlaceDetail.fromJson(response.data);
//     // debugPrint(placeDetail.toMap().toString());
//
//     return placeDetail;
//   }

// 주소정보를 입력해서 위도 경도 정보를 가져온다
  static Future<LocationFromAddress> getLocationFromAddress(String address) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/geocode/json';
    String url =
        '$baseUrl?key=$googleApiKey&address=$address&language=ko';//&sessiontoken=$token';

    // debugPrint('Place Detail(sessionToken): $sessionToken');
    var response = await Dio().get(url).catchError((e) {
      logger.e(e.message);
    });

    final LocationFromAddress locationFromAddress = LocationFromAddress.fromJson(response.data);

    // debugPrint(response.data['results'][0]['formatted_address'].toString());
    // debugPrint(response.data['results'][0]['geometry']['location'].toString());
    // debugPrint(response.data['results'][0]['geometry']['location']['lat'].toString());
    // debugPrint(response.data['results'][0]['geometry']['location']['lng'].toString());
    //
    // debugPrint(locationFromAddress.results.toString());

    return locationFromAddress;
  }

// 위도 경도 정보를 이용해서 주소 정보를 찾는 함수
  static Future<AddressFromLocation> getAddressFromLocation(double lat, double lng) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    String url = '$baseUrl?latlng=$lat,$lng&key=$googleApiKey&language=ko';

    var response = await Dio().get(url).catchError((e) {
      logger.e(e.message);
    });

    final AddressFromLocation addressFromLocation = AddressFromLocation.fromJson(response.data);
    // final formattedAddress = response.data['results'][0]['formatted_address'];
    // final formattedAddress = addressFromLocation.results[0].formattedAddress;

    return addressFromLocation;
  }

// 위도 경도 정보를 이용해서 주소 정보를 찾는 함수
  static Future<List<AddressFromLocation>> getAddressFromLocation5(double lat, double lng) async {
    List<AddressFromLocation> addressFromLocation5 = <AddressFromLocation>[];

    const String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

    for (var i=0; i<5; i++) {
      int x;
      int y;
      if (i == 1) {
        x = 0;
        y = 1;
      }
      else if (i == 2) {
        x = 1;
        y = 0;
      }
      else if (i == 3) {
        x = 0;
        y = -1;
      }
      else if (i == 4) {
        x = -1;
        y = 0;
      }
      else {
        x = 0;
        y = 0;
      }
      String url = '$baseUrl?latlng=${lat+0.01*y},${lng+0.01*x}&key=$googleApiKey&language=ko';
      var response = await Dio().get(url).catchError((e) {
        logger.e(e.message);
      });

      final AddressFromLocation addressFromLocation = AddressFromLocation.fromJson(response.data);
      if(addressFromLocation.status == 'OK'){
        addressFromLocation5.add(addressFromLocation);
      }
    }
    // final formattedAddress = response.data['results'][0]['formatted_address'];
    // final formattedAddress = addressFromLocation.results[0].formattedAddress;

    return addressFromLocation5;
  }

//   static String getStaticMap(double latitude, double longitude) {
//     return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey';
//   }
}
