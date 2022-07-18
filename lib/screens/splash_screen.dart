import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kegi_sudo/authentication_screen.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
   SplashScreen({Key? key,this.repository}) : super(key: key);

  Repository? repository;

  @override
  _SplashScreenState createState() => _SplashScreenState(repository);
}

class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState(this.repository);
  Repository? repository;

  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 2),
            ()=> Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AuthenticationScreen(repository:repository)))
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Center(
          child: Image.asset('assets/images/kegi_splash.png'),
        ),
      ),
    );
  }

}
