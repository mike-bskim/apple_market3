import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

import '../../../keys.dart';
import '../../models/address_model.dart';
import '../../utils/logger.dart';

class AddressService {

  // string -> json(이부분은 fltter에서 자동처리함) -> object
  Future<AddressModel> searchAddressByStr(String text) async {
    // final formData = {
    //   'key': vWorldKey,
    //   'request': 'search',
    //   'type': 'ADDRESS',
    //   'category': 'ROAD',
    //   'query': text,
    //   'size': 30,
    // };
    final formData = {
      'confmKey': jusoKey,
      'currentPage': '1',
      'countPerPage': '100',
      'keyword': text,
      'resultType': 'json',
    };

    var resp = await Dio()
        // .get('http://api.vworld.kr/req/search', queryParameters: formData)
        .get('http://www.juso.go.kr/addrlink/addrLinkApi.do',
            queryParameters: formData)
        .catchError((e) {
      logger.e(e.message);
    });

    AddressModel addressModel = AddressModel.fromJson(resp.data);

    // debugPrint(addressModel.results.common.toString());
    // debugPrint(addressModel.results.juso[0].toString());
    // logger.d(resp.data is Map);

    return addressModel;
  }

// // string -> json(이부분은 fltter에서 자동처리함) -> object, log=x, lat=y

// Future<List<AddressModelXY>> findAddressByCoordinate({required double log, required double lat}) async {
//
//   List<Map<String, dynamic>> formData = <Map<String, dynamic>>[];
//
//   for (var i=0; i<5; i++) {
//     int x;
//     int y;
//     if (i==1){x = 0; y=1;}
//     else if (i==2){x = 1; y=0;}
//     else if (i==3){x = 0; y=-1;}
//     else if (i==4){x = -1; y=0;}
//     else {x = 0; y=0;}
//
//     formData.add({
//       'key':vWorldKey,
//       'service':'address',
//       'request':'getAddress',
//       'type':'PARCEL', /// 'BOTH'
//       'point':'${log+0.01*x},${lat+0.01*y}',
//     });
//   }
//
//   List<AddressModelXY> addressModelXYs = [];
//
//   for(var data in formData) {
//     var resp = await Dio().get('http://api.vworld.kr/req/address', queryParameters: data)
//         .catchError((e){
//       logger.e(e.message);
//     });
//     // logger.d('resp[response]: ${resp.data['response']}');
//     // logger.d('resp[status]: ${resp.data['response']['status']}');
//
//     AddressModelXY addressModelXY = AddressModelXY.fromJson(resp.data['response']);
//     if(resp.data['response']['status'] == 'OK'){
//       addressModelXYs.add(addressModelXY);
//     }
//   }
//   logger.d('길이: ${addressModelXYs.length}');
//
//   return addressModelXYs;
// }
}
