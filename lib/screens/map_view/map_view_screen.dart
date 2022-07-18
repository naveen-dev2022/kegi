import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/resources/api_provider_myprofile.dart';
import 'package:kegi_sudo/utils/end_drawer.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../models/preload_model.dart';
import '../../utils/app_methods.dart';

class MapViewScreen extends StatefulWidget {
  MapViewScreen(
      {Key? key,
      this.preloadData,
      this.mainId,
      this.pageKey,
      this.nearby_placelat,
      this.nearby_placelng,this.isFromMapViewScreen})
      : super(key: key);
  PreloadModel? preloadData;
  int? mainId;
  String? pageKey;
  double? nearby_placelat;
  double? nearby_placelng;
  bool? isFromMapViewScreen;

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen>
    with TickerProviderStateMixin {

  final MapViewController _controller = Get.put(MapViewController());

  AnimationController? animationController;
  RxString newAddress = ''.obs;
  RxBool isLoading = true.obs;
  RxBool isOpenBottomSheet = false.obs;
  final TextEditingController _newAddressFlatNo = TextEditingController();
  final TextEditingController _newAddressBuilding = TextEditingController();
  final TextEditingController _newAddressStreet = TextEditingController();
  bool home = true;
  bool office = false;
  bool store = false;
  bool other = false;
  String chooseAddressType = 'home';
  String? selectedAddressHeading;
  RxBool confirmAddressButtonPressed=false.obs;
 // Rx<Uint8List> markerIcon=Uint8List(80).obs;
  Locale? locale;

  @override
  void dispose() {
    animationController?.dispose();
    // _controller.bottomSheetAnimationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {

    print('MAIN ID---->>>${widget.mainId}');
    locale=Get.locale;
    if(locale==const Locale('en','US')){
      print('LOCALE----->>>$locale');
      selectedAddressHeading = 'Home';
    }
    else{
      selectedAddressHeading = 'map_with_address_home'.tr;
    }

/*
    AppMethods.getBytesFromAsset('assets/images/location_marker.png', 80)
        .then((value) {
      markerIcon.value = value;
    });*/

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    getAddress();

    _controller.homeBloc.fetchAddressListBloc().then((value) async {
      //  Future.delayed(const Duration(milliseconds: 100), () {
      if (widget.pageKey!.contains('SERVICE_SCREEN')) {
        _controller.preloadData.value = widget.preloadData!;
        _controller.mainId.value = widget.mainId!;
        Position position = await AppMethods.getGeoLocationPosition();
        _controller.pointLocation!.value =
            await AppMethods.getLocalityCountryFromLatLong(position);
        _controller.currentLocation!.value = _controller.pointLocation!.value;
        _controller.address.value = _controller.pointLocation!.value;
        _newAddressStreet.text="${Get.find<MapViewController>().street!.value},${Get.find<MapViewController>().subLocality!}";
        isLoading.value = false;
        isOpenBottomSheet.value = true;
      } else  if(widget.isFromMapViewScreen??false){
        _controller.preloadData.value = widget.preloadData!;
        _controller.mainId.value = widget.mainId!;
        _controller.pointLocation!.value =
        await AppMethods.getLocalityFullAddressFromLatLong(
            widget.nearby_placelat!, widget.nearby_placelng!);
        _controller.currentLocation!.value = _controller.pointLocation!.value;
        _controller.address.value = _controller.pointLocation!.value;
        _newAddressStreet.text="${Get.find<MapViewController>().street!.value},${Get.find<MapViewController>().subLocality!}";
        isLoading.value = false;
        isOpenBottomSheet.value = true;
      }
      else {
       // _controller.descriptionController.value.text=Get.find<MapViewController>().descriptionController.value.text;
        _controller.preloadData.value = widget.preloadData!;
        _controller.mainId.value = widget.mainId!;
        _controller.pointLocation!.value =
            await AppMethods.getLocalityFullAddressFromLatLong(
                widget.nearby_placelat!, widget.nearby_placelng!);
        _controller.currentLocation!.value = _controller.pointLocation!.value;
        _controller.address.value = _controller.pointLocation!.value;
        _newAddressStreet.text="${Get.find<MapViewController>().street!.value},${Get.find<MapViewController>().subLocality!}";
        isLoading.value = false;
      }
      //  });
    });
  //  print('FROM NEARBY SCREEN-------${_controller.descriptionController.value.text}');

    _controller.mainId.value = widget.mainId!;
    _controller.homeBlocTime1.fetchTimeSheetBloc(
        _controller.mainId.value,
        DateFormat('M/d/y')
            .format(DateTime.now().add(const Duration(days: 0))));
    _controller.homeBlocTime2.fetchTimeSheetBloc(
        _controller.mainId.value,
        DateFormat('M/d/y')
            .format(DateTime.now().add(const Duration(days: 1))));
    _controller.homeBlocTime3.fetchTimeSheetBloc(
        _controller.mainId.value,
        DateFormat('M/d/y')
            .format(DateTime.now().add(const Duration(days: 2))));
    _controller.homeBlocTime4.fetchTimeSheetBloc(
        _controller.mainId.value,
        DateFormat('M/d/y')
            .format(DateTime.now().add(const Duration(days: 3))));
    _controller.homeBlocTime5.fetchTimeSheetBloc(
        _controller.mainId.value,
        DateFormat('M/d/y')
            .format(DateTime.now().add(const Duration(days: 4))));
    _controller.homeBlocTime6.fetchTimeSheetBloc(
        _controller.mainId.value,
        DateFormat('M/d/y')
            .format(DateTime.now().add(const Duration(days: 5))));
    _controller.homeBlocTime7.fetchTimeSheetBloc(
        _controller.mainId.value,
        DateFormat('M/d/y')
            .format(DateTime.now().add(const Duration(days: 6))));
    super.initState();
  }

  Future getAddress() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (widget.pageKey!.contains('SERVICE_SCREEN')) {
        _controller.initialCameraPosition.value = LatLng(
            SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LAT)!,
            SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LONG)!);
        _controller.newLocation.value = LatLng(
            SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LAT)!,
            SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LONG)!);
        // _controller.isOpenBottomSheet.value=false;
        print(
            'SERVICE_SCREEN111111----------${_controller.pointLocation!.value}');
      } else {
        _controller.initialCameraPosition.value =
            LatLng(widget.nearby_placelat!, widget.nearby_placelng!);
        _controller.newLocation.value =
            LatLng(widget.nearby_placelat!, widget.nearby_placelng!);
        // _controller.isOpenBottomSheet.value=true;
        print(
            'SERVICE_SCREEN222222------------${_controller.pointLocation!.value}');
      }
    });
  }

  /* @override
  Future<void> didChangeDependencies() async {

    getAddress();
  //_initialCameraPosition=LatLng(position.latitude, position.longitude);;
  _controller.homeBloc.fetchAddressListBloc().then((value) {
    _controller.preloadData.value=widget.preloadData!;
    _controller.isLoading.value=false;
  });
  _controller.mainId.value=widget.mainId!;
  _controller.homeBlocTime1.fetchTimeSheetBloc(_controller.mainId.value,
      DateFormat('M/d/y').format(DateTime.now().add(const Duration(days: 0))));
  _controller.homeBlocTime2.fetchTimeSheetBloc(_controller.mainId.value,
      DateFormat('M/d/y').format(DateTime.now().add(const Duration(days: 1))));
  _controller.homeBlocTime3.fetchTimeSheetBloc(_controller.mainId.value,
      DateFormat('M/d/y').format(DateTime.now().add(const Duration(days: 2))));
  _controller.homeBlocTime4.fetchTimeSheetBloc(_controller.mainId.value,
      DateFormat('M/d/y').format(DateTime.now().add(const Duration(days: 3))));
  _controller.homeBlocTime5.fetchTimeSheetBloc(_controller.mainId.value,
      DateFormat('M/d/y').format(DateTime.now().add(const Duration(days: 4))));
  _controller.homeBlocTime6.fetchTimeSheetBloc(_controller.mainId.value,
      DateFormat('M/d/y').format(DateTime.now().add(const Duration(days: 5))));
  _controller.homeBlocTime7.fetchTimeSheetBloc(_controller.mainId.value,
      DateFormat('M/d/y').format(DateTime.now().add(const Duration(days: 6))));
    //_controller.addProblemBottomSheet(context);
    super.didChangeDependencies();
  }*/

  Future<bool> onBackPressed() async {
    Get.find<MapViewController>().valuefirst=false;
    _controller.card1 = false;
    _controller.card2 = false;
    _controller.card3 = false;
    _controller.card4 = false;
    Provider.of<DataListner>(context, listen: false).descriptionController.text='';
    Provider.of<DataListner>(context, listen: false)
        .promoApplyCheck
        .text = '';
    Get.find<MapViewController>().isCheck=null;
    _controller.nameController.value.clear();
    _controller.emailController.value.clear();
    _controller.mobileController.value.clear();
    Get.find<MapViewController>().discountUsingPromoCode=0.0;
    Provider.of<DataListner>(context, listen: false).imageFileList = [];
    Provider.of<DataListner>(context, listen: false).datePickerLocally = '';
    Provider.of<DataListner>(context, listen: false)
        .SetDatePickerData('Select Time');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(),
      child: Scaffold(
        //  key: _controller.key,
        extendBodyBehindAppBar: true,
        appBar: _appBar(),
        endDrawer: const EndDrawer(),
        body: Stack(
          children: [
            _map(),
            Obx(() {
              if (!isLoading.value && isOpenBottomSheet.value) {
                _controller.addProblemBottomSheet(context);
                isOpenBottomSheet.value = false;
              }
              return isLoading.value
                  ? Container(
                      width: double.infinity,
                      height: 100.h,
                      color: Colors.white,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Color(0xff6ed1ec),
                          size: 40.0,
                          controller: animationController,
                        ),
                      ))
                  : SizedBox();
            })
          ],
        ),
      ),
    );
  }

  Widget _map() {
    return Stack(
      children: [
        GoogleMap(
          markers: Set<Marker>.of(_controller.markers.values),
          onMapCreated: _onMapCreated,
          onTap: (position) async {
            print('OnTap Click!!');
            //_controller.addProblemBottomSheet(context);
          },
          initialCameraPosition: CameraPosition(
            target: _controller.initialCameraPosition.value,
            zoom: 17.0,
          ),
          myLocationEnabled: true,
          onCameraIdle: () async {
            print(
                'New Location:: ${_controller.newLocation}  => ${await AppMethods.getLocalityFullAddressFromLatLong(_controller.newLocation.value.latitude, _controller.newLocation.value.longitude)}');
            newAddress.value =
                await AppMethods.getLocalityFullAddressFromLatLong(
                    _controller.newLocation.value.latitude,
                    _controller.newLocation.value.longitude);
            _newAddressStreet.text="${Get.find<MapViewController>().street!.value},${Get.find<MapViewController>().subLocality!.value}";
          },
          //onCameraMove: (_position)=>_updatePosition(_position),
          onCameraMove: (CameraPosition position) {
            print('onCameraMove');
            _controller.newLocation.value = position.target;
            if (_controller.markers.isNotEmpty) {
              MarkerId markerId = MarkerId(_markerIdVal());
              Marker? marker = _controller.markers[markerId];
              Marker updatedMarker = marker!.copyWith(
                positionParam: position.target,
              );
              setState(() {
                _controller.markers[markerId] = updatedMarker;
              });
            }
          },
        ),
        Positioned(
            bottom: 0,
            child: Container(
                width: 100.w,
                color: Colors.white,
                //could change this to Color(0xFF737373),
                //so you don't have to change MaterialApp canvasColor
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 6,
                          ),
                          Icon(Icons.location_on, color: Color(0xff3772A3)),
                          const SizedBox(
                            width: 6,
                          ),
                          Obx(() {
                            return SizedBox(
                              width: 80.w,
                              child: Text(
                                newAddress.value,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'montserrat_medium'),
                              ),
                            );
                          })
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextButton(
                        onPressed: () async {
                          // Get.find<MapViewController>().currentLocation!.value=newAddress.value;
                          // Provider.of<DataListner>(context, listen: false).setbookingAddress(newAddress.value);
                          bottomSheetFillAddress();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff6ed1ec),
                              borderRadius: BorderRadius.circular(16)),
                          height: 40,
                          width: 100.w,
                          child:  Center(
                            child: Text(
                              'confirm_address_button'.tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'montserrat_medium',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )))
      ],
    );
  }

  void bottomSheetFillAddress() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          backgroundColor: Colors.grey.shade200,
          isDismissible: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          builder: (builder) {
            return StatefulBuilder(
              builder: (BuildContext context, setter) {
                return FractionallySizedBox(
                  heightFactor: 1.0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: Colors.transparent,
                      //could change this to Color(0xFF737373),
                      //so you don't have to change MaterialApp canvasColor
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 12, right: 12),
                        child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 2.h,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        selectedAddressHeading!,
                                        style: TextStyle(
                                            fontFamily: 'montserrat_bold',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  color: const Color(0xffe2e2e2),
                                  height: 45,
                                  width: double.infinity,
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: TextFormField(
                                    controller: _newAddressFlatNo,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'montserrat_Medium',
                                        fontSize: 14),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration:  InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText:  'map_with_address_flat'.tr,
                                      hintStyle: TextStyle(
                                          fontFamily: 'montserrat_Medium',
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  color: const Color(0xffe2e2e2),
                                  height: 45,
                                  width: double.infinity,
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: TextFormField(
                                    controller: _newAddressBuilding,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'montserrat_Medium',
                                        fontSize: 14),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration:  InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: 'map_with_address_building'.tr,
                                      hintStyle: TextStyle(
                                          fontFamily: 'montserrat_Medium',
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  color: const Color(0xffe2e2e2),
                                  height: 45,
                                  width: double.infinity,
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: TextFormField(
                                    controller: _newAddressStreet,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'montserrat_Medium',
                                        fontSize: 14),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    decoration:  InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText:'map_with_address_street'.tr,
                                      hintStyle: TextStyle(
                                          fontFamily: 'montserrat_Medium',
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setter(() {
                                          home = true;
                                          office = false;
                                          store = false;
                                          other = false;
                                          chooseAddressType = 'home';
                                          if(locale==const Locale('en','US')){
                                            print('LOCALE----->>>$locale');
                                            selectedAddressHeading = 'Home';
                                          }
                                          else{
                                            selectedAddressHeading = 'map_with_address_home'.tr;
                                          }
                                        });
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: const Color(0xff6ed1ec)),
                                            color: !home
                                                ? Colors.white
                                                : const Color(0xff6ed1ec),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children:  [
                                              ImageIcon(AssetImage(
                                                  'assets/images/home_icon.png')),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('map_with_address_home'.tr)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setter(() {
                                          home = false;
                                          office = true;
                                          store = false;
                                          other = false;
                                          chooseAddressType = 'office';
                                          if(locale==const Locale('en','US')){
                                            print('LOCALE----->>>$locale');
                                            selectedAddressHeading = 'Office';
                                          }
                                          else{
                                            selectedAddressHeading = 'map_with_address_office'.tr;
                                          }
                                        });
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            color: !office
                                                ? Colors.white
                                                : const Color(0xff6ed1ec),
                                            border: Border.all(
                                                color: const Color(0xff6ed1ec)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              ImageIcon(AssetImage(
                                                  'assets/images/office_icon.png')),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text('map_with_address_office'.tr,overflow: TextOverflow.ellipsis,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setter(() {
                                          home = false;
                                          office = false;
                                          store = true;
                                          other = false;
                                          chooseAddressType = 'store';
                                          if(locale==const Locale('en','US')){
                                            selectedAddressHeading = 'Store';
                                          }
                                          else{
                                            selectedAddressHeading = 'map_with_address_store'.tr;
                                          }
                                        });
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            color: !store
                                                ? Colors.white
                                                : const Color(0xff6ed1ec),
                                            border: Border.all(
                                                color: const Color(0xff6ed1ec)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              ImageIcon(AssetImage(
                                                  'assets/images/store_icon.png')),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text('map_with_address_store'.tr)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setter(() {
                                          home = false;
                                          office = false;
                                          store = false;
                                          other = true;
                                          chooseAddressType = 'other';
                                          if(locale==const Locale('en','US')){
                                            selectedAddressHeading = 'Other';
                                          }
                                          else{
                                            selectedAddressHeading = 'map_with_address_other'.tr;
                                          }
                                        });
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12.0),
                                            color: !other
                                                ? Colors.white
                                                : const Color(0xff6ed1ec),
                                            border: Border.all(
                                                color: const Color(0xff6ed1ec)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              ImageIcon(AssetImage(
                                                  'assets/images/other_icon.png')),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text('map_with_address_other'.tr)
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                other
                                    ? Container(
                                  color: const Color(0xffe2e2e2),
                                  height: 45,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: TextFormField(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'montserrat_Medium',
                                        fontSize: 14),
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: 'Nickname (Required)',
                                      hintStyle: TextStyle(
                                          fontFamily: 'montserrat_Medium',
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ),
                                )
                                    : const SizedBox(),
                               Obx((){
                                 if( confirmAddressButtonPressed.value){
                                   return  Container(
                                     decoration: BoxDecoration(
                                         color: const Color(0xffadd7e2),
                                         borderRadius: BorderRadius.circular(16)),
                                     height: 40,
                                     width: 100.w,
                                     child:  Center(
                                       child: Text(
                                         'map_with_address_addAddress'.tr,
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontFamily: 'montserrat_medium',
                                             fontWeight: FontWeight.bold),
                                       ),
                                     ),
                                   );
                                 }
                                 else{
                                   return TextButton(
                                     onPressed: () {
                                       if(_newAddressFlatNo.text.isEmpty || _newAddressBuilding.text.isEmpty || _newAddressStreet.text.isEmpty){
                                         Fluttertoast.showToast(
                                             msg: "Please fill all fields !!",
                                             toastLength: Toast.LENGTH_LONG,
                                             gravity: ToastGravity.CENTER,
                                             timeInSecForIosWeb: 1,
                                             backgroundColor: Color(0xff253e44),
                                             textColor: Colors.white,
                                             fontSize: 16.0);
                                       }
                                       else{
                                         confirmAddressButtonPressed.value=true;
                                         MyProfileApiProvider myProfileApiProvider =
                                         MyProfileApiProvider();
                                         myProfileApiProvider
                                             .fetchAddAddressApi(
                                             chooseAddressType,
                                             _newAddressFlatNo.text,
                                             _newAddressBuilding.text,
                                             _newAddressStreet.text,
                                             widget.nearby_placelat??_controller.newLocation.value.latitude,
                                             widget.nearby_placelng??_controller.newLocation.value.longitude)
                                             .then((value) {
                                           if (value.result!.status!) {
                                             Fluttertoast.showToast(
                                                 msg: "${value.result!.msg} !!",
                                                 toastLength: Toast.LENGTH_LONG,
                                                 gravity: ToastGravity.CENTER,
                                                 timeInSecForIosWeb: 1,
                                                 backgroundColor: Color(0xff253e44),
                                                 textColor: Colors.white,
                                                 fontSize: 16.0);

                                             _controller.currentLocation!.value = newAddress.value;
                                             _controller.address.value = newAddress.value;
                                             _controller.homeBloc.fetchAddressListBloc().then((value) {
                                               _newAddressFlatNo.text='';
                                               _newAddressBuilding.text='';
                                               _newAddressStreet.text='';
                                               confirmAddressButtonPressed.value=false;
                                               isOpenBottomSheet.value = true;
                                             });

                                           } else {
                                             confirmAddressButtonPressed.value=false;
                                             Fluttertoast.showToast(
                                                 msg: "${value.result!.msg} !!",
                                                 toastLength: Toast.LENGTH_LONG,
                                                 gravity: ToastGravity.CENTER,
                                                 timeInSecForIosWeb: 1,
                                                 backgroundColor: Color(0xff253e44),
                                                 textColor: Colors.white,
                                                 fontSize: 16.0);
                                           }
                                         });
                                       }
                                       // Navigator.pop(context);
                                     },
                                     child: Container(
                                       decoration: BoxDecoration(
                                           color: const Color(0xff6ed1ec),
                                           borderRadius: BorderRadius.circular(16)),
                                       height: 40,
                                       width: 100.w,
                                       child:  Center(
                                         child: Text(
                                           'map_with_address_addAddress'.tr,
                                           style: TextStyle(
                                               color: Colors.white,
                                               fontFamily: 'montserrat_medium',
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                     ),
                                   );
                                 }
                               })

                              ],
                            )),
                      ),
                    ),
                  ),
                );
              },
            );
          });
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    Completer<GoogleMapController> _mapController = Completer();
    _mapController.complete(controller);
    // _controller.mapController.complete(controller);

    if (_controller.initialCameraPosition.value != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = _controller.initialCameraPosition.value;
      Marker marker = Marker(
        markerId: markerId,
        icon: await BitmapDescriptor.fromAssetImage(const ImageConfiguration(
        ), 'assets/images/location_marker.png'),
        position: position,
        draggable: false,
        //infoWindow: InfoWindow(title: '${_initialCameraPosition!.latitude},${_initialCameraPosition!.longitude}')
      );
      setState(() {
        _controller.markers[markerId] = marker;
      });

      Future.delayed(const Duration(seconds: 1), () async {
        GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );
      });

    }
  }

  String _markerIdVal({bool increment = false}) {
    print('_markerIdVal1111111');
    String val = 'marker_id_${_controller.markerIdCounter}';
    if (increment) _controller.markerIdCounter++;
    return val;
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(
                Icons.arrow_back_ios,
                size: 15,
                color: Colors.black,
              ),
            )),
        onPressed: () {
          Get.find<MapViewController>().valuefirst=false;
          _controller.card1 = false;
          _controller.card2 = false;
          _controller.card3 = false;
          _controller.card4 = false;
          Provider.of<DataListner>(context, listen: false)
              .promoApplyCheck
              .text = '';
          Get.find<MapViewController>().isCheck=null;
          Get.find<MapViewController>().discountUsingPromoCode=0.0;
          Provider.of<DataListner>(context, listen: false).descriptionController.text='';
          _controller.nameController.value.clear();
          _controller.emailController.value.clear();
          _controller.mobileController.value.clear();
          Provider.of<DataListner>(context, listen: false).imageFileList = [];
          Provider.of<DataListner>(context, listen: false).datePickerLocally =
              '';
          Provider.of<DataListner>(context, listen: false)
              .SetDatePickerData('Select Time');
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.view_headline,
                size: 18,
                color: Colors.black,
              )),
          onPressed: () {
            _controller.key.currentState!.openEndDrawer();
          },
        ),
      ],
      backgroundColor: Colors.white60,
      shadowColor: Colors.transparent,
    );
  }
}
