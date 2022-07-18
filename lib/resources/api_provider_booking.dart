


import 'package:dio/dio.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/models/booking_history_model.dart';
import 'package:kegi_sudo/models/cancellation_model.dart';
import 'package:kegi_sudo/models/recheduling_model.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';

class ApiProviderActiveBooking{

  Future<BookingActiveModel> fetchActiveBookingApi() async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/booking/list',
          data: {

          });
      print('ActiveBookingRESPONSE---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return BookingActiveModel.fromJson(map);
    } catch (error, stacktrace) {
      print('ActiveBookingERRoR---->${error.toString()}');
      return BookingActiveModel.withError('$error');
    }
  }

  Future<BookingHistoryModel> fetchHistoryBookingApi() async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/booking/list/history',
          data: {

          });
      print('HistoryBookingRESPONSE---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return BookingHistoryModel.fromJson(map);
    } catch (error, stacktrace) {
      print('HistoryBookingERRoR---->${error.toString()}');
      return BookingHistoryModel.withError('$error');
    }
  }

  Future<CancellationModel> fetchCancellationBookingApi(int? id) async {
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/booking/cancel',
          data: {
            "params":{
              "booking_id" : id
            }
          });
      print('CancellationModelRESPONSE---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return CancellationModel.fromJson(map);
    } catch (error, stacktrace) {
      print('CancellationModelERRoR---->${error.toString()}');
      return CancellationModel.withError('$error');
    }
  }


  Future<RechedulingModel> fetchRechedulingBookingApi(int? bookingId,int? timeSlotId,String? date) async {

    print('bookingId--------${bookingId}');
    print('bookingId--------${timeSlotId}');
    print('bookingId--------${date}');
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
          'http://35.230.66.119:8069/api/booking/reschedule',
          data: {
            "params":{
              "booking_id" : bookingId,
              "scheduled_date":date,
              "time_slot_id":timeSlotId
            }
          });
      print('RechedulingModelRESPONSE---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return RechedulingModel.fromJson(map);
    } catch (error, stacktrace) {
      print('RechedulingModelERRoR---->${error.toString()}');
      return RechedulingModel.withError('$error');
    }
  }
}