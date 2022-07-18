import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kegi_sudo/blocs/authentication/authentication_bloc.dart';
import 'package:kegi_sudo/blocs/authentication/authentication_event.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/models/preload_model.dart';
import 'package:kegi_sudo/models/promocode_model.dart';
import 'package:kegi_sudo/models/timesheet_model.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/resources/api_provider_preload.dart';
import 'package:kegi_sudo/resources/network_helper.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/screens/drawer_menu/contactus.dart';
import 'package:kegi_sudo/screens/drawer_menu/refer_earn.dart';
import 'package:kegi_sudo/screens/language_screen.dart';
import 'package:kegi_sudo/screens/mainscreen.dart';
import 'package:kegi_sudo/screens/map_view/location_name.dart';
import 'package:kegi_sudo/screens/map_view/search_nearbyplaces.dart';
import 'package:kegi_sudo/screens/webview_screen.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:kegi_sudo/widgets/discount_builder/map_view_discount_builder.dart';
import 'package:kegi_sudo/widgets/time_sheet_builder/time_sheet_builder.dart';
import 'package:kegi_sudo/widgets/time_sheet_builder/view_more_timesheet_builder.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:xml/xml.dart';
import '../../utils/end_drawer.dart';

class MapView extends StatefulWidget {
  MapView(
      {Key? key,
      this.lat,
      this.lag,
      @required this.pageKey,
      this.isNotfFromSearch,
      this.mainId,
      this.preloadData})
      : super(key: key);

  int? mainId;
  PreloadModel? preloadData;
  final double? lat;
  final double? lag;
  final String? pageKey;
  final bool? isNotfFromSearch;

  @override
  _MapViewState createState() => _MapViewState(
        lat,
        lag,
        pageKey,
        isNotfFromSearch,
        mainId,
        preloadData,
      );
}

class _MapViewState extends State<MapView> {
  _MapViewState(
    this.lat,
    this.lag,
    this.pageKey,
    this.isNotfFromSearch,
    this.mainId,
    this.preloadData,
  );

  MapViewController mapViewController = Get.put(MapViewController());
  int? mainId;
  PreloadModel? preloadData;
  bool? isNotfFromSearch;
  String? pageKey;
  double? lat;
  double? lag;
  LocationData? _currentPosition;
  Marker? marker;
  Location location = Location();
  Set<Marker> _markers = {};
  GoogleMapController? _controller;

  final Map<MarkerId, Marker> _newMarkers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();
  LatLng? _initialcameraposition;

