import 'package:dio/dio.dart';
import 'package:kegi_sudo/models/add_address_model.dart';
import 'package:kegi_sudo/models/address_delet_model.dart';
import 'package:kegi_sudo/models/address_list_model.dart';
import 'package:kegi_sudo/models/get_intouch_model.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';

class MyProfileApiProvider{
  Future<AddressAddModel> fetchAddAddressApi(String address_type,String flat_no,String building_name,String street_name,double lat,double lang) async {

    print('address_type----$address_type');
    print('flat_no----$flat_no');
    print('building_name----$building_name');
    print('street_name----$street_name');
    print('lat----$lat');
    print('lang----$lang');


    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/add/address',
          data: {
            "params":{
              "address_type":address_type,
              "flat_no":flat_no,
              "building_name":building_name,
              "street_name":street_name,
              "latitude":lat.toString(),
              "longitude":lang.toString()
            }
          });
      print('AddressAddRESPONSE---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return AddressAddModel.fromJson(map);
    } catch (error, stacktrace) {
      print('AddressAddERRoR---->${error.toString()}');
      return AddressAddModel.withError('$error');
    }
  }

  Future<AddressListModel> fetchAddressListApi() async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/address/list',
          data: {

          });
      print('AddressListRESPONSE---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return AddressListModel.fromJson(map);
    } catch (error, stacktrace) {
      print('AddressListERRoR---->${error.toString()}');
      return AddressListModel.withError('$error');
    }
  }

  Future<AddressDeletModel> fetchDeleteAddressApi(int? id) async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/address/delete',
          data: {
            "params":{
              "address_id":id
            }
          },
      );
      print('DeleteAddressApi---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return AddressDeletModel.fromJson(map);
    } catch (error, stacktrace) {
      print('DeleteAddressApiERRoR---->${error.toString()}');
      return AddressDeletModel.withError('$error');
    }
  }



  Future<GetInTouchModel> fetchGetInTouchApi(String? description,String? bookingUs) async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
        'http://35.230.66.119:8069/api/get/in/touch',
        data: {
          "params":{
            "description" : description,
            "booking_with_us":bookingUs
          }
        },
      );
      print('DeleteAddressApi---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return GetInTouchModel.fromJson(map);
    } catch (error, stacktrace) {
      print('DeleteAddressApiERRoR---->${error.toString()}');
      return GetInTouchModel.withError('$error');
    }
  }

}