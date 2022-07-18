import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kegi_sudo/models/nearbyplace_model.dart';
import 'package:kegi_sudo/screens/map_view/search_city_autocomplete.dart';
import 'package:kegi_sudo/utils/app_methods.dart';

class ApiProviderMapView {

  Future<NearByPlacesModel> fetchMapViewData(double? lat,double? lang) async {
    Response <Map<String, dynamic>> response;
    final Dio dio = Dio();
    try {
      response = await dio.get<Map<String, dynamic>>('https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        ,queryParameters: {
        "radius": '2000',
        "key": AppMethods.GoogleMapApiKey,
        "location": "$lat,$lang",
      },);
      print('near by place response pArt-----$response');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return NearByPlacesModel.fromJson(map);
    } catch (error, stacktrace) {
      print('ERRoR---->${error.toString()}');
      return NearByPlacesModel.withError('$error');
    }
  }
}

class PlaceApi {
  PlaceApi._internal();
  static PlaceApi get instance => PlaceApi._internal();
  final Dio _dio = Dio();


  Future<List<Place>> searchPredictions(String input) async {
    print('inside@@@searchPrediction');
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          "input": input,
          "key": AppMethods.GoogleMapApiKey,
          "types": "address",
          "language": "en-US",
          "components":'country:SA',
          //  "components": "country:ec",
        },
      );
      print('response.data------->>>>>>${response.data}');
      final List<Place> places = (response.data['predictions'] as List)
          .map((item) => Place.fromJson(item))
          .toList();
      return places;
    } catch (e) {
      List<Place>? places;
      print('error....${e}');
      return places!;
    }
  }
}