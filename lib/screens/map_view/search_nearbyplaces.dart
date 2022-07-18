import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/controller/nearby_places_controller.dart';
import 'package:kegi_sudo/models/favorite_model.dart';
import 'package:kegi_sudo/models/nearbyplace_model.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/screens/map_view/map_view.dart';
import 'package:kegi_sudo/screens/map_view/map_view_screen.dart';
import 'package:kegi_sudo/screens/map_view/search_city_autocomplete.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:kegi_sudo/widgets/app_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchNearByPlaces extends StatefulWidget {
  SearchNearByPlaces({Key? key, this.lat, this.lang, this.pageKey})
      : super(key: key);

  double? lat;
  double? lang;
  String? pageKey;

  @override
  _SearchNearByPlacesState createState() =>
      _SearchNearByPlacesState(lat, lang, pageKey);
}

class _SearchNearByPlacesState extends State<SearchNearByPlaces> {
  _SearchNearByPlacesState(this.lat, this.lang, this.pageKey);

  double? lat;
  double? lang;
  String? pageKey;
  HomeBloc homeBloc = HomeBloc();

  SharedPreference sharedPreference = SharedPreference();
  bool loadData = false;
  Placemark? currentPlaceMark;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final NearByPlacesController nearByPlacesController = NearByPlacesController();
  ScrollController? controller;

