import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kegi_sudo/models/address_list_model.dart';
import 'package:kegi_sudo/screens/booking_service/payment_summery_screen.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:kegi_sudo/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';
import '../blocs/homebloc.dart';
import '../models/preload_model.dart';
import '../models/promocode_model.dart';
import '../models/timesheet_model.dart';
import '../provider/delivery_data_screen_listner.dart';
import '../resources/network_helper.dart';
import '../screens/drawer_menu/map_with_address.dart';
import '../screens/mainscreen.dart';
import '../screens/map_view/search_nearbyplaces.dart';
import '../screens/webview_screen.dart';
import '../widgets/address_list/ui_builder.dart';
import '../widgets/discount_builder/map_view_discount_builder.dart';
import '../widgets/time_sheet_builder/time_sheet_builder.dart';
import '../widgets/time_sheet_builder/view_more_timesheet_builder.dart';

class MapViewController extends GetxController
    with GetSingleTickerProviderStateMixin {

  Rx<String>? country = ''.obs;
  Rx<String>? postalCode = ''.obs;
  Rx<String>? city = ''.obs;
  Rx<String>? region = ''.obs;
  Rx<String>? street = ''.obs;
  Rx<String>? subLocality = ''.obs;

  Rx<String>? currentCountry = ''.obs;
  Rx<String>? currentPostalCode = ''.obs;
  Rx<String>? currentCity = ''.obs;
  Rx<String>? currentRegion = ''.obs;

  Rx<String>? flatNo = ''.obs;
  Rx<String>? buildingName = ''.obs;
  Rx<String>? streetName = ''.obs;
  Rx<String>? countryFromApi = ''.obs;
  Rx<double>? latitude = 0.0.obs;
  Rx<double>? longitude = 0.0.obs;


  // RxInt? choosedAddress=1000.obs;
  Rx<AddressListModel> addressListData=AddressListModel().obs;
  Rx<String>? currentLocation = ''.obs;
  Rx<String>? pointLocation = ''.obs;
  Rx<bool>? isOpenUpdatedModel = false.obs;
  Rx<int> paymentMode = 1.obs;
  ImagePicker picker = ImagePicker();
  String? pageKey;
  HomeBloc homeBloc = HomeBloc();
  HomeBloc homeBlocTime1 = HomeBloc();
  HomeBloc homeBlocTime2 = HomeBloc();
  HomeBloc homeBlocTime3 = HomeBloc();
  HomeBloc homeBlocTime4 = HomeBloc();
  HomeBloc homeBlocTime5 = HomeBloc();
  HomeBloc homeBlocTime6 = HomeBloc();
  HomeBloc homeBlocTime7 = HomeBloc();
  Color buttonColor = const Color(0xff06CEEA);
  Rx<PreloadModel> preloadData = PreloadModel().obs;
  bool card1 = false;
  bool card2 = false;
  bool card3 = false;
  bool card4 = false;
  double? amount;
  String? service_type;
  RxString address = ''.obs;
  bool? isCheck;
  RxBool isDiscountPressed = false.obs;
  bool valuefirst = false;
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  final _dayNameFormatter = DateFormat('EEEE');
  DateTime now = DateTime.now();
  RxInt mainId = 0.obs;
  List<bool>? updatedTimeColor1 = [];
  List<bool>? updatedTimeColor2 = [];
  List<bool>? updatedTimeColor3 = [];
  List<bool>? updatedTimeColor4 = [];
  List<bool>? updatedTimeColor5 = [];
  List<bool>? updatedTimeColor6 = [];
  List<bool>? updatedTimeColor7 = [];
  bool? problemBottomSheet = false;
  bool? proceedBottomSheet = false;
  bool? timeSelectBottomSheet = false;
  var _url = '';
  double? discountUsingPromoCode = 0.0;
  final RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  final Rx<LatLng> initialCameraPosition = LatLng(
          SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LAT)!,
          SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LONG)!)
      .obs;
  Rx<LatLng> newLocation = LatLng(
          SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LAT)!,
          SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LONG)!)
      .obs;
  int markerIdCounter = 0;
  final Completer<GoogleMapController> mapController = Completer();
  final GlobalKey<ScaffoldState> key = GlobalKey();

  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> mobileController = TextEditingController().obs;
  String? countryCode = '+971';
  bool showExtraTime = false;
  DateTime? selectedDate;

  AnimationController? bottomSheetAnimationController;

  @override
  void onInit() {
    initialCameraPosition.value;
    newLocation.value;
    bottomSheetAnimationController =
        BottomSheet.createAnimationController(this);

    // Animation duration for retracting the BottomSheet

    bottomSheetAnimationController!.duration =
        const Duration(milliseconds: 400);

    bottomSheetAnimationController!.reverseDuration =
        const Duration(milliseconds: 400);
    // Set animation curve duration for the BottomSheet
    bottomSheetAnimationController!.drive(CurveTween(curve: Curves.linear));
    super.onInit();
  }

  void addProblemBottomSheet(BuildContext context) {
    print('BottomSheet Open!!');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          transitionAnimationController: bottomSheetAnimationController!,
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
                padding: MediaQuery.of(context).viewInsets,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 28,
                        ),
                        Text(
                          'discription_of_problem'.tr,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat_bold'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6)),
                            child: TextField(
                              maxLines: 5,
                              minLines: 5,
                              controller: Provider.of<DataListner>(context, listen: false).descriptionController,
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
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            uploadImageBottomSheet(context);
                          },
                          child: Container(
                            height: 75,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Consumer<DataListner>(
                              builder: (BuildContext context,
                                  DataListner dataListner, Widget? child) {
                                if (dataListner.imageFileList!.isNotEmpty) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xF8D5F0F8),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          margin:
                                              const EdgeInsets.only(right: 2.5),
                                          height: 75,
                                          width: 75,
                                          child: Image.asset(
                                              'assets/images/camera.png')),
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
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.5),
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: 75,
                                                      width: 75,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    6)),
                                                        child: Image.file(
                                                          File(dataListner
                                                              .imageFileList![
                                                                  index]
                                                              .path),
                                                          fit: BoxFit.fill,
                                                        ),
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
                                                              Icons.delete,
                                                              size: 24,
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
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xF8D5F0F8),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/images/camera.png'),
                                         Text(
                                          'image_video'.tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'confirm_location_heading'.tr,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat_bold'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6)),
                          child: ListTile(
                            onTap: () async {
                              Position position =
                                  await AppMethods.getGeoLocationPosition();
                              if (currentLocation == null) {
                                //currentLocation!.value=await AppMethods.getLocalityCountryFromLatLong1(newLocation!.latitude,newLocation!.longitude);
                                currentLocation!.value = await AppMethods
                                    .getLocalityCountryFromLatLong(position);
                                address.value = currentLocation!.value;
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SearchNearByPlaces(
                                              lat: newLocation.value.latitude,
                                              lang: newLocation.value.longitude,
                                              pageKey: pageKey,
                                            )));
                              }
                            },
                            title: Obx(
                              () => Text(
                                currentLocation!.value,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Obx(
                              () => Text(
                                currentLocation!.value,
                                maxLines: 2,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            trailing:
                                const Icon(Icons.favorite_border_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                            height: 100,
                            child: AddressListUiBuilder(
                                data: homeBloc.allAddressListData,
                                pageKey: 'isFromBooking',
                                setter: setter)),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MapWithAddress(
                                            pagekey: 'NEW ADDRESS',isFromMapViewScreen:true)));
                          },
                          child:  Row(
                            children: [
                              Text('+'),SizedBox(width: 3,),
                              Text(
                                'add_address'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff06CEEA),
                                  fontFamily: 'montserrat_medium',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextButton(
                          onPressed: () {
                            if (Provider.of<DataListner>(context, listen: false).descriptionController.text.isEmpty) {
                              AppMethods.toastMsg(
                                  'Description Cannot be Empty');
                            }
                            else if(addressListData.value.result!.addressList!.isEmpty){
                              AppMethods.toastMsg(
                                  'Please add your address');
                            }
                            /*
                            else if(Provider.of<DataListner>(context, listen: false).imageFileList!.isEmpty){
                              toastMsg('Please select photos');
                            }*/
                            else {
                              _modalBottomSheetProceed(context);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff6ed1ec),
                                borderRadius: BorderRadius.circular(20)),
                            height: 40,
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
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          });
    });
  }

  void uploadImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFD7D7D7),
                      border: Border.all(
                        color: const Color(0xFFD7D7D7),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      uploadImageItem('Take Photo or Video', () {
                        Navigator.of(context).pop();
                        _getFromCamera(context);
                      }),
                      uploadImageItem(
                        'Photo/Video Library',
                        () {
                          Navigator.of(context).pop();
                          _getFromGallery(context);
                        },
                        isBorder: false,
                      ),
                      /*uploadImageItem('Share Document', () {
                       // Navigator.of(context).pop();
                      },isBorder: false,),*/
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14)),
                    height: 60,
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xff0092CC),
                          fontSize: 18,
                          fontFamily: 'montserrat_bold',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                )
              ],
            ),
          );
        });
  }

  Widget uploadImageItem(String? text, VoidCallback? onTap,
      {bool isBorder = true}) {
    return Column(
      children: [
        GestureDetector(
            onTap: onTap!,
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: Center(
                child: Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff0092CC),
                    fontSize: 17,
                    fontFamily: 'montserrat_medium',
                  ),
                ),
              ),
            )),
        isBorder
            ? const Divider(
                thickness: 0.5,
                color: Colors.black,
              )
            : Container(),
      ],
    );
  }

  void _getFromGallery(BuildContext context) async {
    await picker.pickMultiImage().then((value) {
      Provider.of<DataListner>(context, listen: false)
          .SetImageDataFromGallery(value!);
    });
  }

  void _getFromCamera(BuildContext context) async {
    await picker.pickImage(source: ImageSource.camera).then((value) {
      Provider.of<DataListner>(context, listen: false)
          .SetImageDataFromCamera(value!);
    });
  }

  void _modalBottomSheetProceed(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
                  padding: MediaQuery.of(context).viewInsets,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: SizedBox(
                            width: double.infinity,
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
                                    print('TIME BOTTOM MODEL SHEET CALL');
                                    updatedTimeColor1 = [];
                                    updatedTimeColor2 = [];
                                    updatedTimeColor3 = [];
                                    updatedTimeColor4 = [];
                                    updatedTimeColor5 = [];
                                    updatedTimeColor6 = [];
                                    updatedTimeColor7 = [];
                                    _modalBottomSheetTime(context);
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
                              service_type = preloadData
                                  .value.result!.serviceType![0]
                                  .toJson()
                                  .keys
                                  .elementAt(0);
                              print('ServiceType [0] ::=> $service_type');

                              double discount = ((preloadData.value.result!
                                          .paymentDetails![1].amount!) *
                                      (preloadData.value.result!
                                          .paymentDetails![1].vat!)) /
                                  100;
                              amount = discount +
                                  preloadData
                                      .value.result!.paymentDetails![1].amount!;
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
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                preloadData
                                                    .value
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
                                                  'AED ${preloadData.value.result!.paymentDetails![1].amount}',
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
                              service_type = preloadData
                                  .value.result!.serviceType![1]
                                  .toJson()
                                  .keys
                                  .elementAt(1);
                              print('ServiceType [1] ::=> $service_type');
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
                                    preloadData.value.result!.serviceType![1]
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
                              service_type = preloadData
                                  .value.result!.serviceType![2]
                                  .toJson()
                                  .keys
                                  .elementAt(2);
                              print('ServiceType [2] ::=> $service_type');
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
                                    preloadData.value.result!.serviceType![2]
                                        .assistance!,
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
                              service_type = preloadData
                                  .value.result!.serviceType![3]
                                  .toJson()
                                  .keys
                                  .elementAt(3);
                              double discount = ((preloadData.value.result!
                                          .paymentDetails![0].amount!) *
                                      (preloadData.value.result!
                                          .paymentDetails![0].vat!)) /
                                  100;
                              amount = discount +
                                  preloadData
                                      .value.result!.paymentDetails![0].amount!;
                              print('amount#####---$amount');
                              print('ServiceType [3] ::=> $service_type');
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
                                    preloadData.value.result!.serviceType![3]
                                        .emergency!,
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
                                            'AED ${preloadData.value.result!.paymentDetails![0].surcharge}',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'montserrat_bold')),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10),
                                        child: Text(
                                            'surcharge',
                                            style: TextStyle(
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
                              trailing: StatefulBuilder(builder:
                                  (BuildContext context, innerSetState) {
                                return Checkbox(
                                  checkColor: Colors.greenAccent,
                                  activeColor: Colors.red,
                                  value: valuefirst,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      _pointOfContactBottomSheet(context);
                                    }
                                    innerSetState(() {
                                      valuefirst = value!;
                                    });
                                    print('');
                                    /*else{
                                         nameController.value.clear();
                                         emailController.value.clear();
                                         mobileController.value.clear();
                                       }*/
                                  },
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
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
                                                  _modalBottomPayment(context);
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
                                                        paymentMode.value == 1
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
                                            ? Obx((){
                                              if(isDiscountPressed.value){
                                                return Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.cancel_outlined,
                                                      size: 12,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'discount'.tr,
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                          'montserrat_medium'),
                                                    ),
                                                    const Icon(Icons
                                                        .arrow_drop_down)
                                                  ],
                                                );
                                              }
                                              else{
                                                return GestureDetector(
                                                    onTap: () {
                                                      isDiscountPressed.value =
                                                      true;
                                                      print('Discount click!!');
                                                      homeBloc
                                                          .fetchPromoCodeBloc()
                                                          .then((value) {
                                                        isDiscountPressed
                                                            .value = false;
                                                        _discountModelSheet(
                                                            context);
                                                      });
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
                                                        const Icon(Icons
                                                            .arrow_drop_down)
                                                      ],
                                                    ));
                                              }
                                        })
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
                                          AppMethods.toastMsg(
                                              'Please select time slot');
                                        } else if (service_type == null) {
                                          AppMethods.toastMsg(
                                              'Please select service');
                                        } else {
                                          print(
                                              'Service Type:: $service_type :: Payment Mode:: $paymentMode');
                                          gotoPaymentSummeryScreen(context);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: buttonColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 40,
                                        width: double.infinity,
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
                                              children:  [
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
                                                  'cash_payment'.tr,
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
                                              children:  [
                                                Icon(
                                                  Icons.cancel_outlined,
                                                  size: 12,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'discount'.tr,
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
                                    TextButton(
                                      onPressed: () {
                                        if (Provider.of<DataListner>(context,
                                                    listen: false)
                                                .datePicker ==
                                            'Select Time') {
                                          AppMethods.toastMsg(
                                              'Please select time slot');
                                        } else if (service_type == null) {
                                          AppMethods.toastMsg(
                                              'Please select service');
                                        } else {
                                          print(
                                              'Service Type:: $service_type :: Payment Mode:: $paymentMode');
                                          gotoPaymentSummeryScreen(context);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: buttonColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 40,
                                        width: double.infinity,
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
                              ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
    });
  }

  void _pointOfContactBottomSheet(BuildContext context) {
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
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: [
                Container(
                    color: Colors
                        .transparent, //could change this to Color(0xFF737373),
                    //so you don't have to change MaterialApp canvasColor
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  valuefirst = false;
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                )),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                           SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: Text(
                              'point_of_contact'.tr,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'montserrat_bold'),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: 50,
                            // margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8)),
                            child: TextFormField(
                              controller: nameController.value,
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
                          const SizedBox(
                            height: 12,
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
                              controller: emailController.value,
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
                          const SizedBox(
                            height: 12,
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
                              controller: mobileController.value,
                              decoration: InputDecoration(
                                prefixIcon: CountryCodePicker(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'avenir_roman',
                                      color: Colors.black),
                                  onChanged: (value) {
                                    countryCode = value.toString();
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
                          const SizedBox(
                            height: 12,
                          ),
                          TextButton(
                            onPressed: () {
                              if (Validator().validateEmail(
                                          emailController.value.text) ==
                                      null &&
                                  Validator().validateWhatsAppMobile(
                                          mobileController.value.text) ==
                                      null &&
                                  Validator().validateName(
                                          nameController.value.text) ==
                                      null) {
                                Navigator.pop(context);
                              } else {
                                AppMethods.toastMsg(
                                    'Please enter valid information!!');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 40,
                              child:  Center(
                                child: Text(
                                  'point_of_contact_button'.tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'montserrat_medium',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }

  Future<void> _modalPointLocationAddress(
      BuildContext context, String address) async {
    print('SHOW BOTTOM MODEL SHEET');
    isOpenUpdatedModel!.value = true;
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
                  const SizedBox(
                    height: 12,
                  ),
                  Text(address),
                  const SizedBox(
                    height: 12,
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
                      width: double.infinity,
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

  void _modalBottomSheetTime(BuildContext context) {
    print('TIME BOTTOM MODEL SHEET OPEN');
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
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime1.allTimeSheetData,
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
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime2.allTimeSheetData,
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
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime3.allTimeSheetData,
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
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime4.allTimeSheetData,
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
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime5.allTimeSheetData,
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
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime6.allTimeSheetData,
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
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime7.allTimeSheetData,
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
                                  height: 80,
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 80,
                              width: double.infinity,
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
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 40,
                                    width: double.infinity,
                                    child:  Center(
                                      child: Text(
                                        'date_time_button'.tr,
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
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 40,
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          color: Colors.white,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children:  [
                                                Text(
                                                  'select_date_time'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'montserrat_bold'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print('View more click!!');
                                            _modalBottomSheetTimeViewMore(
                                                context);
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 16),
                                            height: 40,
                                            width: 120,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children:  [
                                                  Text('view_more'.tr),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),),
              );
            },
          );
        });
  }

  void _modalBottomPayment(BuildContext context) {
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
                          const SizedBox(
                            height: 12,
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
                              groupValue: paymentMode.value,
                              activeColor: const Color(0xff6ed1ec),
                              onChanged: (int? value) {
                                setter(() {
                                  paymentMode.value = value!;
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
                              groupValue: paymentMode.value,
                              activeColor: const Color(0xff6ed1ec),
                              onChanged: (int? value) {
                                setter(() {
                                  paymentMode.value = value!;
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

  void _discountModelSheet(BuildContext context) {
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
                          const SizedBox(
                            height: 12,
                          ),
                           SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: Text(
                              'add_promo'.tr,
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
                              onChanged: (text){

                                if(text.isEmpty){

                                  setter((){
                                    isCheck = null;
                                    discountUsingPromoCode=0.0;
                                  });

                                }
                              },
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
                                hintText: 'promo_textfield'.tr,
                                hintStyle: const TextStyle(
                                    fontFamily: 'montserrat_Medium',
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
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
                                AppMethods.toastMsg(
                                    'Please apply the promo code');
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
                                  //print('Value:: ${value.result!.discountAmount}');
                                  if (value.result!.status == true) {

                                    discountUsingPromoCode =
                                        value.result!.discountAmount;
                                    setter(() {
                                      isCheck = true;
                                    });

                                    Navigator.of(context).pop();
                                  } else {
                                    discountUsingPromoCode=0.0;
                                    setter(() {
                                      isCheck = false;
                                    });

                                  }
                                });
                              }
                             /* Provider.of<DataListner>(context, listen: false)
                                  .promoApplyCheck
                                  .text = '';*/
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff6ed1ec),
                                  borderRadius: BorderRadius.circular(16)),
                              height: 40,
                              child:  Center(
                                child: Text(
                                  'activate_code'.tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'montserrat_medium',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                           SizedBox(
                            width: double.infinity,
                            child: Text(
                              "promo_sub_text".tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'montserrat_bold'),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
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
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          );
        });
  }

  void _modalBottomSheetTimeViewMore(BuildContext context) {
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
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 150,
                        child: CupertinoDatePicker(
                          minimumDate: DateTime.now(),
                          mode: CupertinoDatePickerMode.date,
                          minimumYear: 2000,
                          maximumYear: 2100,
                          onDateTimeChanged: (value) {
                            selectedDate = value;
                            print('####----${selectedDate}');
                            Provider.of<DataListner>(context, listen: false)
                                .setCompleteDate(value);
                            Provider.of<DataListner>(context, listen: false)
                                .setSelectedDay(selectedDate!.day.toString());
                            homeBloc.fetchTimeSheetBloc(
                                mainId.value, selectedDate.toString());
                            setter(() {
                              showExtraTime = true;
                            });
                          },
                          initialDateTime: DateTime.now(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      showExtraTime
                          ? SizedBox(
                              height: 25,
                              width: double.infinity,
                              child: Text(
                                '${DateFormat('EEEE').format(Provider.of<DataListner>(context, listen: false).dayMonthYear!)}, '
                                '${DateFormat('MMM').format(Provider.of<DataListner>(context, listen: false).dayMonthYear!)} '
                                '${Provider.of<DataListner>(context, listen: false).selectedDay!}',
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
                              height: 50,
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    print(
                                        'Selected Date from More:: ${Provider.of<DataListner>(context, listen: false).datePickerLocally}');
                                    Provider.of<DataListner>(context,
                                            listen: false)
                                        .SetDatePickerData(
                                            Provider.of<DataListner>(context,
                                                    listen: false)
                                                .datePickerLocally);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
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
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void gotoPaymentSummeryScreen(BuildContext context) {
    /*pint of contacts value
    date also clear*/
    print('ADDRESS--------${valuefirst}');
    //  address.value=currentLocation!.value;
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PaymentSummeryScreen(
      address: '${Get.find<MapViewController>().flatNo!.value},${Get.find<MapViewController>().buildingName!.value},${Get.find<MapViewController>().streetName!.value},${Get.find<MapViewController>().countryFromApi!.value}',
      serviceType: service_type,
      description: Provider.of<DataListner>(context, listen: false).descriptionController.text,
      email: emailController.value.text,
      valueFirst: valuefirst,
      name: nameController.value.text,
      mobile: mobileController.value.text,
      mainId: mainId.value,
      paymentMode: paymentMode.value,
      url: _url,
      dateTime:
      Provider.of<DataListner>(context, listen: false).datePicker,
      amount: getAmount(),
      vat: getVat(),
      savedUsingPromoCode: discountUsingPromoCode,
    )));
   // valuefirst = false;
  }

  double? getAmount() {
    if (service_type == 'expert_visit_req') {
      print(
          'Expert VISIT REQ: ${preloadData.value.result!.paymentDetails![0].amount!}');
      return preloadData.value.result!.paymentDetails![0].amount!;
    } else if (service_type == 'emergency') {
      print(
          'EMERGENCY:: ${preloadData.value.result!.paymentDetails![0].surcharge}');
      return preloadData.value.result!.paymentDetails![0].surcharge!+preloadData.value.result!.paymentDetails![0].amount!;
    } else {
      return 0;
    }
  }

  double? getVat() {
    if (service_type == 'expert_visit_req') {
      print(
          'Expert VISIT REQ: ${preloadData.value.result!.paymentDetails![0].vat!}');
      return preloadData.value.result!.paymentDetails![0].vat!;
    } else if (service_type == 'emergency') {
      print(
          'EMERGENCY:: ${preloadData.value.result!.paymentDetails![0].vat}');
      return preloadData.value.result!.paymentDetails![0].vat!;
    } else {
      return 0;
    }
  }

}
