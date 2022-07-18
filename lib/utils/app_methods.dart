import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';

class AppMethods{

  static String GoogleMapApiKey='AIzaSyB8uutjbYX0C_pPM82ipCIyWUQ3cc5NmSg';

  static Future<String> getCurrentLocationAddress() async {
    return getAddressFromLatLong(await getGeoLocationPosition());
  }

  static Future<String> getCurrentLocationCountryAddress() async {
    return getLocalityCountryFromLatLong(await getGeoLocationPosition());
  }

  static Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static Future<String> getAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    String Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    return Address;
  }

  static Future<String> getLocalityStreetFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    String Address = '${place.street}';
    return Address;
  }

  static Future<String> getLocalityStreetFromLatLong1(double lat,double long)async {
    print('Get LatLong:: $lat : $long');

    Future<Address> add=GeoCode().reverseGeocoding(latitude: lat, longitude: long);
    print('GEOCODE ADDRESS:: ${await add}');

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    Placemark place = placemarks[0];
    String address = '${place.street}';
    return address;
  }

  static Future<String> getLocalityCountryFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];

/*   Get.find<MapViewController>().country!.value = place.isoCountryCode!;
   Get.find<MapViewController>().postalCode!.value = place.postalCode!;
   Get.find<MapViewController>().city!.value = place.locality!;
   Get.find<MapViewController>().region!.value = place.administrativeArea!;

   Get.find<MapViewController>().currentCountry!.value = place.isoCountryCode!;
   Get.find<MapViewController>().currentPostalCode!.value = place.postalCode!;
   Get.find<MapViewController>().currentCity!.value = place.locality!;
    Get.find<MapViewController>().currentRegion!.value = place.administrativeArea!;*/
    Get.find<MapViewController>().street!.value = place.street!;
    Get.find<MapViewController>().subLocality!.value = place.subLocality!;


    String Address = '${place.locality}, ${place.country}';
    return Address;
  }

  ///not needed much
  static Future<String> getLocalityCountryFromLatLong1(double lat,double long)async {
    print('Get LatLong:: $lat : $long');

    /*Future<Address> add=GeoCode().reverseGeocoding(latitude: lat, longitude: long);
    print('GEOCODE ADDRESS:: ${await add}');*/

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    Placemark place = placemarks[0];
    String address = '${place.name}, ${place.administrativeArea}, ${place.country}';
    print('Address:: $address \n Placemark:: $placemarks');
    return address;
  }

  static Future<String> getLocalityFullAddressFromLatLong(double lat,double long)async {
    print('getLocalityFullAddressFromLatLong  lat lang:: $lat : $long');

    /*Future<Address> add=GeoCode().reverseGeocoding(latitude: lat, longitude: long);
    print('GEOCODE ADDRESS:: ${await add}');*/

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    Placemark place = placemarks[0];

  /*  Get.find<MapViewController>().country!.value = place.isoCountryCode!;
    Get.find<MapViewController>().postalCode!.value = place.postalCode!;
    Get.find<MapViewController>().city!.value = place.locality!;
    Get.find<MapViewController>().region!.value = place.administrativeArea!;


    Get.find<MapViewController>().currentCountry!.value = place.isoCountryCode!;
    Get.find<MapViewController>().currentPostalCode!.value = place.postalCode!;
    Get.find<MapViewController>().city!.value = place.locality!;
    Get.find<MapViewController>().currentRegion!.value = place.administrativeArea!;*/
    Get.find<MapViewController>().street!.value = place.street!;
    Get.find<MapViewController>().subLocality!.value = place.subLocality!;



    String address = '${place.street!.isNotEmpty?'${place.street},':''} ${place.subLocality!.isNotEmpty?'${place.subLocality},':''} ${place.locality!.isNotEmpty?'${place.locality},':''} ${place.postalCode!.isNotEmpty?'${place.postalCode},':''} ${place.country!.isNotEmpty?'${place.country}':''}';
    print('Address:: $address \n Placemark:: $placemarks');
    return address;
  }

  static Future<Placemark> getPLaceMarkFromLatLong(double lat,double long)async {
    print('Get LatLong:: $lat : $long');

    /*Future<Address> add=GeoCode().reverseGeocoding(latitude: lat, longitude: long);
    print('GEOCODE ADDRESS:: ${await add}');*/

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    Placemark place = placemarks[0];

/*    Get.find<MapViewController>().country!.value = place.isoCountryCode!;
    Get.find<MapViewController>().postalCode!.value = place.postalCode!;
    Get.find<MapViewController>().city!.value = place.locality!;
    Get.find<MapViewController>().region!.value = place.administrativeArea!;*/
    Get.find<MapViewController>().street!.value = place.street!;
    Get.find<MapViewController>().subLocality!.value = place.subLocality!;

/*
    Get.find<MapViewController>().currentCountry!.value = place.isoCountryCode!;
    Get.find<MapViewController>().currentPostalCode!.value = place.postalCode!;
    Get.find<MapViewController>().city!.value = place.locality!;
    Get.find<MapViewController>().currentRegion!.value = place.administrativeArea!;*/


    String address = '${place.name}, ${place.administrativeArea}, ${place.country}';
    print('Address:: $address \n Placemark:: $placemarks');
    return place;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static void toastMsg(String? value){
    Fluttertoast.showToast(
        msg: "${value!} !!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff253e44),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor!; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId!; // unique ID on Android
    }
  }

  static String? getServiceType(int id){
    if (id == 1) {
      return 'AC';
    } else if (id == 2) {
      return 'Other works';
    } else if (id == 3) {
      return 'Electrical';
    } else if (id == 4) {
      return 'Handyman';
    } else if (id == 5) {
      return 'Plumbing';
    }
  }

  static int? getServiceTypeIdByName(String value){
    if (value == 'A/C') {
      return 1;
    } else if (value == 'Other Works') {
      return 2;
    } else if (value == 'Electrical') {
      return 3;
    } else if (value == 'Handyman') {
      return 4;
    } else if (value == 'Plumbing') {
      return 5;
    }
  }

  static showSnackbar(BuildContext context,String? content,Color? backgroundColor,IconData? value,Color? iconColor){
    var triggerSnackbar   =    SnackBar(
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(value,color: iconColor,size: 24,),
          SizedBox(width:12 ,),
          Text(
            content!,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'quicksand_regular',
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(triggerSnackbar);
  }

}

extension E on String {
  String lastChars(int n) => substring(length - n);
}