  //LatLng _initialcameraposition = const LatLng(22.6152902, 72.9202106);
  //LatLng _initialcameraposition = const LatLng(37.785834, -122.406417);
  StreamSubscription<LocationData>? locationSubscription;
  SharedPreference sharedPreference = SharedPreference();
  FindLocationName findLocationName = FindLocationName();
  TextEditingController promoCodeApplyController = TextEditingController();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Uint8List? markerIcon;
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  final _dayNameFormatter = DateFormat('EEE');
  DateTime now = DateTime.now();
  List<bool>? updatedTimeColor1 = [];
  List<bool>? updatedTimeColor2 = [];
  List<bool>? updatedTimeColor3 = [];
  List<bool>? updatedTimeColor4 = [];
  List<bool>? updatedTimeColor5 = [];
  List<bool>? updatedTimeColor6 = [];
  List<bool>? updatedTimeColor7 = [];
  String? timeSheet;
  String? countryCode = '+971';
  bool isSelected = false;
  bool card1 = false;
  bool card2 = false;
  bool card3 = false;
  bool card4 = false;
  ImagePicker picker = ImagePicker();
  Repository repository = Repository();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  HomeBloc homeBloc = HomeBloc();
  HomeBloc homeBlocTime1 = HomeBloc();
  HomeBloc homeBlocTime2 = HomeBloc();
  HomeBloc homeBlocTime3 = HomeBloc();
  HomeBloc homeBlocTime4 = HomeBloc();
  HomeBloc homeBlocTime5 = HomeBloc();
  HomeBloc homeBlocTime6 = HomeBloc();
  HomeBloc homeBlocTime7 = HomeBloc();
  String? service_type;
  double? amount;
  TextEditingController descriptionController = TextEditingController();
  bool valuefirst = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool? isCheck;
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';
  bool showExtraTime = false;
  String? deviceId;
  var _url = '';

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (_initialcameraposition.isNull) {
      print('CAMERA POSITION NULL');
    } else {
      print('CAMERA POSITION NOT NULL');
    }
    Position position = await AppMethods.getGeoLocationPosition();
    mapViewController.pointLocation!.value =
        await AppMethods.getLocalityCountryFromLatLong(position);
    _initialcameraposition = LatLng(position.latitude, position.longitude);
    ;
    print(
        'LOCATION POSITION:: ${mapViewController.pointLocation!.value} $_initialcameraposition :: ${position.latitude} : ${position.longitude}');
    if (pageKey!.contains('SERVICE_SCREEN')) {
      _modalBottomSheetMenu();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    timeSheet = 'timesheet_heading'.tr;
    homeBlocTime1.fetchTimeSheetBloc(mainId,
        DateFormat('M/d/y').format(_currentDate.add(const Duration(days: 0))));
    homeBlocTime2.fetchTimeSheetBloc(mainId,
        DateFormat('M/d/y').format(_currentDate.add(const Duration(days: 1))));
    homeBlocTime3.fetchTimeSheetBloc(mainId,
        DateFormat('M/d/y').format(_currentDate.add(const Duration(days: 2))));
    homeBlocTime4.fetchTimeSheetBloc(mainId,
        DateFormat('M/d/y').format(_currentDate.add(const Duration(days: 3))));
    homeBlocTime5.fetchTimeSheetBloc(mainId,
        DateFormat('M/d/y').format(_currentDate.add(const Duration(days: 4))));
    homeBlocTime6.fetchTimeSheetBloc(mainId,
        DateFormat('M/d/y').format(_currentDate.add(const Duration(days: 5))));
    homeBlocTime7.fetchTimeSheetBloc(mainId,
        DateFormat('M/d/y').format(_currentDate.add(const Duration(days: 6))));
    //Image.asset('assets/images/location_marker.png',height: 70,width: 50,);
    AppMethods.getBytesFromAsset('assets/images/location_marker.png', 100)
        .then((value) {
      markerIcon = value;
    });
    if (isNotfFromSearch!) {
      getLoc();
    } else {
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        print(
            "********${currentLocation.longitude} : ${currentLocation.longitude}");
        _controller
            ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lat!, lag!),
          zoom: 11.5,
        )));
        setState(() {
          _currentPosition = currentLocation;
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
                          const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Your Location',
                                style: TextStyle(fontSize: 10),
                              )),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            Provider.of<DataListner>(context, listen: false)
                                .vicinity!,
                            maxLines: 3,
                            style: const TextStyle(
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
            LatLng(lat!, lag!),
          );
          _initialcameraposition = LatLng(lat!, lag!);
          sharedPreference.setLatitude(lat!);
          sharedPreference.setLongitude(lag!);
          _markers.add(
            Marker(
              visible: true,
              icon: BitmapDescriptor.fromBytes(markerIcon!),
              markerId: const MarkerId('location_info'),
              position: LatLng(lat!, lag!),
              onTap: () {
                print('@@@@@@@@@@@@@@@@');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SearchNearByPlaces(
                        lat: lat,
                        lang: lag,
                        pageKey: pageKey,
                      ),
                    ));
              },
            ),
          );
        });
      });
    }
    _determinePosition();
    _getId().then((value) {
      setState(() {
        deviceId = value;
        print('((((((((((($deviceId');
      });
    });
    super.initState();
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor!; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId!; // unique ID on Android
    }
  }

  void pay(XmlDocument xml) async {
    NetworkHelper _networkHelper = NetworkHelper();
    var response = await _networkHelper.pay(xml);
    print('response------$response');
    if (response == 'failed' || response == null) {
      // failed
      alertShow('Failed');
    } else {
      final doc = XmlDocument.parse(response);
      final url = doc.findAllElements('start').map((node) => node.text);
      final code = doc.findAllElements('code').map((node) => node.text);
      print(url);
      _url = url.toString();
      String _code = code.toString();
      if (_url.length > 2) {
        _url = _url.replaceAll('(', '');
        _url = _url.replaceAll(')', '');
        _code = _code.replaceAll('(', '');
        _code = _code.replaceAll(')', '');
        _launchURL(_url, _code);
      }
      print(_url);
      final message = doc.findAllElements('message').map((node) => node.text);
      print('Message =  $message');
      if (message.toString().length > 2) {
        String msg = message.toString();
        msg = msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        alertShow(msg);
      }
    }
  }

  void alertShow(String text) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
        // content: Text('$text Please try again.'),
        actions: <Widget>[
          BasicDialogAction(
              title: const Text('Ok'),
              onPressed: () {
                setState(() {
                  // _showLoader = false;
                });
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  //methods and on clicks

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    await Geolocator.getCurrentPosition().then((position) {
      //_saveCurrentLocation(position);
      _changeMapCamera(position);
      //_changeAddress(position);
    }).catchError((error) {
      //AppWidgets.showErrorMessage('Location services are disabled.');
      //_goToHomeScreen();
    });
  }

  _changeMapCamera(Position position) {
    _initialcameraposition = LatLng(position.latitude, position.longitude);

    var newPosition = CameraPosition(target: _initialcameraposition!, zoom: 16);
    CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);
    CameraUpdate zoom = CameraUpdate.zoomTo(16);
    print('NEW POSITION:: $newPosition');

    _controller?.animateCamera(update);
  }

  void _launchURL(String url, String code) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WebViewScreen(
                  mainId: mainId,
                  service_type: service_type,
                  descriptionController: descriptionController.text,
                  valuefirst: valuefirst,
                  nameController: nameController.text,
                  emailController: emailController.text,
                  mobileController: mobileController.text,
                  url: url,
                  code: code,
                )));
  }

  void tlerPaymentBlock() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('mobile', nest: () {
      builder.element('store', nest: () {
        builder.text('25927');
      });
      builder.element('key', nest: () {
        builder.text('46MfZ^82XG-2bTFD');
      });

      builder.element('device', nest: () {
        builder.element('type', nest: () {
          builder.text('android');
        });
        builder.element('id', nest: () {
          builder.text('$deviceId');
        });
      });

      // app
      builder.element('app', nest: () {
        builder.element('name', nest: () {
          builder.text('Telr');
        });
        builder.element('version', nest: () {
          builder.text('1.1.6');
        });
        builder.element('user', nest: () {
          builder.text('2');
        });
        builder.element('id', nest: () {
          builder.text('123');
        });
      });

      //tran
      builder.element('tran', nest: () {
        builder.element('test', nest: () {
          builder.text('1');
        });
        builder.element('type', nest: () {
          builder.text('auth');
        });
        builder.element('class', nest: () {
          builder.text('paypage');
        });
        builder.element('cartid', nest: () {
          builder.text(100000000 + Random().nextInt(999999999));
        });
        builder.element('description', nest: () {
          builder.text('Test for Mobile API order');
        });
        builder.element('currency', nest: () {
          builder.text('aed');
        });
        builder.element('amount', nest: () {
          builder.text(amount!);
        });
        builder.element('language', nest: () {
          builder.text('en');
        });
        builder.element('firstref', nest: () {
          builder.text('first');
        });
        builder.element('ref', nest: () {
          builder.text('null');
        });
      });

      //billing
      builder.element('billing', nest: () {
        // name
        builder.element('name', nest: () {
          builder.element('title', nest: () {
            builder.text('naveen');
          });
          builder.element('first', nest: () {
            builder.text('Div');
          });
          builder.element('last', nest: () {
            builder.text('V');
          });
        });
        // address
        builder.element('address', nest: () {
          builder.element('line1', nest: () {
            builder.text('Dubai');
          });
          builder.element('city', nest: () {
            builder.text('Dubai');
          });
          builder.element('region', nest: () {
            builder.text('');
          });
          builder.element('country', nest: () {
            builder.text('AE');
          });
        });

        builder.element('phone', nest: () {
          builder.text('551188269');
        });
        builder.element('email', nest: () {
          builder.text('hitesh@kedarengg.com');
        });
      });
    });

    final bookshelfXml = builder.buildDocument();
    // print(bookshelfXml);
    pay(bookshelfXml);
  }

  void _getFromGallery() async {
    await picker.pickMultiImage().then((value) {
      setState(() {
        Provider.of<DataListner>(context, listen: false)
            .SetImageDataFromGallery(value!);
      });
    });
  }

  void _getFromCamera() async {
    await picker.pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        Provider.of<DataListner>(context, listen: false)
            .SetImageDataFromCamera(value!);
      });
    });
  }

  void _modalBottomSheetImagePicker() {
    showModalBottomSheet(
        backgroundColor: const Color(0xFFD7D7D7),
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () {
                      _getFromCamera();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: 100.w,
                      child: const Center(
                        child: Text(
                          'Take Photo or Video',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xff0092CC),
                            fontFamily: 'montserrat_medium',
                          ),
                        ),
                      ),
                    )),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                ),
                GestureDetector(
                    onTap: () {
                      _getFromGallery();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100.w,
                      height: 45,
                      child: const Center(
                        child: Text(
                          'Photo/Video Library',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff0092CC),
                            fontSize: 17,
                            fontFamily: 'montserrat_medium',
                          ),
                        ),
                      ),
                    )),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                ),
                GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 45,
                      width: 100.w,
                      child: const Center(
                        child: Text(
                          'Share Document',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff0092CC),
                            fontSize: 17,
                            fontFamily: 'montserrat_medium',
                          ),
                        ),
                      ),
                    )),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    height: 45,
                    width: 100.w,
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xff0092CC),
                          fontSize: 16,
                          fontFamily: 'montserrat_bold',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMenu() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isDismissible: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          builder: (builder) {
            return StatefulBuilder(builder: (BuildContext context, setter) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          'discription_of_problem'.tr,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat_bold'),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6)),
                          child: TextField(
                            maxLines: 5,
                            minLines: 5,
                            controller: descriptionController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 10),
                                border: InputBorder.none,
                                hintText: 'problem_hint'.tr,
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                )),
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          _modalBottomSheetImagePicker();
                        },
                        child: Container(
                            height: 75,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(0xF8D5F0F8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Consumer<DataListner>(
                              builder: (BuildContext context,
                                  DataListner dataListner, Widget? child) {
                                if (dataListner.imageFileList!.isNotEmpty) {
                                  return Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2, top: 2, bottom: 2),
                                        child: SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: Image.asset(
                                                'assets/images/camera.png')),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: dataListner
                                                .imageFileList!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: 60,
                                                      width: 60,
                                                      child: Image.file(
                                                        File(dataListner
                                                            .imageFileList![
                                                                index]
                                                            .path),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: 2,
                                                        right: 2,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setter(() {
                                                                dataListner
                                                                    .imageFileList!
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            },
                                                            child: const Icon(
                                                              Icons
                                                                  .delete_forever_outlined,
                                                              size: 18,
                                                              color:
                                                                  Colors.white,
                                                            )))
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/camera.png'),
                                      const Text(
                                        'Upload image/video',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  );
                                }
                              },
                            )),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          'confirm_location_heading'.tr,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat_bold'),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        height: 80,
                        width: 100.w,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6)),
                        child: Consumer<DataListner>(
                          builder: (BuildContext context,
                                  DataListner dataListner, Widget? child) =>
                              ListTile(
                            onTap: () {
                              if (_currentPosition == null) {
                                getLoc();
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SearchNearByPlaces(
                                              lat: _currentPosition!.latitude,
                                              lang: _currentPosition!.longitude,
                                              pageKey: pageKey,
                                            )));
                              }
                            },
                            title: Text(
                              /*dataListner.locationName == null
                                  ? */
                              mapViewController.pointLocation!.value,
                              //: dataListner.locationName!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              /*dataListner.vicinity == null
                                  ? */
                              mapViewController.pointLocation!.value,
                              //  : dataListner.vicinity!,
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing:
                                const Icon(Icons.favorite_border_outlined),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextButton(
                        onPressed: () {
                          if (descriptionController.text.isEmpty) {
                            toastMsg('Description Cannot be Empty');
                          }
                          /*
                          else if(Provider.of<DataListner>(context, listen: false).imageFileList!.isEmpty){
                            toastMsg('Please select photos');
                          }*/
                          else {
                            _modalBottomSheetProceed();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff6ed1ec),
                              borderRadius: BorderRadius.circular(16)),
                          height: 40,
                          width: 100.w,
                          child: Center(
                            child: Text(
                              'proceed_button'.tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'montserrat_medium',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          });
    });
  }

  Future<void> _modalPointLocationAddress(String address) async {
    print('SHOW BOTTOM MODEL SHEET');
    mapViewController.isOpenUpdatedModel!.value = true;
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (BuildContext context, setter) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(address),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextButton(
                    onPressed: () {
                      /*Navigator.of(context).pop();
                          setState(() {
                            isOpenUpdatedModel=false;
                          });*/
                      print('Add Address click!!');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff6ed1ec),
                          borderRadius: BorderRadius.circular(16)),
                      height: 40,
                      width: 100.w,
                      child: const Center(
                        child: Text(
                          'Enter complete address',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'montserrat_medium',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
    /*future.then((value) {
        isOpenUpdatedModel = false;
        setState(() {

        });
      });*/
  }

  Future<void> _modalCompleteAddress(LatLng position) async {
    String location = await AppMethods.getLocalityCountryFromLatLong1(
        position.latitude, position.longitude);
    print('SHOW BOTTOM MODEL SHEET');
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (BuildContext context, setter) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(location),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextButton(
                    onPressed: () {
                      /*Navigator.of(context).pop();
                          setState(() {
                            isOpenUpdatedModel=false;
                          });*/
                      print('Add Address click!!');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff6ed1ec),
                          borderRadius: BorderRadius.circular(16)),
                      height: 40,
                      width: 100.w,
                      child: const Center(
                        child: Text(
                          'Enter complete address',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'montserrat_medium',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
    /*future.then((value) {
        isOpenUpdatedModel = false;
        setState(() {

        });
      });*/
  }

  void startInputAction(BuildContext context) {
    print('SOMETHING OPEN!!!');
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 200,
            padding: EdgeInsets.all(10),
            child: Text("Something"),
          );
        });
  }

  void _modalBottomSheetProceed() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          backgroundColor: Colors.grey.shade200,
          isDismissible: true,
          isScrollControlled: true,
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
                return Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: SizedBox(
                            width: 100.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select_visit_heading'.tr,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'montserrat_bold'),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _modalBottomSheetTime();
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.history_toggle_off,
                                        size: 12,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Consumer<DataListner>(
                                        builder: (BuildContext context,
                                                DataListner dataListner,
                                                Widget? child) =>
                                            Text(dataListner.datePicker),
                                      ),
                                      const Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            setter(() {
                              card1 = true;
                              card2 = false;
                              card3 = false;
                              card4 = false;
                              service_type = preloadData!
                                  .result!.serviceType![0]
                                  .toJson()
                                  .keys
                                  .elementAt(0);

                              double discount = ((preloadData!
                                          .result!.paymentDetails![1].amount!) *
                                      (preloadData!
                                          .result!.paymentDetails![1].vat!)) /
                                  100;
                              amount = discount +
                                  preloadData!
                                      .result!.paymentDetails![1].amount!;
                              print('amount#####---$amount');
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: card1
                                            ? Colors.blue
                                            : Colors.transparent)),
                                height: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                preloadData!
                                                    .result!
                                                    .serviceType![0]
                                                    .expertVisitReq!,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff0092CC),
                                                    fontFamily:
                                                        'montserrat_medium',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12),
                                              child: Text(
                                                  'Expert/specialist_subtitle'
                                                      .tr,
                                                  style: const TextStyle(
                                                      fontSize: 9,
                                                      fontFamily:
                                                          'montserrat_medium')),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12),
                                              child: Text(
                                                  'AED ${preloadData!.result!.paymentDetails![1].amount}',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontFamily:
                                                          'montserrat_bold')),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Text('per_hour',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      fontFamily:
                                                          'montserrat_medium',
                                                      color: Colors.grey)),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 12),
                                              child: Text('AED 50',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontFamily:
                                                          'montserrat_bold')),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 14),
                                              child: Text('additional_hour'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 9,
                                                      fontFamily:
                                                          'montserrat_medium',
                                                      color: Colors.grey)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            setter(() {
                              card1 = false;
                              card2 = true;
                              card3 = false;
                              card4 = false;
                              service_type = preloadData!
                                  .result!.serviceType![1]
                                  .toJson()
                                  .keys
                                  .elementAt(1);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: card2
                                            ? Colors.blue
                                            : Colors.transparent)),
                                height: 80,
                                child: ListTile(
                                  title: Text(
                                    preloadData!.result!.serviceType![1]
                                        .iKnowWhatIssue!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff0092CC),
                                        fontFamily: 'montserrat_medium',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('know_issue_subtitle'.tr,
                                      style: const TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'montserrat_medium')),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            setter(() {
                              card1 = false;
                              card2 = false;
                              card3 = true;
                              card4 = false;
                              service_type = preloadData!
                                  .result!.serviceType![2]
                                  .toJson()
                                  .keys
                                  .elementAt(2);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: card3
                                            ? Colors.blue
                                            : Colors.transparent)),
                                height: 80,
                                child: ListTile(
                                  title: Text(
                                    preloadData!
                                        .result!.serviceType![2].assistance!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff0092CC),
                                        fontFamily: 'montserrat_medium',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'assistance_needed_subtitle'.tr,
                                      style: const TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'montserrat_medium')),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            setter(() {
                              card1 = false;
                              card2 = false;
                              card3 = false;
                              card4 = true;
                              service_type = preloadData!
                                  .result!.serviceType![3]
                                  .toJson()
                                  .keys
                                  .elementAt(3);
                              double discount = ((preloadData!
                                          .result!.paymentDetails![0].amount!) *
                                      (preloadData!
                                          .result!.paymentDetails![0].vat!)) /
                                  100;
                              amount = discount +
                                  preloadData!
                                      .result!.paymentDetails![0].amount!;
                              print('amount#####---$amount');
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: card4
                                            ? Colors.blue
                                            : Colors.transparent)),
                                height: 80,
                                child: ListTile(
                                  title: Text(
                                    preloadData!
                                        .result!.serviceType![3].emergency!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff0092CC),
                                        fontFamily: 'montserrat_medium',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'emergency_service_subtitle'.tr,
                                      style: const TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'montserrat_medium')),
                                  trailing: Column(
                                    children: [
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                            'AED ${preloadData!.result!.paymentDetails![0].amount}',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'montserrat_bold')),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text('surcharge'.tr,
                                            style: const TextStyle(
                                                fontSize: 9,
                                                fontFamily: 'montserrat_medium',
                                                color: Colors.grey)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: SizedBox(
                            height: 80,
                            child: ListTile(
                              title: Text(
                                'Point_contact'.tr,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Point_contact_subtitle'.tr,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'montserrat_medium')),
                              trailing: /*IconButton(
                                  icon: const Icon(Icons.check_box_outlined),
                                  onPressed: () {
                                    _modalBottomContact();
                                  },
                                )*/
                                  Checkbox(
                                checkColor: Colors.greenAccent,
                                activeColor: Colors.red,
                                value: valuefirst,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _modalBottomContact();
                                    }
                                    valuefirst = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        (card1 == true ||
                                card2 == true ||
                                card3 == true ||
                                card4 == true)
                            ? Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        topLeft: Radius.circular(16))),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        (service_type!.contains(
                                                    'expert_visit_req') ||
                                                service_type!
                                                    .contains('emergency'))
                                            ? GestureDetector(
                                                onTap: () {
                                                  _modalBottomPayment();
                                                },
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Icon(
                                                      Icons.attach_money,
                                                      size: 12,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Obx(
                                                      () => Text(
                                                        mapViewController
                                                                    .paymentMode
                                                                    .value ==
                                                                1
                                                            ? 'card_payment'.tr
                                                            : 'cash_payment'.tr,
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'montserrat_medium'),
                                                      ),
                                                    ),
                                                    const Icon(
                                                        Icons.arrow_drop_down)
                                                  ],
                                                ))
                                            : const SizedBox(),
                                        (service_type!.contains(
                                                    'expert_visit_req') ||
                                                service_type!
                                                    .contains('emergency'))
                                            ? GestureDetector(
                                                onTap: () {
                                                  homeBloc.fetchPromoCodeBloc();
                                                  homeBloc.fetchPromoCodeBloc();
                                                  _modalBottomDiscount();
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.cancel_outlined,
                                                      size: 12,
                                                      color: Colors.blue,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'discount'.tr,
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          fontFamily:
                                                              'montserrat_medium'),
                                                    ),
                                                    const Icon(
                                                        Icons.arrow_drop_down)
                                                  ],
                                                ))
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (Provider.of<DataListner>(context,
                                                    listen: false)
                                                .datePicker ==
                                            'Select Time') {
                                          toastMsg('Please select time slot');
                                        } else {
                                          tlerPaymentBlock();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff6ed1ec),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        height: 40,
                                        width: 100.w,
                                        child: const Center(
                                          child: Text(
                                            "LET'S KEGI",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'montserrat_medium',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        topLeft: Radius.circular(16))),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              children: const [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.attach_money,
                                                  size: 12,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'Cash Payment',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'montserrat_medium'),
                                                ),
                                                Icon(Icons.arrow_drop_down)
                                              ],
                                            )),
                                        GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.cancel_outlined,
                                                  size: 12,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'Discount',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontFamily:
                                                          'montserrat_medium'),
                                                ),
                                                Icon(Icons.arrow_drop_down)
                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xffc8f0f8),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        height: 40,
                                        width: 100.w,
                                        child: const Center(
                                          child: Text(
                                            "LET'S KEGI",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'montserrat_medium',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                );
              },
            );
          });
    });
  }

  void _modalBottomSheetTimeViewMore() {
    showModalBottomSheet(
        backgroundColor: Colors.grey.shade200,
        isDismissible: true,
        isScrollControlled: true,
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
              return Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 12, right: 12),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (value) {

                        },
                        initialDateTime: DateTime.now(),
                      ),
                       DateTimePicker(
                        type: DateTimePickerType.date,
                        // dateMask: 'yyyy/MM/dd',
                        // controller: _controller2,
                        initialValue: '${DateTime.now()}',
                        locale: const Locale('en', 'US'),
                        //  initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'Date',
                        onChanged: (val) {
                          print('val^^^^^^^^^^^^^----${val.lastChars(2)}');
                          Provider.of<DataListner>(context,
                              listen: false).setSelectedDay(val.lastChars(2)); // )
                          //  print('val1111111^^^^^^^^^^^^^----${DateFormat('y/M/d').format(DateTime(int.parse(val)))}');
                          homeBloc.fetchTimeSheetBloc(mainId,
                              val);
                          setter(() {
                            showExtraTime=true;
                          });
                        },
                        validator: (val) {
                          print('###########---------validator');
                          setter(() => _valueToValidate2 = val ?? '');
                          return null;
                        },
                        onSaved: (val) {
                          print('###########---------onSaved');
                          setter(() => _valueSaved2 = val ?? '');
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      showExtraTime
                          ? SizedBox(
                              height: 25,
                              width: double.infinity,
                              child: Text(
                                '${_dayNameFormatter.format(_currentDate.add(Duration(days: (int.parse(Provider.of<DataListner>(context, listen: false).selectedDay!)) - (DateTime.now().day))))}, ${_monthFormatter.format(_currentDate.add(Duration(days: (int.parse(Provider.of<DataListner>(context, listen: false).selectedDay!)) - (DateTime.now().day))))} ${_dayFormatter.format(_currentDate.add(Duration(days: (int.parse(Provider.of<DataListner>(context, listen: false).selectedDay!)) - (DateTime.now().day))))}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'montserrat_medium'),
                              ))
                          : const SizedBox(),
                      const SizedBox(
                        height: 6,
                      ),
                      StreamBuilder<TimeSheetModel>(
                          stream: homeBloc.allTimeSheetData,
                          builder: (BuildContext context,
                              AsyncSnapshot<TimeSheetModel> snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ViewMoreTimeSheetBuilder(
                                      data: snapshot.data, setter: setter));
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else {
                              return const SizedBox();
                            }
                          }),
                      const SizedBox(
                        height: 12,
                      ),
                      showExtraTime
                          ? Container(
                              height: 10.h,
                              width: 100.w,
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    Provider.of<DataListner>(context,
                                            listen: false)
                                        .SetDatePickerData(
                                            Provider.of<DataListner>(context,
                                                    listen: false)
                                                .datePickerLocally);
                                    for (int i = 0; i < 2; i++) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff6ed1ec),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    height: 40,
                                    width: 90.w,
                                    child: const Center(
                                      child: Text(
                                        'SELECT DATES',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'montserrat_medium',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void _modalBottomSheetTime() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
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
              builder: (BuildContext contex, setter) {
                return FractionallySizedBox(
                  heightFactor: 1.0,
                  child: Container(
                      color: Colors.transparent,
                      //could change this to Color(0xFF737373),
                      //so you don't have to change MaterialApp canvasColor
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                          height: 25,
                                          width: double.infinity,
                                          child: Text(
                                            '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 0)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 0)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 0)))}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'montserrat_medium'),
                                          )),
                                      StreamBuilder<TimeSheetModel>(
                                          stream:
                                              homeBlocTime1.allTimeSheetData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<TimeSheetModel>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return TimeSheetBuilder(
                                                data: snapshot.data,
                                                setter: setter,
                                                updatedTimeColor1:
                                                    updatedTimeColor1,
                                                updatedTimeColor2:
                                                    updatedTimeColor2,
                                                updatedTimeColor3:
                                                    updatedTimeColor3,
                                                updatedTimeColor4:
                                                    updatedTimeColor4,
                                                updatedTimeColor5:
                                                    updatedTimeColor5,
                                                updatedTimeColor6:
                                                    updatedTimeColor6,
                                                updatedTimeColor7:
                                                    updatedTimeColor7,
                                                day: 1,
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),
                                      const Divider()
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                          height: 25,
                                          width: double.infinity,
                                          child: Text(
                                            '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 1)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 1)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 1)))}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'montserrat_medium'),
                                          )),
                                      StreamBuilder<TimeSheetModel>(
                                          stream:
                                              homeBlocTime2.allTimeSheetData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<TimeSheetModel>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return TimeSheetBuilder(
                                                  data: snapshot.data,
                                                  setter: setter,
                                                  updatedTimeColor1:
                                                      updatedTimeColor1,
                                                  updatedTimeColor2:
                                                      updatedTimeColor2,
                                                  updatedTimeColor3:
                                                      updatedTimeColor3,
                                                  updatedTimeColor4:
                                                      updatedTimeColor4,
                                                  updatedTimeColor5:
                                                      updatedTimeColor5,
                                                  updatedTimeColor6:
                                                      updatedTimeColor6,
                                                  updatedTimeColor7:
                                                      updatedTimeColor7,
                                                  day: 2);
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),
                                      const Divider()
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                          height: 25,
                                          width: double.infinity,
                                          child: Text(
                                            '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 2)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 2)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 2)))}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'montserrat_medium'),
                                          )),
                                      StreamBuilder<TimeSheetModel>(
                                          stream:
                                              homeBlocTime3.allTimeSheetData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<TimeSheetModel>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return TimeSheetBuilder(
                                                  data: snapshot.data,
                                                  setter: setter,
                                                  updatedTimeColor1:
                                                      updatedTimeColor1,
                                                  updatedTimeColor2:
                                                      updatedTimeColor2,
                                                  updatedTimeColor3:
                                                      updatedTimeColor3,
                                                  updatedTimeColor4:
                                                      updatedTimeColor4,
                                                  updatedTimeColor5:
                                                      updatedTimeColor5,
                                                  updatedTimeColor6:
                                                      updatedTimeColor6,
                                                  updatedTimeColor7:
                                                      updatedTimeColor7,
                                                  day: 3);
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),
                                      const Divider()
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                          height: 25,
                                          width: double.infinity,
                                          child: Text(
                                            '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 3)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 3)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 3)))}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'montserrat_medium'),
                                          )),
                                      StreamBuilder<TimeSheetModel>(
                                          stream:
                                              homeBlocTime4.allTimeSheetData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<TimeSheetModel>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return TimeSheetBuilder(
                                                  data: snapshot.data,
                                                  setter: setter,
                                                  updatedTimeColor1:
                                                      updatedTimeColor1,
                                                  updatedTimeColor2:
                                                      updatedTimeColor2,
                                                  updatedTimeColor3:
                                                      updatedTimeColor3,
                                                  updatedTimeColor4:
                                                      updatedTimeColor4,
                                                  updatedTimeColor5:
                                                      updatedTimeColor5,
                                                  updatedTimeColor6:
                                                      updatedTimeColor6,
                                                  updatedTimeColor7:
                                                      updatedTimeColor7,
                                                  day: 4);
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),
                                      const Divider()
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                          height: 25,
                                          width: double.infinity,
                                          child: Text(
                                            '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 4)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 4)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 4)))}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'montserrat_medium'),
                                          )),
                                      StreamBuilder<TimeSheetModel>(
                                          stream:
                                              homeBlocTime5.allTimeSheetData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<TimeSheetModel>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return TimeSheetBuilder(
                                                  data: snapshot.data,
                                                  setter: setter,
                                                  updatedTimeColor1:
                                                      updatedTimeColor1,
                                                  updatedTimeColor2:
                                                      updatedTimeColor2,
                                                  updatedTimeColor3:
                                                      updatedTimeColor3,
                                                  updatedTimeColor4:
                                                      updatedTimeColor4,
                                                  updatedTimeColor5:
                                                      updatedTimeColor5,
                                                  updatedTimeColor6:
                                                      updatedTimeColor6,
                                                  updatedTimeColor7:
                                                      updatedTimeColor7,
                                                  day: 5);
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),
                                      const Divider()
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                          height: 25,
                                          width: double.infinity,
                                          child: Text(
                                            '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 5)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 5)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 5)))}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'montserrat_medium'),
                                          )),
                                      StreamBuilder<TimeSheetModel>(
                                          stream:
                                              homeBlocTime6.allTimeSheetData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<TimeSheetModel>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return TimeSheetBuilder(
                                                  data: snapshot.data,
                                                  setter: setter,
                                                  updatedTimeColor1:
                                                      updatedTimeColor1,
                                                  updatedTimeColor2:
                                                      updatedTimeColor2,
                                                  updatedTimeColor3:
                                                      updatedTimeColor3,
                                                  updatedTimeColor4:
                                                      updatedTimeColor4,
                                                  updatedTimeColor5:
                                                      updatedTimeColor5,
                                                  updatedTimeColor6:
                                                      updatedTimeColor6,
                                                  updatedTimeColor7:
                                                      updatedTimeColor7,
                                                  day: 6);
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),
                                      const Divider()
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                          height: 25,
                                          width: double.infinity,
                                          child: Text(
                                            '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 6)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 6)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 6)))}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'montserrat_medium'),
                                          )),
                                      StreamBuilder<TimeSheetModel>(
                                          stream:
                                              homeBlocTime7.allTimeSheetData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<TimeSheetModel>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return TimeSheetBuilder(
                                                  data: snapshot.data,
                                                  setter: setter,
                                                  updatedTimeColor1:
                                                      updatedTimeColor1,
                                                  updatedTimeColor2:
                                                      updatedTimeColor2,
                                                  updatedTimeColor3:
                                                      updatedTimeColor3,
                                                  updatedTimeColor4:
                                                      updatedTimeColor4,
                                                  updatedTimeColor5:
                                                      updatedTimeColor5,
                                                  updatedTimeColor6:
                                                      updatedTimeColor6,
                                                  updatedTimeColor7:
                                                      updatedTimeColor7,
                                                  day: 7);
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),
                                      const Divider()
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 10.h,
                                width: 100.w,
                                color: Colors.white,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    onPressed: () {
                                      Provider.of<DataListner>(context,
                                              listen: false)
                                          .SetDatePickerData(
                                              Provider.of<DataListner>(context,
                                                      listen: false)
                                                  .datePickerLocally);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff6ed1ec),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      height: 40,
                                      width: 90.w,
                                      child: const Center(
                                        child: Text(
                                          'SELECT DATES',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'montserrat_medium',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              child: Column(
                                children: [
                                  Container(
                                    height: 3.h,
                                    width: 100.w,
                                    color: Colors.white,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 3.5.h,
                                        width: 70.w,
                                        color: Colors.white,
                                        child: const Text(
                                          'Select Date & Time',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontFamily: 'montserrat_bold'),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print('GestureDetector------');
                                          _modalBottomSheetTimeViewMore();
                                        },
                                        child: SizedBox(
                                          height: 3.h,
                                          width: 20.w,
                                          child: Text('View more'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
            );
          });
    });
  }

  void _modalBottomPayment() {
    showModalBottomSheet(
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext, setter) {
            return Wrap(
              children: [
                Container(
                    color: Colors.transparent,
                    //could change this to Color(0xFF737373),
                    //so you don't have to change MaterialApp canvasColor
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                            width: 100.w,
                          ),
                          ListTile(
                            leading: Image.asset('assets/images/visa.png'),
                            title: const Text(
                              'Card Payment',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'montserrat_medium'),
                            ),
                            trailing: Radio(
                              value: 1,
                              groupValue: mapViewController.paymentMode.value,
                              activeColor: const Color(0xff6ed1ec),
                              onChanged: (int? value) {
                                setter(() {
                                  mapViewController.paymentMode.value = value!;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.attach_money),
                            title: const Text(
                              'Cash Payment',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'montserrat_medium'),
                            ),
                            trailing: Radio(
                              value: 2,
                              groupValue: mapViewController.paymentMode.value,
                              activeColor: const Color(0xff6ed1ec),
                              onChanged: (int? value) {
                                setter(() {
                                  mapViewController.paymentMode.value = value!;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const Divider(),
                          /*  ListTile(
                            leading: Image.asset('assets/images/applepay.png'),
                            title: const Text(
                              'Apple Pay',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'montserrat_medium'),
                            ),
                            trailing: Radio(
                              value: 3,
                              groupValue: val,
                              activeColor: const Color(0xff6ed1ec),
                              onChanged: (int? value) {
                                setter(() {
                                  val = value!;
                                });
                              },
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            onTap: () {
                              _modalBottomSheetAddCard();
                            },
                            leading: const Icon(
                              Icons.add,
                              size: 22,
                            ),
                            title: const Text(
                              'Add New Card',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'montserrat_medium'),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 22,
                            ),
                          ),*/
                        ],
                      ),
                    )),
              ],
            );
          });
        });
  }

  void _modalBottomDiscount() {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext, setter) {
              return Container(
                  color: Colors
                      .transparent, //could change this to Color(0xFF737373),
                  //so you don't have to change MaterialApp canvasColor
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 2.h,
                            width: 100.w,
                          ),
                          const SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: Text(
                              'Add Promo',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'montserrat_bold'),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            color: const Color(0xffe7e7e7),
                            height: 40,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              controller: Provider.of<DataListner>(context,
                                      listen: false)
                                  .promoApplyCheck,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'montserrat_Medium'),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: isCheck == null
                                    ? const SizedBox()
                                    : isCheck == true
                                        ? const Icon(
                                            Icons.done,
                                            size: 20,
                                            color: Color(0xff6ed1ec),
                                          )
                                        : const Icon(
                                            Icons.cancel_outlined,
                                            size: 20,
                                            color: Color(0xff6ed1ec),
                                          ),
                                contentPadding: const EdgeInsets.only(top: 5),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: 'Enter your promo code',
                                hintStyle: const TextStyle(
                                    fontFamily: 'montserrat_Medium',
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          TextButton(
                            onPressed: () {
                              print(
                                  '0--------${Provider.of<DataListner>(context, listen: false).promoApplyCheck.value.text}');
                              if (Provider.of<DataListner>(context,
                                      listen: false)
                                  .promoApplyCheck
                                  .value
                                  .text
                                  .isEmpty) {
                                toastMsg('Please apply the promo code');
                              } else {
                                homeBloc
                                    .fetchPromoCodeApplyBloc(
                                        Provider.of<DataListner>(context,
                                                listen: false)
                                            .promoApplyCheck
                                            .value
                                            .text,
                                        service_type!)
                                    .then((value) {
                                  if (value.result!.status == true) {
                                    setter(() {
                                      isCheck = true;
                                    });
                                  } else {
                                    setter(() {
                                      isCheck = false;
                                    });
                                  }
                                });
                              }
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff6ed1ec),
                                  borderRadius: BorderRadius.circular(16)),
                              height: 40,
                              width: 100.w,
                              child: const Center(
                                child: Text(
                                  'ACTIVATE CODE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'montserrat_medium',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Here's some promo codes",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'montserrat_bold'),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          StreamBuilder<PromoCodeModel>(
                              stream: homeBloc.allPromoCodeData,
                              builder: (context,
                                  AsyncSnapshot<PromoCodeModel> snapshot) {
                                if (snapshot.hasData) {
                                  return DiscountBuilder(data: snapshot.data);
                                } else if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          );
        });
  }

  void _modalBottomContact() {
    showModalBottomSheet(
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (builder) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: [
                Container(
                    color: Colors
                        .transparent, //could change this to Color(0xFF737373),
                    //so you don't have to change MaterialApp canvasColor
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 1.h,
                            width: 100.w,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    valuefirst = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                )),
                          ),
                          SizedBox(
                            height: 1.h,
                            width: 100.w,
                          ),
                          const SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: Text(
                              'Point of contact',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'montserrat_bold'),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            height: 50,
                            // margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8)),
                            child: TextFormField(
                              controller: nameController,
                              cursorColor: Colors.blueAccent,
                              keyboardType: TextInputType.name,
                              //  controller: _nameController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'avenir_roman',
                                  color: Colors.grey.shade600,
                                ),
                                hintText: 'name_hint'.tr,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            height: 50,
                            // margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8)),
                            child: TextFormField(
                              cursorColor: Colors.blueAccent,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'avenir_roman',
                                    color: Colors.grey.shade600),
                                hintText: 'email_hint'.tr,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            height: 50,
                            // margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8)),
                            child: TextFormField(
                              cursorColor: Colors.blueAccent,
                              keyboardType: TextInputType.phone,
                              controller: mobileController,
                              decoration: InputDecoration(
                                prefixIcon: CountryCodePicker(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'avenir_roman',
                                      color: Colors.black),
                                  onChanged: (value) {
                                    setState(() {
                                      countryCode = value.toString();
                                    });
                                    print('--------${value.toString()}');
                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: countryCode,
                                  showFlagDialog: true,
                                  comparator: (a, b) =>
                                      b.name!.compareTo(a.name!),
                                  onInit: (code) => print(
                                      "on init ${code!.name!} ${code.dialCode!} ${code.name}"),
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'avenir_roman',
                                    color: Colors.grey.shade600),
                                hintText: 'mobile_hint'.tr,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff6ed1ec),
                                  borderRadius: BorderRadius.circular(16)),
                              height: 40,
                              width: 100.w,
                              child: const Center(
                                child: Text(
                                  'ADD',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'montserrat_medium',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10.h,
                  width: double.infinity,
                )
              ],
            ),
          );
        });
  }

  void _modalBottomSheetAddCard() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          backgroundColor: Colors.grey.shade300,
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
              builder: (BuildContext contex, setter) {
                return FractionallySizedBox(
                  heightFactor: 1.0,
                  child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.grey.shade800,
                                  ),
                                  onPressed: () {},
                                ),
                                const Text(
                                  'Add New Card',
                                  style: TextStyle(
                                      fontFamily: 'montserrat_bold',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 20,
                                  height: 1,
                                ),
                              ],
                            ),
                            Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white,
                                  ),
                                  height: 25.h,
                                  width: 100.w,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color: const Color(0xffe7e7e7),
                                          height: 45,
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: TextFormField(
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    'montserrat_Medium'),
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(top: 5),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                              hintText: 'Card number',
                                              hintStyle: TextStyle(
                                                  fontFamily:
                                                      'montserrat_Medium',
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              color: const Color(0xffe7e7e7),
                                              height: 45,
                                              width: 200,
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'montserrat_Medium'),
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    border:
                                                        const OutlineInputBorder(
                                                            borderSide: BorderSide
                                                                .none),
                                                    hintText:
                                                        'Expiry date (mm/yy)',
                                                    hintStyle: const TextStyle(
                                                        fontFamily:
                                                            'montserrat_Medium',
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                    suffixIcon: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.info_outline,
                                                        color: Colors.grey,
                                                        size: 19,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8, top: 8, bottom: 8),
                                            child: Container(
                                              color: const Color(0xffe7e7e7),
                                              height: 45,
                                              width: 130,
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'montserrat_Medium'),
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    border:
                                                        const OutlineInputBorder(
                                                            borderSide: BorderSide
                                                                .none),
                                                    hintText: 'cvv',
                                                    hintStyle: const TextStyle(
                                                        fontFamily:
                                                            'montserrat_Medium',
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                    suffixIcon: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.info_outline,
                                                        color: Colors.grey,
                                                        size: 19,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color: const Color(0xffe7e7e7),
                                          height: 45,
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: TextFormField(
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    'montserrat_Medium'),
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(top: 5),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                              hintText: 'Name on card',
                                              hintStyle: TextStyle(
                                                  fontFamily:
                                                      'montserrat_Medium',
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/american_express.png'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset('assets/images/paypal.png'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset('assets/images/visa_card.png'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/images/visa_card.png',
                                )
                              ],
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            const Center(
                              child: Text(
                                  'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Malesuada molestie morbi',
                                  style: TextStyle(
                                      fontFamily: 'montserrat_Medium',
                                      fontSize: 11)),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xff6ed1ec),
                                    borderRadius: BorderRadius.circular(16)),
                                height: 40,
                                width: 100.w,
                                child: const Center(
                                  child: Text(
                                    'ADD CARD',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'montserrat_medium',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
            );
          });
    });
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
    _controller!.dispose();
    locationSubscription!.cancel();
    Provider.of<DataListner>(context, listen: false).datePickerLocally =
        'Select Time';
    Provider.of<DataListner>(context, listen: false).datePicker = 'Select Time';
    _customInfoWindowController.dispose();
    homeBlocTime1.fetchTimeSheetDispose();
    homeBlocTime2.fetchTimeSheetDispose();
    homeBlocTime3.fetchTimeSheetDispose();
    homeBlocTime4.fetchTimeSheetDispose();
    homeBlocTime5.fetchTimeSheetDispose();
    homeBlocTime6.fetchTimeSheetDispose();
    homeBlocTime7.fetchTimeSheetDispose();
    super.dispose();
  }

  clearProviderData() {
    Provider.of<DataListner>(context, listen: false).datePickerLocally =
        'Select Time';
    Provider.of<DataListner>(context, listen: false).datePicker = 'Select Time';
    Provider.of<DataListner>(context, listen: false).likedIconColor = [];
    Provider.of<DataListner>(context, listen: false).imageFileList = [];
    Provider.of<DataListner>(context, listen: false).locationName = '';
    Provider.of<DataListner>(context, listen: false).vicinity = '';
    Provider.of<DataListner>(context, listen: false).selectedDay = '';
    Provider.of<DataListner>(context, listen: false).photo = null;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return clearProviderData();
      },
      child: Scaffold(
        key: _key,
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
              Provider.of<DataListner>(context, listen: false)
                  .datePickerLocally = 'Select Time';
              Provider.of<DataListner>(context, listen: false).datePicker =
                  'Select Time';
              Provider.of<DataListner>(context, listen: false).likedIconColor =
                  [];
              Provider.of<DataListner>(context, listen: false).imageFileList =
                  [];
              Provider.of<DataListner>(context, listen: false).locationName =
                  '';
              Provider.of<DataListner>(context, listen: false).vicinity = '';
              Provider.of<DataListner>(context, listen: false).selectedDay = '';
              Provider.of<DataListner>(context, listen: false).photo = null;
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
                _key.currentState!.openEndDrawer();
              },
            ),
          ],
          backgroundColor: Colors.white60,
          shadowColor: Colors.transparent,
        ),
        endDrawer: const EndDrawer(),
        body: _initialcameraposition == null
            ? Container()
            : Stack(
                children: [
                  GoogleMap(
                    markers: Set<Marker>.of(_newMarkers.values),
                    //markers: Set<Marker>.of(_markers),
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: _initialcameraposition!, zoom: 11.5),
                    /*onMapCreated: (GoogleMapController controller) {
                  _customInfoWindowController.googleMapController = controller;
                  _controller = controller;
                  //   _controller!.showMarkerInfoWindow(const MarkerId("location_info"));
                },*/
                    onMapCreated: _onMapCreated,
                    onTap: (position) async {
                      try {
                        mapViewController.pointLocation!.value =
                            await AppMethods.getLocalityCountryFromLatLong1(
                                position.latitude, position.longitude);
                        print(
                            'LAT-LONG OnTap ::=> ${position.latitude} :: ${position.longitude}  :: ${mapViewController.pointLocation!.value}');
                        _initialcameraposition =
                            LatLng(position.latitude, position.longitude);
                        _modalBottomSheetMenu();
                      } catch (e) {
                        print('MAP EXCEPTION:: $e');
                        AppMethods.toastMsg('Try Again!!');
                      }

                      //_modalCompleteAddress(position);
                    },
                    onCameraMove: (CameraPosition position) async {
                      if (_newMarkers.isNotEmpty) {
                        MarkerId markerId = MarkerId(_markerIdVal());
                        Marker? marker = _newMarkers[markerId];
                        Marker updatedMarker = marker!.copyWith(
                          positionParam: position.target,
                        );
                        print('Marker ID:: ${MarkerId(_markerIdVal())}');
                        _newMarkers[markerId] = updatedMarker;
                        _controller
                            ?.showMarkerInfoWindow(MarkerId(_markerIdVal()));
                        mapViewController.pointLocation!.value =
                            await AppMethods.getLocalityCountryFromLatLong1(
                                position.target.latitude,
                                position.target.longitude);
                        print(
                            'Camera Move Location:: ${mapViewController.pointLocation!.value}');
                      }
                    },
                  ),

                  /*GoogleMap(
              mapToolbarEnabled: false,
              //              myLocationEnabled: true,
              //              myLocationButtonEnabled:true,
              zoomControlsEnabled: false,
              //onMapCreated: _onMapCreated,
              initialCameraPosition:
              CameraPosition(target: _initialcameraposition!, zoom: 11.5),
              markers: _markers,
              onCameraMove: (position){
                _customInfoWindowController.onCameraMove!();
              },
              onTap: (position){
                print('onTap:: ${position.longitude} :: ${position.latitude}');
              },
            ),*/
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

  void getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    print("LATLONG----$_currentPosition");
    /* _initialcameraposition =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);*/
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      /*print(
          "********11111${currentLocation.longitude} : ${currentLocation.longitude}");
      print("${currentLocation.longitude} : ${currentLocation.longitude}");*/
      _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
        zoom: 11.5,
      )));
      //  WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _currentPosition = currentLocation;
        if (_currentPosition != null) {
          /*findLocationName.GetAddressFromLatLong(_currentPosition)
              .then((value) {
            Provider.of<DataListner>(context, listen: false)
                .setlocationName(value.substring(0, value.indexOf(',')));
            Provider.of<DataListner>(context, listen: false).setvicinity(value);
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
                            const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Your Location',
                                  style: TextStyle(fontSize: 10),
                                )),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              value,
                              style: const TextStyle(
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
              LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
            );
          });*/
        }
        _initialcameraposition =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
        sharedPreference.setLatitude(_currentPosition!.latitude!);
        sharedPreference.setLongitude(_currentPosition!.longitude!);
        _markers.add(
          Marker(
            visible: true,
            icon: BitmapDescriptor.fromBytes(markerIcon!),
            markerId: const MarkerId('location_info'),
            position: LatLng(
                _currentPosition!.latitude!, _currentPosition!.longitude!),
            onTap: () {
              print('@@@@@@@@@@@@@@@@');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SearchNearByPlaces(
                      lat: _currentPosition!.latitude,
                      lang: _currentPosition!.longitude,
                      pageKey: pageKey,
                    ),
                  ));
            },
          ),
        );
      });
    });
    // });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    if (_initialcameraposition! != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = _initialcameraposition!;
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
      );
      setState(() {
        _newMarkers[markerId] = marker;
      });
      _customInfoWindowController.googleMapController = controller;
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
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }
}