  @override
  void initState() {
    homeBloc.fetchNearByPlacesBloc(lat!, lang!);
    nearByPlacesController.getFavoriteValue();
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    currentPlaceMark=await AppMethods.getPLaceMarkFromLatLong(lat!,lang!);
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppWidgets.appbar(context,title: 'Location'),
      body: currentPlaceMark==null?Container():_buildChildWidget(),
    );
  }

  Widget _buildChildWidget(){
    return SizedBox(
      height: 100.h,
      width: 100.w,
      child: ListView(
       controller: controller,
        children: [
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SearchCityScreen(lat:lat,lang:lang)));
                  },
                  child: Container(
                    height: 35,
                    width: 65.w,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(width: 6,),
                        Icon(Icons.search),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'What are you looking for?',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'montserrat_regular',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                SizedBox(
                  width: 22.w,
                  height: 37,
                  child: Center(
                    child: Text('${currentPlaceMark!.country}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'quicksand_regular',
                        )),
                  ),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
          ),

          SizedBox(
            height: 2.h,
          ),

          Obx(()=> nearByPlacesController.favoriteArrList.isEmpty?SizedBox(): Container(
            color: Colors.grey.shade200,
            height: 30,
            width: 100.w,
            child: const Padding(
              padding: EdgeInsets.only(left: 15, top: 6),
              child: Text(
                'Saved locations',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'quicksand_regular',
                ),
              ),
            ),
          ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Obx((){
              if (nearByPlacesController.favoriteArrList.isEmpty) {
              return const SizedBox();
            } else {
              return ListView.builder(
                itemCount: nearByPlacesController.favoriteArrList.length,
                shrinkWrap: true,
                addAutomaticKeepAlives: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: controller,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Get.find<MapViewController>().card1 = false;
                          Get.find<MapViewController>().card2 = false;
                          Get.find<MapViewController>().card3 = false;
                          Get.find<MapViewController>().card4 = false;
                        //  Get.find<MapViewController>().descriptionController.value.clear();
                        //  Provider.of<DataListner>(context, listen: false).imageFileList = [];
                          Provider.of<DataListner>(context, listen: false).datePickerLocally = '';
                          Provider.of<DataListner>(context, listen: false)
                              .SetDatePickerData('Select Time');
                          int count = 0;
                          Navigator.popUntil(context, (route) {
                            return count++ == 2;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MapViewScreen(
                            preloadData: Get.find<MapViewController>().preloadData.value,
                            mainId:  Get.find<MapViewController>().mainId.value,
                            pageKey: 'NEARBY_PLACES',
                            nearby_placelat:nearByPlacesController.favoriteArrList[i].lat,
                            nearby_placelng:nearByPlacesController.favoriteArrList[i].lang,
                          )));
                        },
                        leading: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: const Color(0xffecf4fc),
                                borderRadius: BorderRadius.circular(50)),
                            child: const Icon(Icons.location_on,
                                color: Color(0xff5888B6))),
                        title: Text(
                          nearByPlacesController.favoriteArrList[i].title!,
                          style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'montserrat_medium',
                              fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          nearByPlacesController.favoriteArrList[i].subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'montserrat_regular',
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                              Icons.favorite,
                              color: Color(0xff6ed1ec)),
                          onPressed: () {
                            final arrList =
                            nearByPlacesController.favoriteArrList.removeAt(i);
                            final json = jsonEncode(arrList);
                            nearByPlacesController.sharedPreference.value.setFavoriteList(json);
                            AppMethods.showSnackbar(context, "Removed saved location !!", Color(0xfff6b3b3), Icons.info, Color(0xff9e3434));
                          },
                        ),
                      ),
                      nearByPlacesController.favoriteArrList.length-1==i?SizedBox(height: 12,): Divider()
                    ],
                  );
                },
              );
            }
          }),
          Container(
            color: Colors.grey.shade200,
            height: 30,
            width: 100.w,
            child: const Padding(
              padding: EdgeInsets.only(left: 15, top: 6),
              child: Text(
                'Nearby Places',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'quicksand_regular',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          StreamBuilder<NearByPlacesModel>(
            stream: homeBloc.allNearByPlaces,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Places(
                  data: snapshot.data,
                    scrollController:controller,
                    nearByPlacesController:nearByPlacesController,
                    scaffoldKey:_scaffoldKey
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}

class Places extends StatefulWidget {
  Places({Key? key, this.data,this.nearByPlacesController,this.scrollController,this.scaffoldKey}) : super(key: key);
  GlobalKey<ScaffoldState>? scaffoldKey;
  NearByPlacesModel? data;
  NearByPlacesController? nearByPlacesController;
  ScrollController? scrollController;


  @override
  State<Places> createState() => _PlacesState(nearByPlacesController);
}

class _PlacesState extends State<Places> {
  _PlacesState(this.nearByPlacesController);
  NearByPlacesController? nearByPlacesController;
  RxList likedIconColor = [].obs;

  @override
  void initState() {
    for (int i = 0; i < widget.data!.results!.length; i++) {
      likedIconColor.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      shrinkWrap: true,
      itemCount: widget.data!.results!.length,
      addAutomaticKeepAlives: true,
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      controller: widget.scrollController,
     // scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            ListTile(
              onTap: () {
              //  print('GET DISCRIPTION----${Get.find<MapViewController>().descriptionController.value.text}');
                Get.find<MapViewController>().card1 = false;
                Get.find<MapViewController>().card2 = false;
                Get.find<MapViewController>().card3 = false;
                Get.find<MapViewController>().card4 = false;
              //  Get.find<MapViewController>().descriptionController.value.clear();
              //  Provider.of<DataListner>(context, listen: false).imageFileList = [];
                Provider.of<DataListner>(context, listen: false).datePickerLocally = '';
                Provider.of<DataListner>(context, listen: false)
                    .SetDatePickerData('Select Time');
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2;
                });
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MapViewScreen(
                  preloadData: Get.find<MapViewController>().preloadData.value,
                  mainId:  Get.find<MapViewController>().mainId.value,
                  pageKey: 'NEARBY_PLACES',
                  nearby_placelat:widget.data!.results![index].geometry!.location!.lat!,
                  nearby_placelng:widget.data!.results![index].geometry!.location!.lng,
                )));
              },
              leading: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: const Color(0xffecf4fc),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(Icons.location_on,
                      color: Color(0xff5888B6))),
              title: Text(
                '${widget.data!.results![index].name}',
                style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'montserrat_medium',
                    fontWeight: FontWeight.w800),
              ),
              subtitle: SizedBox(
                  height: 50,
                  width: 100.w,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${widget.data!.results![index].vicinity}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'montserrat_regular',
                      ),
                    ),
                  )),
              trailing: IconButton(
                icon: Icon(Icons.favorite_border,
                    color:  const Color(0xff6ed1ec)),
                onPressed: () {


                  Favorite fav = Favorite(
                      title: widget.data!.results![index].name,
                      subtitle: widget.data!.results![index].vicinity,
                      lat: widget
                          .data!.results![index].geometry!.location!.lat,
                      lang: widget
                          .data!.results![index].geometry!.location!.lng);

                  if (nearByPlacesController!.favoriteArrList.isEmpty) {
                    AppMethods.showSnackbar(context, "Location saved successfully !!", Color(0xffb5f6b5), Icons.done, Color(0xff2ca52c));
                    nearByPlacesController!.favoriteArrList.add(fav);
                  }

                  else {
                    for (int i = 0; i < nearByPlacesController!.favoriteArrList.length; i++) {
                      if (nearByPlacesController!.favoriteArrList[i].title == fav.title) {
                        AppMethods.showSnackbar(context, "Location already saved !!", Color(0xfff5e6ac), Icons.info, Color(0xffa1872e));
                        break;
                      } else if (i == nearByPlacesController!.favoriteArrList.length - 1) {
                        AppMethods.showSnackbar(context, "Location saved successfully !!", Color(0xffb5f6b5), Icons.done, Color(0xff2ca52c));
                        nearByPlacesController!.favoriteArrList.add(fav);
                        break;
                      }
                    }
                  }

                  print('#####${nearByPlacesController!.favoriteArrList.length}');
                  final json = jsonEncode(nearByPlacesController!.favoriteArrList);
                  nearByPlacesController!.sharedPreference.value.setFavoriteList(json);

                },
              ),
            ),
            const Divider()
          ],
        );
      },
    );
  }
}
