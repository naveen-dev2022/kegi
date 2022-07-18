import 'dart:async';
import 'dart:convert';
import 'package:kegi_sudo/models/login_model.dart';
import 'package:kegi_sudo/models/otp_model.dart';
import 'package:kegi_sudo/models/otp_registration_model.dart';
import 'package:kegi_sudo/models/registration_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

const String _storageKey = 'token';

class UserApiProvider {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<OtpModel> otpApiProvider({
    @required String? email,
    @required String? mobile,
  }) async {
    print('email--->$email');
    print('mobile--->$mobile');

    Response<String> response;
    final Dio dio = Dio();
    dio.options.headers['email'] = '$email';
    dio.options.headers['mobile'] = '$mobile';
    dio.options.headers['dbname'] = 'kegi';
    //  final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.get<String>('http://35.230.66.119:8069/api/sms/otp');
      print('response pArt-----$response');
      Map toJson = jsonDecode(response.data!);
      return OtpModel.fromJson({
        "status": toJson['status'],
        "msg": toJson['msg'],
      });
    } on DioError catch (error) {
      print('Error pArt-----$error');
      if (error.type == DioErrorType.other) {
        print('internet part-----$error');
        return OtpModel.withError(
            'Server is not reachable. Please verify your internet connection and try again');
      } else {
        if(error.response!.statusCode==500){
          return OtpModel.withError('Internal server error');
        }
        print('else pArt-----$error');
        return OtpModel.withError(error.toString());
      }
    }
  }

  Future<LoginModel> authenticate({
    @required String? email,
    @required String? mobile,
    @required String? otp,
  }) async {

    print('email--->$email');
    print('mobile--->$mobile');
    print('otp--->$otp');

    Response<String> response;
    final Dio dio = Dio();
    dio.options.headers['otp'] = int.parse(otp!);
    dio.options.headers['email'] = mobile;
    dio.options.headers['dbname'] = 'kegi';
    dio.options.headers['mobile'] = email;
    //  final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.get<String>('http://35.230.66.119:8069/api/login');
      Map toJson = jsonDecode(response.data!);
      print('toJson--->${response.data}');
      return LoginModel.fromJson({
        "status": toJson['status'],
        "token": toJson['token'],
        "message": toJson['message'],
        "user": toJson['user'],
        "serverError": toJson['detail']
      });
    } on DioError catch (error) {
      print('ERRor--->$error');
      if (error.response!.statusCode == 401) {
        return LoginModel.withError('Please try again or get new otp');
      } else if (error.type == DioErrorType.other) {
        print('internet part-----$error');
        return LoginModel.withError(
            'Server is not reachable. Please verify your internet connection and try again');
      }
      return LoginModel.withError(error.toString());
    }
  }

  Future<bool> deleteToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_storageKey, '');
  }

  Future<bool> persistToken({@required String? token}) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_storageKey, token!);
  }

  Future<bool> hasToken() async {
    final SharedPreferences prefs = await _prefs;
    final String token = prefs.getString(_storageKey) ?? '';
    if (token.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<RegistrationOtpModel> registrationOtpApiProvider({
    @required String? email,
    @required String? mobile,
    @required String? name,
  }) async {
    print('email--->$email');
    print('mobile--->$mobile');

    Response<String> response;
    final Dio dio = Dio();
    dio.options.headers['email'] = email;
    dio.options.headers['mobile'] = mobile;
    dio.options.headers['dbname'] = 'kegi';
    //  final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.get<String>('http://35.230.66.119:8069/api/sms/otp/signup').catchError((error,_){
        print('Error Stacktrace::=> $_');
        print('Error::=> $error');
      });
      print('response pArt-----$response');
      Map toJson = jsonDecode(response.data!);
      return RegistrationOtpModel.fromJson({
        "status": toJson['status'],
        "msg": toJson['msg'],
      });
    } on DioError catch (error) {
      print('Error pArt-----$error');
      if (error.type == DioErrorType.other) {
        print('internet part-----$error');
        return RegistrationOtpModel.withError(
            'Server is not reachable. Please verify your internet connection and try again');
      } else {
        print('else pArt-----$error');
        if(error.response!.statusCode==500){
          return RegistrationOtpModel.withError('Internal server error');
        }
        return RegistrationOtpModel.withError(error.toString());
      }
    }
  }




  Future<RegistrationModel> register({
    @required String? name,
    @required String? email,
   @required String? mobile,
   @required String? otp,
  }) async {

    print('name-----$name');
    print('mobile-----$email');
    print('email-----$mobile');
    print('otp-----$otp');

    Response<String> response;
    final Dio dio = Dio();

    dio.options.headers['name'] = name;
    dio.options.headers['email'] = mobile;
    dio.options.headers['mobile'] = email;
    dio.options.headers['otp'] = int.parse(otp!);
  //  const String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.get<String>(
          'http://35.230.66.119:8069/api/signup').catchError((error,_){
            print('Error Stack trace::> $_');
            print('Error::> $error');
      });
      print(response);
      Map toJson = jsonDecode(response.data!);
      print('toJson--->${response.data}');
      return RegistrationModel.fromJson({
        "status": toJson['status'],
        "token": toJson['token'],
        "message": toJson['message'],
        "user": toJson['user'],
        "serverError": toJson['detail']
      });
    } on DioError catch (error) {
      print('ERROR_____$error');
      if (error.response!.statusCode == 401) {
        return RegistrationModel.withError('Please try again or get new otp');
      } else if (error.type == DioErrorType.other) {
        print('internet part-----$error');
        return RegistrationModel.withError(
            'Server is not reachable. Please verify your internet connection and try again');
      }
      return RegistrationModel.withError(error.toString());
    }
  }
}
