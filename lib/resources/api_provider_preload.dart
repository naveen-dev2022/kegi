import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kegi_sudo/models/booking_submit_model.dart';
import 'package:kegi_sudo/models/preload_model.dart';
import 'package:kegi_sudo/models/promo_apply_model.dart';
import 'package:kegi_sudo/models/promocode_model.dart';
import 'package:kegi_sudo/models/timesheet_model.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';

class PreloadApiProvider {
  Future<PreloadModel> fetchPreloadApi() async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/pre/load/data',
          data: {});
      print('PreloadApiRESPONSE---->${response}');
      final Map<String, dynamic> map =
          Map<String, dynamic>.from(response.data!);
      return PreloadModel.fromJson(map);
    } catch (error, stacktrace) {
      print('ERRoR---->${error.toString()}');
      return PreloadModel.withError('$error');
    }
  }

  Future<TimeSheetModel> fetchTimeSheetApi(int? id, String? date) async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/get/time/slot',
          data: {
            "params": {"service_category_id": id, "date": "$date"}
          });
      final Map<String, dynamic> map =
          Map<String, dynamic>.from(response.data!);
      return TimeSheetModel.fromJson(map);
    } catch (error, stacktrace) {
      print('ERRoR---->${error.toString()}');
      return TimeSheetModel.withError('$error');
    }
  }

  Future<PromoCodeModel> fetchPromoCodeApi() async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/promo/code',
          data: {});
      print('PromoCodeRESPONSE---->${response}');
      final Map<String, dynamic> map =
          Map<String, dynamic>.from(response.data!);
      return PromoCodeModel.fromJson(map);
    } catch (error, stacktrace) {
      print('ERRoR---->${error.toString()}');
      return PromoCodeModel.withError('$error');
    }
  }

  Future<PromoApplyModel> fetchPromoCodeApplyApi(String code,String service_type) async {

    print('fetchPromoCodeApplyApi------${service_type}');

    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/apply/promo',
          data: {
            "params":{
              "code":code,
              "service_type":service_type
            }
          },
      );
      print('PromoCodeRESPONSE---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return PromoApplyModel.fromJson(map);
    } catch (error, stacktrace) {
      print('ERRoR---->${error.toString()}');
      return PromoApplyModel.withError('$error');
    }
  }

  Future<BookingSubmitDataModel> fetchBookingSubmitApi(
      int? service_category_id,
      String? service_type,
      String? description,
      String? scheduled_date,
      int? time_slot_id,
      bool? point_of_contact_check,
      String? point_of_contact_name,
      String? point_of_contact_email,
      String? point_of_contact_number,
      String? flat_no,
      String? building_name,
      String? street_name,
      double? latitude,
      double? longitude,
      String? code,
      String? message,
      String? tranref,
      List<XFile>? images) async {

    print('--------service_category_id----${service_category_id}');
    print('--------service_type----${service_type}');
    print('--------description----${description}');
    print('--------scheduled_date----${scheduled_date}');
    print('--------time_slot_id----${time_slot_id}');
    print('--------point_of_contact_check----${point_of_contact_check}');
    print('--------point_of_contact_name----${point_of_contact_name}');
    print('--------point_of_contact_email----${point_of_contact_email}');
    print('--------point_of_contact_number----${point_of_contact_number}');
    print('--------images----${images}');
    print('--------code----${code}');
    print('--------message----${message}');
    print('--------tranref----${tranref}');

  /*  List arr=[];

    for (int i=0; i < images!.length; i++) {
      arr[i] = await MultipartFile.fromFile(images[i].path, filename: images[i].path.split('/').last);
    }
*/

    FormData formData = FormData.fromMap({
      'service_category_id': service_category_id.toString(),
      'service_type': service_type,
      'description': description,
      'scheduled_date': scheduled_date!.replaceAll('/', '-'),
      'time_slot_id': time_slot_id.toString(),
      'point_of_contact_check': point_of_contact_check==true?'True':point_of_contact_check,
      'point_of_contact_name': point_of_contact_name,
      'point_of_contact_email': point_of_contact_email,
      'point_of_contact_number': point_of_contact_number,
      'flat_no':flat_no,
      'building_name':building_name,
      'street_name':street_name,
      'latitude':latitude,
      'longitude':longitude,
      'code':code,
      'message':message,
      'tranref':tranref
    /*  'files': *//*[
        for (var item in images!)
          {
            await MultipartFile.fromFile(item.path,
                filename: item.path.split('/').last)
          }.toList()
      ]*//*arr,*/
    });

    for (int i = 0; i < images!.length; i++) {
      formData.files.addAll([
        MapEntry("files", await MultipartFile.fromFile(images[i].path, filename: images[i].path.split('/').last))
      ]);
    }

    Response<String> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
        'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<String>(
          'http://35.230.66.119:8069/api/booking/request/submit',
          data: formData,
      );
      Map toJson=jsonDecode(response.data!);
      print('BookingSubmitDataModel---RESPONSE---->${response}');
     /* final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);*/
      return BookingSubmitDataModel.fromJson({
        'name':toJson['name'],
        'status':toJson['status']
      });
    }
    on DioError catch  (error) {
      print('ERRoR---BookingSubmitDataModel---->${error.toString()}');
      return BookingSubmitDataModel.withError('$error');
    }
  }
}
