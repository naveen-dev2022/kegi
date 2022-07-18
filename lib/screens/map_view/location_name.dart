
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:kegi_sudo/utils/app_methods.dart';

class FindLocationName{

  Future<String> GetAddressFromLatLong(_currentPosition)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition.latitude!, _currentPosition.longitude!);
   // print(placemarks);
    Placemark place = placemarks[0];
  //  print( 'place.street----${place.street}, subLocality-----${place.subLocality},locality--- ${place.locality}, name---${place.name}, country------${place.country}, ');
    return '${place.locality},${place.administrativeArea},${place.country}';
  }

  Future<PlacesDetailsResponse> displayPrediction(String? placeId) async {
    print('{{{{{{{{{{{{{$placeId');
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: AppMethods.GoogleMapApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId!);
      return detail;

  }

}