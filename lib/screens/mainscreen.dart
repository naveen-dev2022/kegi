import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/screens/brands_screen.dart';
import 'package:kegi_sudo/screens/fav_screen.dart';
import 'package:kegi_sudo/screens/homescreen.dart';
import 'package:kegi_sudo/screens/my_booking/mybooking_screen.dart';
import 'package:kegi_sudo/screens/profile_screen.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:location/location.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget>? _children;
  int _currentIndex = 0;
  SharedPreference sharedPreference=SharedPreference();
  Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;
  LocationData? _currentPosition;
  GoogleMapController? _controller;

  @override
  void initState() {
    getLoc();
    _children = [
      const Homescreen(),
      MyBookingScreen(),
      const ProfileScreen(),
       const BrandsScreen(),
    ];
    super.initState();
  }

 Future getLoc() async {
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

        location.onLocationChanged.listen((LocationData currentLocation) {
       //   setState(() {
            SchedulerBinding.instance!.addPostFrameCallback((_) async{
              _currentPosition = currentLocation;
             await SharedPreference.addDoubleToSF(SharedPreference.GET_LAT, _currentPosition!.latitude);
              await SharedPreference.addDoubleToSF(SharedPreference.GET_LONG, _currentPosition!.longitude);
              await sharedPreference.setLatitude(_currentPosition!.latitude!);
              await sharedPreference.setLongitude(_currentPosition!.longitude!);
            });
        //  });
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: ImageIcon(AssetImage('assets/images/home1.png')),
            ),
            label: 'HOME'.tr,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Icon(Icons.calendar_today_outlined),
            ),
            label: 'MY_BOOKINGS'.tr,
          ),
          BottomNavigationBarItem(
            icon:Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: ImageIcon(AssetImage('assets/images/profile1.png')),
            ),
            label: 'MY_PROFILE'.tr,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: ImageIcon(AssetImage('assets/images/brands1.png')),
            ),
            label: 'BRANDS'.tr,
          ),
        ],
        unselectedFontSize: 10,
        selectedFontSize: 10,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: const Color(0xff6ed1ec),
        iconSize: 22,
        onTap: _onItemTapped,
        elevation: 10,
      ),
      body: _children!.elementAt(_currentIndex),
    );
  }

}

