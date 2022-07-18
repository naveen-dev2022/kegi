


import 'package:dio/dio.dart';
import 'package:kegi_sudo/models/banner_model.dart';
import 'package:kegi_sudo/models/barnds_model.dart';

import '../utils/shared_preference.dart';

class ApiProviderBrands{
  Future<BannerListModel> fetchBrandBannerApi() async {

    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
        'http://35.230.66.119:8069/api/banner/list',
        data: {

        },
      );
      print('BannerListModelRESPONSE---->${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return BannerListModel.fromJson(map);
    } catch (error, stacktrace) {
      print('BannerListModelERRoR---->${error.toString()}');
      return BannerListModel.withError('$error');
    }
  }

  Future<BrandListModel> fetchBrandListApi() async {
print('TOKEN::+> ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}');
    Response<Map<String, dynamic>> response;
    final Dio dio = Dio();
    dio.options.headers['authorization'] =
    'token ${SharedPreference.getStringValueFromSF(SharedPreference.GET_TOKEN)}';
    // final String baseUrl = AppConfig.API_URL;
    try {
      response = await dio.post<Map<String, dynamic>>(
        'http://35.230.66.119:8069/api/brand/list',
        data: {

        },
      );
      print('BrandListRESPONSE----> ${response.data!['result']['brand_ids'].length} :: ${response}');
      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data!);
      return BrandListModel.fromJson(map);
    } catch (error, stacktrace) {
      print('BrandListERRoR---->${error.toString()}');
      return BrandListModel.withError('$error');
    }
  }

}