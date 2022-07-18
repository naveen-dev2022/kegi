import 'dart:convert';
import 'package:get/get.dart';
import 'package:kegi_sudo/models/favorite_model.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';

class NearByPlacesController extends GetxController{

  RxList favoriteArrList = [].obs;
  RxList favoriteIconColor = [].obs;

  Rx<SharedPreference> sharedPreference = SharedPreference().obs;


  @override
  void onInit() {
    super.onInit();
  }

  Future getFavoriteValue() async {
    final favoriteList = await sharedPreference.value.getFavoriteList();
    var decodeList = jsonDecode(favoriteList) as List;
    favoriteArrList.value = decodeList.map((e) => Favorite.fromJson(e)).toList();
    print('SHARED PREFERENCE VALUE------${favoriteArrList.value}');
    return favoriteArrList;
  }

}
