import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kegi_sudo/blocs/authentication/authentication_bloc.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/blocs/login/login_bloc.dart';
import 'package:kegi_sudo/blocs/registration/registration_bloc.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/screens/homescreen.dart';
import 'package:kegi_sudo/screens/mainscreen.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class RegisToOtp extends StatelessWidget {
  RegisToOtp(
      {Key? key,
      this.repository,
      this.email,
      this.mobile,
      this.name,
      isLogin = false})
      : super(key: key);

  final Repository? repository;
  HomeBloc homeBloc = HomeBloc();

  String? email;
  String? mobile;
  String? name;
  bool? isLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<RegistrationBloc>(
          create: (BuildContext context) {
            return RegistrationBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              repository: repository,
            );
          },
          child: RegisOtpScreen(
              email: email, mobile: mobile, name: name, isLogin: isLogin)),
    );
  }
}

class RegisOtpScreen extends StatefulWidget {
  RegisOtpScreen({Key? key, this.email, this.mobile, this.name, this.isLogin})
      : super(key: key);

  String? email;
  String? mobile;
  String? name;
  bool? isLogin;

  @override
  _RegisOtpScreenState createState() =>
      _RegisOtpScreenState(email, mobile, name);
}

class _RegisOtpScreenState extends State<RegisOtpScreen> {
  _RegisOtpScreenState(this.email, this.mobile, this.name);

  String? name;
  String? email;
  String? mobile;
  OtpFieldController otpController = OtpFieldController();
  TextEditingController _otpListner = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Locale? locale;
  HomeBloc homeBloc = HomeBloc();
  Timer? _timer;
  final _timeRemaining = ValueNotifier<int>(59);
  bool isRegistrationOtpPressed = false;

  @override
  void initState() {
    locale = Get.locale;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    setState(() {
      _timeRemaining.value == 0
          ? _timeRemaining.value = 0
          : _timeRemaining.value--;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    homeBloc.fetchLoginBlocDispose();
    homeBloc.fetchOtpBlocDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void snackBar(String? value) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text(
            "${value!} !!",
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'quicksand_regular',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xff253e44),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    void _onRegisButtonPressed() {
      if (_otpListner.text.length == 4) {
        setState(() {
          isRegistrationOtpPressed = true;
        });
        BlocProvider.of<RegistrationBloc>(context).add(
          RegistrationButtonPressed(
            name: name,
            email: email,
            mobile: mobile,
            otp: _otpListner.text,
          ),
        );
      } else {
        snackBar('Please fill all fields');
      }
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

    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (BuildContext context, RegistrationState state) {
        if (state is RegistrationFailure) {
          print('RegisFailure@@@');
          snackBar(state.error);
          setState(() {
            isRegistrationOtpPressed = false;
          });
        } else if (state is RegistrationInitial) {
          toastMsg('Register successful !!');
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MainScreen()));
        }
      },
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (BuildContext context, RegistrationState state) {
          return SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              //  appBar: AppBar(),
              body: Container(
                height: 100.h,
                width: 100.w,
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                        width: 100.w,
                        child: Text(
                          'otp_heading'.tr,
                          style: const TextStyle(
                              fontFamily: 'avenir_heavy',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                        alignment: locale.toString().contains('ar_SA')
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                          height: 2.5,
                          width: 80,
                          color: const Color(0xff6ed1ec),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                        width: 100.w,
                        child: Text(
                          'otp_content'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'avenir_roman',
                              color: Colors.grey.shade600),
                        )),
                    SizedBox(
                      height: 8.h,
                    ),
                    OTPTextField(
                        controller: otpController,
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 55,
                        fieldStyle: FieldStyle.underline,
                        style: const TextStyle(fontSize: 17),
                        onChanged: (pin) {
                          // _otpListner.text=pin;
                        },
                        onCompleted: (pin) {
                          _otpListner.text = pin;
                          print("Completed: " + pin);
                        }),
                    SizedBox(
                      height: 5.h,
                    ),
                    /*
                    Container(
                      child: state is! RegistrationInProgress
                          ? const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 8),
                        child: CircularProgressIndicator(),
                      )
                          : null,
                    ),*/
                    isRegistrationOtpPressed
                        ? Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffc5eefa),
                                borderRadius: BorderRadius.circular(16)),
                            height: 40,
                            width: 100.w,
                            child: Center(
                                child: Text(
                              'register'.tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'montserrat_medium',
                                  fontWeight: FontWeight.bold),
                            )))
                        : TextButton(
                            onPressed: () {
                              //  state is! LoginInProgress ? _onLoginButtonPressed : Container();
                              _onRegisButtonPressed();
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xff6ed1ec),
                                    borderRadius: BorderRadius.circular(16)),
                                height: 40,
                                width: 100.w,
                                child: Center(
                                    child: Text(
                                  'register'.tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'montserrat_medium',
                                      fontWeight: FontWeight.bold),
                                )))),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                        width: 100.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "otp_sub_text".tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'avenir_roman',
                                  color: Colors.grey.shade600),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _timeRemaining,
                              builder:
                                  (BuildContext context, int value, wigets) {
                                if (value == 0) {
                                  print('Value---a$value');
                                  return GestureDetector(
                                      onTap: () {
                                        print('Login Resend:: ');

                                        homeBloc
                                            .fetchRegistrationOtpBloc(
                                                widget.email!,
                                                widget.mobile!,
                                                name!)
                                            .then((value) {
                                          if (value.error != null) {
                                            snackBar(value.error);
                                          } else {
                                            if (value.msg!.contains(
                                                'OTP sent Successfully')) {
                                              _timeRemaining.value = 0;
                                              _timeRemaining.value += 59;
                                              print(
                                                  'UAEVJHVJHVJH1111111-------${value.msg}');
                                              toastMsg(value.msg);
                                              //  homeBloc.fetchOtpBlocDispose();
                                              ScaffoldMessenger.of(_scaffoldKey
                                                      .currentContext!)
                                                  .hideCurrentSnackBar();
                                            } else {
                                              print(
                                                  'UAEVJHVJHVJH-------${value.msg}');
                                              snackBar(value.msg);
                                            }
                                          }
                                        });
                                      },
                                      child: Text(
                                        "otp_resend".tr,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'avenir_heavy',
                                        ),
                                      ));
                                } else {
                                  return Row(
                                    children: [
                                      Text(
                                        "otp_resend".tr,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'avenir_heavy',
                                            color: Colors.grey.shade400),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '${_timeRemaining.value}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'avenir_heavy',
                                        ),
                                      )
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
