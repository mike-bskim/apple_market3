// To parse this JSON data, do
//
//     final addressFromLocation = addressFromLocationFromJson(jsonString);

import 'dart:convert';

AddressFromLocation addressFromLocationFromJson(String str) =>
    AddressFromLocation.fromJson(json.decode(str));

String addressFromLocationToJson(AddressFromLocation data) =>
    json.encode(data.toJson());

class AddressFromLocation {
  PlusCode plusCode;
  List<Result> results;
  String status;

  AddressFromLocation({
    required this.plusCode,
    required this.results,
    required this.status,
  });

  factory AddressFromLocation.fromJson(Map<String, dynamic> json) =>
      AddressFromLocation(
        plusCode: PlusCode.fromJson(json["plus_code"]),
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "plus_code": plusCode.toJson(),
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
      };

  @override
  String toString() {
    return 'AddressFromLocation{plusCode: $plusCode, results: $results, status: $status}';
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({
    this.compoundCode = '',
    this.globalCode = '',
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"] ?? '',
        globalCode: json["global_code"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };

  @override
  String toString() {
    return 'PlusCode{compoundCode: $compoundCode, globalCode: $globalCode}';
  }
}

class Result {
  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  String placeId;
  PlusCode? plusCode;
  List<String> types;

  Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    this.plusCode,
    required this.types,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"] ?? '',
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"] ?? '',
        plusCode: json["plus_code"] != null
            ? PlusCode.fromJson(json["plus_code"])
            : null,
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components":
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "place_id": placeId,
        "plus_code": plusCode?.toJson(),
        "types": List<dynamic>.from(types.map((x) => x)),
      };

  @override
  String toString() {
    return 'Result{addressComponents: $addressComponents, formattedAddress: $formattedAddress, geometry: $geometry, placeId: $placeId, plusCode: $plusCode, types: $types}';
  }
}

class AddressComponent {
  String longName;
  String shortName;
  List<String> types;

  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"] ?? '',
        shortName: json["short_name"] ?? '',
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types.map((x) => x)),
      };

  @override
  String toString() {
    return 'AddressComponent{longName: $longName, shortName: $shortName, types: $types}';
  }
}

class Geometry {
  Location location;
  String locationType;
  Viewport viewport;

  Geometry({
    required this.location,
    required this.locationType,
    required this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        locationType: json["location_type"] ?? '',
        viewport: Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "location_type": locationType,
        "viewport": viewport.toJson(),
      };

  @override
  String toString() {
    return 'Geometry{location: $location, locationType: $locationType, viewport: $viewport}';
  }
}

class Location {
  double lat;
  double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble() ?? 0.0,
        lng: json["lng"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };

  @override
  String toString() {
    return 'Location{lat: $lat, lng: $lng}';
  }
}

class Viewport {
  Location northeast;
  Location southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };

  @override
  String toString() {
    return 'Viewport{northeast: $northeast, southwest: $southwest}';
  }
}

/*
{
    "plus_code": {
        "compound_code": "CWC8+X8 Mountain View, CA",
        "global_code": "849VCWC8+X8"
    },
    "results": [
        {
            "address_components": [
                {
                    "long_name": "1600",
                    "short_name": "1600",
                    "types": [
                        "street_number"
                    ]
                },
                {
                    "long_name": "Amphitheatre Parkway",
                    "short_name": "Amphitheatre Pkwy",
                    "types": [
                        "route"
                    ]
                },
                {
                    "long_name": "Mountain View",
                    "short_name": "Mountain View",
                    "types": [
                        "locality",
                        "political"
                    ]
                },
                {
                    "long_name": "Santa Clara County",
                    "short_name": "Santa Clara County",
                    "types": [
                        "administrative_area_level_2",
                        "political"
                    ]
                },
                {
                    "long_name": "California",
                    "short_name": "CA",
                    "types": [
                        "administrative_area_level_1",
                        "political"
                    ]
                },
                {
                    "long_name": "United States",
                    "short_name": "US",
                    "types": [
                        "country",
                        "political"
                    ]
                },
                {
                    "long_name": "94043",
                    "short_name": "94043",
                    "types": [
                        "postal_code"
                    ]
                }
            ],
            "formatted_address": "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",
            "geometry": {
                "location": {
                    "lat": 37.4224428,
                    "lng": -122.0842467
                },
                "location_type": "ROOFTOP",
                "viewport": {
                    "northeast": {
                        "lat": 37.4239627802915,
                        "lng": -122.0829089197085
                    },
                    "southwest": {
                        "lat": 37.4212648197085,
                        "lng": -122.0856068802915
                    }
                }
            },
            "place_id": "ChIJeRpOeF67j4AR9ydy_PIzPuM",
            "plus_code": {
                "compound_code": "CWC8+X8 Mountain View, CA",
                "global_code": "849VCWC8+X8"
            },
            "types": [
                "street_address"
            ]
        }
    ],
    "status": "OK"
}
* */
