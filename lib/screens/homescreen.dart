import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tt;
import 'package:intl/intl.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/models/preload_model.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/screens/map_view/map_view.dart';
import 'package:kegi_sudo/screens/map_view/map_view_screen.dart';
import 'package:kegi_sudo/screens/search_screen.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:kegi_sudo/utils/end_drawer.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../controller/home_screen_controller.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Repository repository = Repository();
  bool needasistant = false;
  bool emergency = false;
  Locale? locale;
  AnimationController? controller;
  final HomeScreenController _controller = Get.put(HomeScreenController());
  Stream<PreloadModel>? data;
  HomeBloc homeBloc = HomeBloc();
  String? currentLocation;
  late Future<BookingActiveModel> _model;
  PreloadModel? preloadModel = PreloadModel();

  @override
  void initState() {
    homeBloc.fetchPreloadApiBloc().then((value) {
      preloadModel = value;
    });

    _model = homeBloc.fetchActiveBookingBloc().then((value) {
      if (value.result!.bookingIds!.isNotEmpty) {
        for (int i = 0; i < value.result!.bookingIds!.length; i++) {
          if (DateFormat("yyyy-MM-dd")
                  .parse(value.result!.bookingIds![i].date!) ==
              DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())) {
            _controller.isOnGoingDataAvailable!.value = true;
            break;
          } else {
            _controller.isOnGoingDataAvailable!.value = false;
          }
        }
      } else {
        _controller.isOnGoingDataAvailable!.value = false;
      }

      print('OnGoing :: ${_controller.isOnGoingDataAvailable!.value}');
      return value;
    });

    getLocation();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    locale = Get.locale;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _key,
        floatingActionButtonLocation: locale.toString().contains('ar_SA')
            ? FloatingActionButtonLocation.startFloat
            : FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            emergency
                ? FloatingActionButton.extended(
                    backgroundColor: const Color(0xe9ef6936),
                    elevation: 0.0,
                    label: Text('home_emg_button'.tr),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Wrap(
                              children: [
                                SizedBox(
                                  height: 2.h,
                                  width: 100.w,
                                ),
                                Text(
                                  "home_emg_content1".tr,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 2.h,
                                  width: 100.w,
                                ),
                                TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Wrap(
                                              children: [
                                                SizedBox(
                                                  height: 2.h,
                                                  width: 100.w,
                                                ),
                                                Text(
                                                  "home_emg_content2".tr,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                  width: 100.w,
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      for (int i = 0;
                                                          i < 2;
                                                          i++) {
                                                        Navigator.pop(context);
                                                      }
                                                      setState(() {
                                                        emergency = false;
                                                      });
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xff6ed1ec),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                        height: 40,
                                                        width: 100.w,
                                                        child: Center(
                                                            child: Text(
                                                          'home_emg_content2_button'
                                                              .tr,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'montserrat_medium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )))),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xe9ef6936),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        height: 40,
                                        width: 100.w,
                                        child: Center(
                                            child: Text(
                                          'home_emg_content1_button'.tr,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'montserrat_medium',
                                              fontWeight: FontWeight.bold),
                                        )))),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    heroTag: 3)
                : FloatingActionButton(
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    onPressed: () {
                      setState(() {
                        emergency = true;
                      });
                    },
                    heroTag: 1,
                    child: Image.asset(
                      'assets/images/assistant.png',
                      fit: BoxFit.fill,
                    )),
            const SizedBox(height: 15),
            needasistant
                ? FloatingActionButton.extended(
                    backgroundColor: const Color(0xe9153082),
                    elevation: 0.0,
                    label: Text('home_assist_button'.tr),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Wrap(
                              children: [
                                SizedBox(
                                  height: 2.h,
                                  width: 100.w,
                                ),
                                Text(
                                  "home_assist_content1".tr,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 2.h,
                                  width: 100.w,
                                ),
                                TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Wrap(
                                              children: [
                                                SizedBox(
                                                  height: 2.h,
                                                  width: 100.w,
                                                ),
                                                Text(
                                                  "home_assist_content2".tr,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                  width: 100.w,
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      for (int i = 0;
                                                          i < 2;
                                                          i++) {
                                                        Navigator.pop(context);
                                                      }
                                                      setState(() {
                                                        needasistant = false;
                                                      });
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xff6ed1ec),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                        height: 40,
                                                        width: 100.w,
                                                        child: Center(
                                                            child: Text(
                                                          'home_emg_content2_button'
                                                              .tr,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'montserrat_medium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )))),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff6ed1ec),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        height: 40,
                                        width: 100.w,
                                        child: Center(
                                            child: Text(
                                          'home_assist_button'.tr,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'montserrat_medium',
                                              fontWeight: FontWeight.bold),
                                        )))),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    heroTag: 3)
                : FloatingActionButton(
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    onPressed: () {
                      setState(() {
                        needasistant = true;
                      });
                    },
                    heroTag: 2,
                    child: Image.asset(
                      'assets/images/question.png',
                      fit: BoxFit.fill,
                    )),
          ],
        ),
        endDrawer: const EndDrawer(),
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: 100.h,
          width: 100.w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 100.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'home_heading1'.tr,
                        style: const TextStyle(
                          fontSize: 22.5,
                          fontFamily: 'poppins_bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/images/kegi_logo.svg',
                      ),
                      Text(
                        'home_heading2'.tr,
                        style: const TextStyle(
                          fontSize: 22.5,
                          fontFamily: 'poppins_bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _key.currentState!.openEndDrawer();
                          },
                          icon: const Icon(Icons.view_headline))
                    ],
                  ),
                ),

                SizedBox(
                  height: 2.h,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => MapView(
                          pageKey: 'LOCATION_SCREEN',
                          isNotfFromSearch: true,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 100.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        Text(
                          currentLocation ?? 'Fetching...',
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'montserrat_regular',
                              fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.arrow_drop_down_outlined),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 1.h,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) =>
                            SearchScreen(preloadModel: preloadModel),
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 90.w,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.search),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'home_search'.tr,
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'montserrat_regular',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 3.h,
                ),

                SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text(
                          'home_content1'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'montserrat_medium',
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        const Text(
                          'KEGI',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff6ed1ec),
                            fontFamily: 'poppins_bold',
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          'home_content2'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'montserrat_medium',
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        ImageIcon(
                          AssetImage('assets/images/home_touch_icon.png'),
                          color: Colors.lightBlue,
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 3.h,
                ),

                StreamBuilder<PreloadModel>(
                  stream: homeBloc.allPreloadData,
                  builder: (BuildContext context,
                      AsyncSnapshot<PreloadModel> snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          SizedBox(
                            height: 35.h,
                            width: 100.w,
                            child: Image.asset('assets/images/all_service.gif',
                                fit: BoxFit.fitHeight),
                          ),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                height: 2,
                                width: 100.w,
                                color: Colors.white,
                              )),
                          Positioned(
                              top: 42,
                              right: 12,
                              child: GestureDetector(
                                onTap: () async {
                                  print('Point-1 [AC] Click');
                                  await Get.to(
                                    () => MapViewScreen(
                                      mainId: 1,
                                      preloadData: snapshot.data,
                                      pageKey: 'SERVICE_SCREEN',
                                      //isNotfFromSearch: true,*/
                                    ),
                                    transition: tt.Transition.fadeIn,
                                    duration: const Duration(milliseconds: 350),
                                  );
                                  /* Navigator.push(
                                    context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (_) => MapViewScreen(
                                          mainId:1,
                                          preloadData:snapshot.data,
                                          pageKey: 'SERVICE_SCREEN',
                                        ),
                                      )
                                  );*/
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: SpinKitPulse(
                                      color: Color(0xff49b5ef),
                                      size: 30.0,
                                      controller: controller,
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              bottom: 20,
                              right: 70,
                              child: GestureDetector(
                                onTap: () async {
                                  print('Point-2 [Electrical] Click');
                                  await Get.to(
                                      () => MapViewScreen(
                                            mainId: 3,
                                            preloadData: snapshot.data,
                                            pageKey: 'SERVICE_SCREEN',
                                            //isNotfFromSearch: true,*/
                                          ),
                                      transition: tt.Transition.fadeIn,
                                      duration:
                                          const Duration(milliseconds: 350));
                                  /* Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (_) => MapViewScreen(
                                          mainId:3,
                                          preloadData:snapshot.data,
                                          pageKey: 'SERVICE_SCREEN',
                                        ),
                                      )
                                  );*/
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.transparent,
                                  child: SpinKitPulse(
                                    color: const Color(0xff49b5ef),
                                    size: 30.0,
                                    controller: controller,
                                  ),
                                ),
                              )),
                          Positioned(
                              right: 100,
                              top: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  print('Point-3 [Plumbing] Click');
                                  await Get.to(
                                      () => MapViewScreen(
                                            mainId: 5,
                                            preloadData: snapshot.data,
                                            pageKey: 'SERVICE_SCREEN',
                                          ),
                                      transition: tt.Transition.fadeIn,
                                      duration:
                                          const Duration(milliseconds: 350));
                                  /* Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (_) => MapViewScreen(
                                          mainId:5,
                                          preloadData:snapshot.data,
                                          pageKey: 'SERVICE_SCREEN',
                                        ),
                                      )
                                  );*/
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.transparent,
                                  child: SpinKitPulse(
                                    color: const Color(0xff49b5ef),
                                    size: 30.0,
                                    controller: controller,
                                  ),
                                ),
                              )),
                          Positioned(
                              bottom: 15,
                              left: 100,
                              child: GestureDetector(
                                onTap: () async {
                                  print('Point-4 [Handyman] Click');
                                  await Get.to(
                                      () => MapViewScreen(
                                            preloadData: snapshot.data,
                                            mainId: 4,
                                            pageKey: 'SERVICE_SCREEN',
                                          ),
                                      transition: tt.Transition.fadeIn,
                                      duration:
                                          const Duration(milliseconds: 350));
                                  /* Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (_) => MapViewScreen(
                                          preloadData:snapshot.data,
                                          mainId: 4,
                                          pageKey: 'SERVICE_SCREEN',
                                        ),
                                      )
                                  );*/
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.transparent,
                                  child: SpinKitPulse(
                                    color: const Color(0xff49b5ef),
                                    size: 30.0,
                                    controller: controller,
                                  ),
                                ),
                              )),
                          Positioned(
                              top: 35,
                              left: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  print('Point-5 [Other works] Click');
                                  await Get.to(
                                      () => MapViewScreen(
                                            mainId: 2,
                                            preloadData: snapshot.data,
                                            pageKey: 'SERVICE_SCREEN',
                                          ),
                                      transition: tt.Transition.fadeIn,
                                      duration:
                                          const Duration(milliseconds: 350));
                                  /* Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (_) => MapViewScreen(
                                          mainId:2,
                                          preloadData:snapshot.data,
                                          pageKey: 'SERVICE_SCREEN',
                                        ),
                                      )
                                  );*/
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.transparent,
                                  child: SpinKitPulse(
                                    color: const Color(0xff49b5ef),
                                    size: 30.0,
                                    controller: controller,
                                  ),
                                ),
                              ))
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.white60,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 35.h,
                              width: 90.w,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),

                SizedBox(
                  height: 3.h,
                ),

                //onGoingService(),
                Obx(() => _controller.isOnGoingDataAvailable!.value
                    ? onGoingService()
                    : Container()),
                //_isAvailable()!?onGoingService():Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget onGoingService() {
    return Column(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            'home_ongoing'.tr,
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'montserrat_medium',
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        _todayOngoingServiceData(),
      ],
    );
  }

  Widget _todayOngoingServiceData() {
    /*print('Date::=> ${DateFormat("yyyy-MM-dd").parse(
        '2022-05-05 09:10:53.000000')} :: ${DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())}');*/
    return FutureBuilder<BookingActiveModel>(
      future: _model,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                children: [
                  for (int i = 0;
                      i < snapshot.data!.result!.bookingIds!.length;
                      i++) ...{
                    if (DateFormat("yyyy-MM-dd").parse(
                            snapshot.data!.result!.bookingIds![i].date!) ==
                        DateFormat("yyyy-MM-dd")
                            .parse(DateTime.now().toString())) ...{
                      _item(snapshot.data!.result!.bookingIds![i], i),
                    },
                  },
                ],
              );
            }
        }
      },
    );
  }

  Widget _item(BookingIds data, int? index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data.category}',
                      style: TextStyle(
                          fontSize: 18, fontFamily: 'montserrat_bold'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        height: 35,
                        width: 40.w,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Color(0xff6ed1ec)),
                        child: Center(
                          child: Text(
                            '${data.state}'.toUpperCase(),
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontFamily: 'montserrat_medium',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Image.asset('assets/images/booking_discription.png',
                    height: 14, width: 14, color: Colors.grey.shade600),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  '${data.description}',
                  style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'montserrat_medium',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Image.asset('assets/images/booking_assistant.png',
                    height: 14, width: 14, color: Colors.grey.shade600),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  '${data.serviceType}',
                  style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'montserrat_medium',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Icon(Icons.history_toggle_off,
                    size: 14, color: Colors.grey.shade800),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  '${data.date}',
                  style: const TextStyle(
                      fontSize: 10, fontFamily: 'montserrat_medium'),
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/booking_id.png',
                    height: 14, width: 14, color: Colors.grey.shade600),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  'Booking: ${data.number!.toString().replaceAll('REQUEST/', '')}',
                  style: const TextStyle(
                      fontSize: 10, fontFamily: 'montserrat_medium'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    // homeBloc.fetchPreloadDispose();
    super.dispose();
  }

  Future<String?> getLocation() async {
    currentLocation = await AppMethods.getLocalityCountryFromLatLong1(
        SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LAT)!,
        SharedPreference.getDoubleValueFromSF(SharedPreference.GET_LONG)!);
    setState(() {
      print('Current Location:: $currentLocation');
    });
    return currentLocation;
  }

/*bool? _isAvailable() {
    _model.then((value) {
      print(value.result!.bookingIds!.length);
      //for(int i=0;i<value.result!.bookingIds!.length;i++) {
        if (DateFormat("yyyy-MM-dd").parse(
            value.result!.bookingIds![0].date) ==
            DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())
        //DateFormat("yyyy-MM-dd").parse('2022-05-06 00:00:00.000')
        ) {
          if(){
            setState(() {});
          }
          return true;
        } else {
          return false;
        }
      //}
    });
    return false;
  }*/
}
