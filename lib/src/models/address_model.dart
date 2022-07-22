// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

AddressModel addressFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  Results results;

  AddressModel({
    required this.results,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        results: Results.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "results": results.toJson(),
      };
}

class Results {
  Common common;
  List<Juso> juso;

  Results({
    required this.common,
    required this.juso,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        common: Common.fromJson(json["common"]),
        juso: List<Juso>.from(json["juso"].map((x) => Juso.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "common": common.toJson(),
        "juso": List<dynamic>.from(juso.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Results{common: $common, juso: $juso}';
  }
}

class Common {
  String totalCount;
  String currentPage;
  String countPerPage;
  String errorCode;
  String errorMessage;

  Common({
    required this.totalCount,
    required this.currentPage,
    required this.countPerPage,
    required this.errorCode,
    required this.errorMessage,
  });

  factory Common.fromJson(Map<String, dynamic> json) => Common(
        totalCount: json["totalCount"] ?? '',
        currentPage: json["currentPage"] ?? '',
        countPerPage: json["countPerPage"] ?? '',
        errorCode: json["errorCode"] ?? '',
        errorMessage: json["errorMessage"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "currentPage": currentPage,
        "countPerPage": countPerPage,
        "errorCode": errorCode,
        "errorMessage": errorMessage,
      };

  @override
  String toString() {
    return 'Common{totalCount: $totalCount, currentPage: $currentPage, countPerPage: $countPerPage, errorCode: $errorCode, errorMessage: $errorMessage}';
  }
}

class Juso {
  String roadAddr;
  String roadAddrPart1;
  String roadAddrPart2;
  String jibunAddr;
  String engAddr;
  String zipNo;
  String admCd;
  String rnMgtSn;
  String bdMgtSn;
  String detBdNmList;
  String bdNm;
  String bdKdcd;
  String siNm;
  String sggNm;
  String emdNm;
  String liNm;
  String rn;
  String udrtYn;
  String buldMnnm;
  String buldSlno;
  String mtYn;
  String lnbrMnnm;
  String lnbrSlno;
  String emdNo;
  String hstryYn;
  String relJibun;
  String hemdNm;

  Juso({
    required this.roadAddr,
    required this.roadAddrPart1,
    required this.roadAddrPart2,
    required this.jibunAddr,
    required this.engAddr,
    required this.zipNo,
    required this.admCd,
    required this.rnMgtSn,
    required this.bdMgtSn,
    required this.detBdNmList,
    required this.bdNm,
    required this.bdKdcd,
    required this.siNm,
    required this.sggNm,
    required this.emdNm,
    required this.liNm,
    required this.rn,
    required this.udrtYn,
    required this.buldMnnm,
    required this.buldSlno,
    required this.mtYn,
    required this.lnbrMnnm,
    required this.lnbrSlno,
    required this.emdNo,
    required this.hstryYn,
    required this.relJibun,
    required this.hemdNm,
  });

  factory Juso.fromJson(Map<String, dynamic> json) => Juso(
        roadAddr: json["roadAddr"] ?? '',
        roadAddrPart1: json["roadAddrPart1"] ?? '',
        roadAddrPart2: json["roadAddrPart2"] ?? '',
        jibunAddr: json["jibunAddr"] ?? '',
        engAddr: json["engAddr"] ?? '',
        zipNo: json["zipNo"] ?? '',
        admCd: json["admCd"] ?? '',
        rnMgtSn: json["rnMgtSn"] ?? '',
        bdMgtSn: json["bdMgtSn"] ?? '',
        detBdNmList: json["detBdNmList"] ?? '',
        bdNm: json["bdNm"] ?? '',
        bdKdcd: json["bdKdcd"] ?? '',
        siNm: json["siNm"] ?? '',
        sggNm: json["sggNm"] ?? '',
        emdNm: json["emdNm"] ?? '',
        liNm: json["liNm"] ?? '',
        rn: json["rn"] ?? '',
        udrtYn: json["udrtYn"] ?? '',
        buldMnnm: json["buldMnnm"] ?? '',
        buldSlno: json["buldSlno"] ?? '',
        mtYn: json["mtYn"] ?? '',
        lnbrMnnm: json["lnbrMnnm"] ?? '',
        lnbrSlno: json["lnbrSlno"] ?? '',
        emdNo: json["emdNo"] ?? '',
        hstryYn: json["hstryYn"] ?? '',
        relJibun: json["relJibun"] ?? '',
        hemdNm: json["hemdNm"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "roadAddr": roadAddr,
        "roadAddrPart1": roadAddrPart1,
        "roadAddrPart2": roadAddrPart2,
        "jibunAddr": jibunAddr,
        "engAddr": engAddr,
        "zipNo": zipNo,
        "admCd": admCd,
        "rnMgtSn": rnMgtSn,
        "bdMgtSn": bdMgtSn,
        "detBdNmList": detBdNmList,
        "bdNm": bdNm,
        "bdKdcd": bdKdcd,
        "siNm": siNm,
        "sggNm": sggNm,
        "emdNm": emdNm,
        "liNm": liNm,
        "rn": rn,
        "udrtYn": udrtYn,
        "buldMnnm": buldMnnm,
        "buldSlno": buldSlno,
        "mtYn": mtYn,
        "lnbrMnnm": lnbrMnnm,
        "lnbrSlno": lnbrSlno,
        "emdNo": emdNo,
        "hstryYn": hstryYn,
        "relJibun": relJibun,
        "hemdNm": hemdNm,
      };

  @override
  String toString() {
    return 'Juso{roadAddr: $roadAddr, roadAddrPart1: $roadAddrPart1, roadAddrPart2: $roadAddrPart2, jibunAddr: $jibunAddr, engAddr: $engAddr, zipNo: $zipNo, admCd: $admCd, rnMgtSn: $rnMgtSn, bdMgtSn: $bdMgtSn, detBdNmList: $detBdNmList, bdNm: $bdNm, bdKdcd: $bdKdcd, siNm: $siNm, sggNm: $sggNm, emdNm: $emdNm, liNm: $liNm, rn: $rn, udrtYn: $udrtYn, buldMnnm: $buldMnnm, buldSlno: $buldSlno, mtYn: $mtYn, lnbrMnnm: $lnbrMnnm, lnbrSlno: $lnbrSlno, emdNo: $emdNo, hstryYn: $hstryYn, relJibun: $relJibun, hemdNm: $hemdNm}';
  }

}
/*
{
  "results": {
    "common": {
      "totalCount": "62",
      "currentPage": "1",
      "countPerPage": "2",
      "errorCode": "0",
      "errorMessage": "정상"
    },
  "juso":[
      {
      "roadAddr": "서울특별시 용산구 원효로71길 6(원효로2가)",
      "roadAddrPart1": "서울특별시 용산구 원효로71길 6",
      "roadAddrPart2": "(원효로2가)",
      "jibunAddr": "서울특별시 용산구 원효로2가 1-25",
      "engAddr": "6 Wonhyo-ro 71-gil, Yongsan-gu, Seoul",
      "zipNo": "04364",
      "admCd": "1117011300",
      "rnMgtSn": "111704106256",
      "bdMgtSn": "1117011300100010025019119",
      "detBdNmList": "",
      "bdNm": "",
      "bdKdcd": "0",
      "siNm": "서울특별시",
      "sggNm": "용산구",
      "emdNm": "원효로2가",
      "liNm": "",
      "rn": "원효로71길",
      "udrtYn": "0",
      "buldMnnm": "6",
      "buldSlno": "0",
      "mtYn": "0",
      "lnbrMnnm": "1",
      "lnbrSlno": "25",
      "emdNo": "01",
      "hstryYn": "0",
      "relJibun": "",
      "hemdNm": "서울특별시 용산구 원효로제1동"
      },
      {
      "roadAddr": "서울특별시 용산구 원효로71길 7(원효로2가)",
      "roadAddrPart1": "서울특별시 용산구 원효로71길 7",
      "roadAddrPart2": "(원효로2가)",
      "jibunAddr": "서울특별시 용산구 원효로2가 8-15",
      "engAddr": "7 Wonhyo-ro 71-gil, Yongsan-gu, Seoul",
      "zipNo": "04364",
      "admCd": "1117011300",
      "rnMgtSn": "111704106256",
      "bdMgtSn": "1117011300100080015019071",
      "detBdNmList": "",
      "bdNm": "",
      "bdKdcd": "0",
      "siNm": "서울특별시",
      "sggNm": "용산구",
      "emdNm": "원효로2가",
      "liNm": "",
      "rn": "원효로71길",
      "udrtYn": "0",
      "buldMnnm": "7",
      "buldSlno": "0",
      "mtYn": "0",
      "lnbrMnnm": "8",
      "lnbrSlno": "15",
      "emdNo": "01",
      "hstryYn": "0",
      "relJibun": "",
      "hemdNm": "서울특별시 용산구 원효로제1동"
      }
    ]
  }
}
*/