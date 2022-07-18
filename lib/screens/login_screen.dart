import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/screens/otp_screen.dart';
import 'package:kegi_sudo/screens/registration_otp_screen.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:kegi_sudo/utils/validator.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.repository}) : super(key: key);

  final Repository? repository;

  @override
  _LoginScreenState createState() => _LoginScreenState(repository);
}

class _LoginScreenState extends State<LoginScreen> {
  _LoginScreenState(this.repository);

  final Repository? repository;
  bool isLogin = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  HomeBloc homeBloc = HomeBloc();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? countryCode = '+971';
  Locale? locale;
  bool _keyboardVisible = false;
  bool isLoginButtonPressed = false;
  bool isRegsButtonPressed = false;

  @override
  void initState() {
    locale = Get.locale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    //  _keyboardVisible?listScrollController.jumpTo(listScrollController.position.maxScrollExtent):listScrollController.jumpTo(listScrollController.position.minScrollExtent);

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

    void _onRegisterButtonPressed() {
      if (Validator().validateEmail(_emailController.text.toString()) == null &&
          Validator()
                  .validateWhatsAppMobile(_mobileController.text.toString()) ==
              null &&
          Validator().validateName(_nameController.text.toString()) == null) {
        setState(() {
          isRegsButtonPressed = true;
        });
        homeBloc
            .fetchRegistrationOtpBloc(_emailController.text,
                '$countryCode${_mobileController.text}', _nameController.text)
            .then((value) {
          if (value.error != null) {
            snackBar(value.error);
            setState(() {
              isRegsButtonPressed = false;
            });
          } else {
            if (value.msg!.contains('OTP sent Successfully')) {
              print('UAEVJHVJHVJH1111111-------${value.msg}');
              AppMethods.toastMsg(value.msg);
              setState(() {
                isRegsButtonPressed = false;
              });
              //  homeBloc.fetchOtpBlocDispose();
              ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                  .hideCurrentSnackBar();
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (_) => RegisToOtp(
                    repository: repository,
                    name: _nameController.text,
                    email: _emailController.text,
                    mobile: '$countryCode${_mobileController.text}',
                    isLogin: isLogin,
                  ),
                ),
              );
            } else {
              print('UAEVJHVJHVJH-------${value.msg}');
              snackBar(value.msg);
              setState(() {
                isRegsButtonPressed = false;
              });
            }
          }
        });
      } else if (Validator().validateName(_nameController.text.toString()) !=
          null) {
        snackBar(Validator().validateName(_nameController.text.toString()));
      } else if (Validator().validateEmail(_emailController.text.toString()) !=
          null) {
        snackBar(Validator().validateEmail(_emailController.text.toString()));
      } else if (Validator()
              .validateWhatsAppMobile(_mobileController.text.toString()) !=
          null) {
        snackBar(Validator()
            .validateWhatsAppMobile(_mobileController.text.toString()));
      } else {
        snackBar('Required all fields');
      }
    }

    void _onLoginButtonPressed() {
      if (Validator().validateEmail(_emailController.text.toString()) == null &&
          Validator()
                  .validateWhatsAppMobile(_mobileController.text.toString()) ==
              null) {
        setState(() {
          isLoginButtonPressed = true;
        });
        homeBloc
            .fetchOtpBloc(
                _emailController.text, '$countryCode${_mobileController.text}')
            .then((value) {
          if (value.error != null) {
            snackBar(value.error);
            setState(() {
              isLoginButtonPressed = false;
            });
          } else {
            if (value.msg!.contains('OTP sent Successfully')) {
              print('UAEVJHVJHVJH1111111-------${value.msg}');
              AppMethods.toastMsg(value.msg);
              setState(() {
                isLoginButtonPressed = false;
              });
              //  homeBloc.fetchOtpBlocDispose();
              ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                  .hideCurrentSnackBar();
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (_) => LoginToOtp(
                    repository: repository,
                    email: _emailController.text,
                    mobile: '$countryCode${_mobileController.text}',
                  ),
                ),
              );
            } else {
              print('UAEVJHVJHVJH-------${value.msg}');
              snackBar(value.msg);
              setState(() {
                isLoginButtonPressed = false;
              });
            }
          }
        });
      } else if (Validator().validateEmail(_emailController.text.toString()) !=
          null) {
        snackBar(Validator().validateEmail(_emailController.text.toString()));
      } else if (Validator()
              .validateWhatsAppMobile(_mobileController.text.toString()) !=
          null) {
        snackBar(Validator()
            .validateWhatsAppMobile(_mobileController.text.toString()));
      } else {
        snackBar('Required all fields');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      //  appBar: AppBar(),
      body: SingleChildScrollView(
        reverse: true,
        //mainAxisAlignment: MainAxisAlignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: _keyboardVisible ? 13.h : bottom),
          child: Container(
            height: 100.h,
            width: 100.w,
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/kegi_logo.png',
                    height: 80,
                    width: 70.w,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  width: 100.w,
                  child: isLogin
                      ? Text(
                          'login_heading'.tr,
                          style: const TextStyle(
                              fontFamily: 'avenir_heavy',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          'registration_heading'.tr,
                          style: const TextStyle(
                              fontFamily: 'avenir_heavy',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                ),
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
                SizedBox(
                  height: 5.h,
                ),
                isLogin
                    ? const SizedBox()
                    : Container(
                        height: 50,
                        // margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8)),
                        child: TextFormField(
                          cursorColor: Colors.blueAccent,
                          keyboardType: TextInputType.name,
                          controller: _nameController,
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
                isLogin
                    ? const SizedBox()
                    : const SizedBox(
                        height: 16,
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
                    controller: _emailController,
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
                  height: 16,
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
                    controller: _mobileController,
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
                        initialSelection: '+971',
                        showFlagDialog: true,
                        comparator: (a, b) => b.name!.compareTo(a.name!),
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
                  height: 5.h,
                ),
                isLogin
                    ? isLoginButtonPressed
                        ? Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffc5eefa),
                                borderRadius: BorderRadius.circular(16)),
                            height: 40,
                            width: 100.w,
                            child: Center(
                              child: Text(
                                'login_button'.tr,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              _onLoginButtonPressed();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff6ed1ec),
                                  borderRadius: BorderRadius.circular(16)),
                              height: 40,
                              width: 100.w,
                              child: Center(
                                child: Text(
                                  'login_button'.tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'montserrat_medium',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                    : isRegsButtonPressed
                        ? Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffc5eefa),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: 40,
                            width: 100.w,
                            child: Center(
                              child: Text(
                                'register'.tr,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              //print('Reg Number:: $countryCode - ${_mobileController.text}');
                              _onRegisterButtonPressed();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff6ed1ec),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              height: 40,
                              width: 100.w,
                              child: Center(
                                child: Text(
                                  'register'.tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'montserrat_medium',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                SizedBox(
                  height: 8,
                ),
                isLogin
                    ? Column(
                        children: [
                          SizedBox(
                            width: 100.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "sub-text1".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'avenir_roman',
                                      color: Colors.grey.shade600),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLogin = false;
                                      });
                                    },
                                    child: Text(
                                      "register".tr,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'avenir_heavy',
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                              width: 100.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "sub-text2".tr,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'avenir_roman',
                                        color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLogin = false;
                                      });
                                    },
                                    child: Text(
                                      "guest-login".tr,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'avenir_heavy',
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      )
                    : SizedBox(
                        width: 100.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already_account".tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'avenir_roman',
                                  color: Colors.grey.shade600),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLogin = true;
                                  });
                                },
                                child: Text(
                                  "login_button".tr,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'avenir_heavy',
                                  ),
                                ))
                          ],
                        ),
                      ),
                SizedBox(
                  height: 8.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
