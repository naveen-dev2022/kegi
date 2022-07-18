import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/models/address_list_model.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/resources/api_provider_myprofile.dart';
import 'package:kegi_sudo/screens/drawer_menu/address_screen.dart';
import 'package:kegi_sudo/screens/map_view/location_name.dart';
import 'package:kegi_sudo/screens/map_view/map_view_screen.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../utils/end_drawer.dart';

class MapWithAddress extends StatefulWidget {
  MapWithAddress({Key? key, @required this.pagekey, this.savedData,this.isFromMapViewScreen})
      : super(key: key);

  AddressList? savedData;
  final String? pagekey;
  bool? isFromMapViewScreen;

  @override
  _MapWithAddressState createState() =>
      _MapWithAddressState(pagekey, savedData,isFromMapViewScreen);
}

class _MapWithAddressState extends State<MapWithAddress>
    with TickerProviderStateMixin {
  _MapWithAddressState(this.pagekey, this.savedData,this.isFromMapViewScreen);

  bool? isFromMapViewScreen;
  AddressList? savedData;
  String? pagekey;
  LocationData? _currentPosition;
  Marker? marker;
  Location location = Location();
  Set<Marker> _markers = {};
  GoogleMapController? _controller;
  AnimationController? animationController;
  final Map<MarkerId, Marker> _newMarkers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();
  LatLng? _initialcameraposition;
  StreamSubscription<LocationData>? locationSubscription;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final TextEditingController _newAddressFlatNo = TextEditingController();
  final TextEditingController _newAddressBuilding = TextEditingController();
  final TextEditingController _newAddressStreet = TextEditingController();
  bool home = true;
  bool office = false;
  bool store = false;
  bool other = false;
  String chooseAddressType = 'home';
  String? selectedAddressHeading;
  Uint8List? markerIcon;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final MapViewController _mapViewController =Get.put(MapViewController());
  RxString newAddress=''.obs;
  Locale? locale;

  @override
  void initState() {
    locale=Get.locale;
    if(locale==const Locale('en','US')){
      print('LOCALE----->>>$locale');
      selectedAddressHeading = 'Home';
    }
    else{
      selectedAddressHeading = 'map_with_address_home'.tr;
    }
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    if (pagekey!.contains('NEW ADDRESS')) {
      AppMethods.getBytesFromAsset('assets/images/location_marker.png', 100)
          .then((value) {
        markerIcon = value;
      });
    } else {
      _initialcameraposition = LatLng(double.parse(savedData!.latitude!),
          double.parse(savedData!.longitude!));
      getBytesFromAsset('assets/images/location_marker.png', 100).then((value) {
        markerIcon = value;
        locationSubscription =
            location.onLocationChanged.listen((LocationData currentLocation) {
          _controller!
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(double.parse(savedData!.latitude!),
                double.parse(savedData!.longitude!)),
            zoom: 17.0,
          )));
          setState(() {
            _markers.add(
              Marker(
                visible: true,
                icon: BitmapDescriptor.fromBytes(markerIcon!),
                markerId: const MarkerId('location_info'),
                position: LatLng(double.parse(savedData!.latitude!),
                    double.parse(savedData!.longitude!)),
                onTap: () {},
              ),
            );
            _customInfoWindowController.addInfoWindow!(
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Your Location',
                                    style: TextStyle(fontSize: 10),
                                  )),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '${savedData!.flatNo}, ${savedData!.buildingName}, ${savedData!.streetName}\n ${savedData!.countryId}',
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
                LatLng(double.parse(savedData!.latitude!),
                    double.parse(savedData!.longitude!)));
          });
        });
      });
    }
    super.initState();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void toastMsg(String? value) {
    Fluttertoast.showToast(
        msg: "${value!} !!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff253e44),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void dispose() {
    _controller?.dispose();
    animationController!.dispose();
    locationSubscription?.cancel();
    _customInfoWindowController.dispose();
    super.dispose();
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
                                  hintText: 'map_with_address_flat'.tr,
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
                                  hintText: 'map_with_address_street'.tr,
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
                            TextButton(
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
                                  MyProfileApiProvider myProfileApiProvider =
                                  MyProfileApiProvider();
                                  myProfileApiProvider
                                      .fetchAddAddressApi(
                                      chooseAddressType,
                                      _newAddressFlatNo.text,
                                      _newAddressBuilding.text,
                                      _newAddressStreet.text,
                                      _latitude!,
                                      _longitude!)
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
                                      if(isFromMapViewScreen??false){
                                        int count = 0;
                                        Navigator.popUntil(context, (route) {
                                          return count++ == 2;
                                        });
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MapViewScreen(
                                          preloadData: Get.find<MapViewController>().preloadData.value,
                                          mainId:  Get.find<MapViewController>().mainId.value,
                                          pageKey: '',
                                          isFromMapViewScreen:isFromMapViewScreen,
                                          nearby_placelat:_latitude!,
                                          nearby_placelng:_longitude,
                                        )));
                                      }else{
                                        int count = 0;
                                        Navigator.popUntil(context, (route) {
                                          return count++ == 2;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    AddressScreen()));
                                      }
                                    } else {
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
                            ),
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

  clearProviderData() {
    Navigator.pop(context);
  }

  double? _latitude;
  double? _longitude;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return clearProviderData();
      },
      child: Scaffold(
        key: _mapViewController.key,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                    color: Colors.black,
                  ),
                )),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            pagekey!.contains('NEW ADDRESS')
                ? const SizedBox()
                : IconButton(
                    icon: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Image.asset('assets/images/delete.png'),
                        )),
                    onPressed: () {


                      MyProfileApiProvider myProfileApiProvider =
                          MyProfileApiProvider();

                      myProfileApiProvider
                          .fetchDeleteAddressApi(savedData!.addressId!)
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
                          int count = 0;
                          Navigator.popUntil(context, (route) {
                            return count++ == 1;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AddressScreen()));
                        } else {
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
                      // Navigator.pop(context);
                    },
                  )
          ],
          backgroundColor: Colors.white60,
          shadowColor: Colors.transparent,
        ),
        body: pagekey!.contains('NEW ADDRESS')
            ? Stack(
                children: [
                  GoogleMap(
                    markers: Set<Marker>.of(_mapViewController.markers.values),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _mapViewController.initialCameraPosition.value,
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                    onCameraIdle: () async {
                      print(
                          'New Location:: ${_mapViewController.newLocation}  => ${await AppMethods.getLocalityFullAddressFromLatLong(_mapViewController.newLocation.value.latitude, _mapViewController.newLocation.value.longitude)}');
                      _latitude=_mapViewController.newLocation.value.latitude;
                      _longitude=_mapViewController.newLocation.value.longitude;
                      newAddress.value=await AppMethods.getLocalityFullAddressFromLatLong(_mapViewController.newLocation.value.latitude, _mapViewController.newLocation.value.longitude);
                      _newAddressStreet.text="${_mapViewController.street!.value},${_mapViewController.subLocality!.value}";
                    },
                    //onCameraMove: (_position)=>_updatePosition(_position),
                    onCameraMove: (CameraPosition position) {
                      _mapViewController.newLocation.value = position.target;
                      if (_mapViewController.markers.isNotEmpty) {
                        MarkerId markerId = MarkerId(_markerIdVal());
                        Marker? marker = _mapViewController.markers[markerId];
                        Marker updatedMarker = marker!.copyWith(
                          positionParam: position.target,
                        );
                        setState(() {
                          _mapViewController.markers[markerId] = updatedMarker;
                        });
                      }
                    },
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 75,
                    width: 150,
                    offset: 50,
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
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Icon(Icons.location_on,color: Color(0xff3772A3)),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Obx((){
                                      return SizedBox(
                                        width: 80.w,
                                        child: Text(newAddress.value,overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize:14,fontFamily:'montserrat_medium' ),),
                                      );
                                    })
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                TextButton(
                                  onPressed: () {
                                    bottomSheetFillAddress();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xff6ed1ec),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    height: 40,
                                    width: 100.w,
                                    child:  Center(
                                      child: Text(
                                        'map_with_address_button'.tr,
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
              )
            : Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: _initialcameraposition!, zoom: 17.0),
                    onMapCreated: (GoogleMapController controller) {
                      _customInfoWindowController.googleMapController =
                          controller;
                      _controller = controller;
                    },
                    onTap: (position) {
                      // _customInfoWindowController.hideInfoWindow!();
                    },
                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                    markers: _markers,
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 75,
                    width: 150,
                    offset: 50,
                  ),
                ],
              ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapViewController.mapController.complete(controller);

    if (_mapViewController.initialCameraPosition != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = _mapViewController.initialCameraPosition.value;
      Marker marker = Marker(
        markerId: markerId,
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/location_marker.png'),
        position: position,
        draggable: false,
        //infoWindow: InfoWindow(title: '${_initialCameraPosition!.latitude},${_initialCameraPosition!.longitude}')
      );
      setState(() {
        _mapViewController.markers[markerId] = marker;
      });

      print('Marker Position:: $position');
      Future.delayed(const Duration(seconds: 1), () async {
        GoogleMapController controller =
            await _mapViewController.mapController.future;
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
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }
}
