import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kegi_sudo/screens/drawer_menu/address_screen.dart';
import 'package:kegi_sudo/screens/drawer_menu/contactus.dart';
import 'package:kegi_sudo/screens/drawer_menu/notification_screen.dart';
import 'package:kegi_sudo/screens/drawer_menu/personal_info.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../resources/repository.dart';
import 'language_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SizedBox(
            height: 100.h,
            width: 100.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.memory(
                                base64Decode(
                                    SharedPreference.getStringValueFromSF(
                                        SharedPreference.GET_PROFILEPIC)!),
                                height: 30,
                                width: 30,
                              )),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            SharedPreference.getStringValueFromSF(
                                SharedPreference.GET_FIRSTNAME)!,
                            style: const TextStyle(
                                fontSize: 20, fontFamily: 'montserrat_bold'),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Sign out Click!!!');
                          Repository repository = Repository();
                          SharedPreference.clearSF();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LanguageScreen(
                                        repository: repository,
                                      )));
                        },
                        child: Text(
                          'drawer_sign_out'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'montserrat_regular',
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6ed1ec),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 100.w,
                    child: Text('profile_heading1'.tr,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'montserrat_medium',
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) => const PersonalInformation(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.person_outline),
                    title: Text('profile_personal_info'.tr,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'montserrat_medium',
                            color: Colors.grey.shade600)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                    ),
                  ),
                  const Divider(),
                  /*ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) =>
                          const PaymentCards(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.payment_outlined),
                    title: Text('profile_payment'.tr,   style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'montserrat_medium',
                        color: Colors.grey.shade600)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                    ),
                  ),
                  const Divider(),*/
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) => AddressScreen(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text('profile_address'.tr,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'montserrat_medium',
                            color: Colors.grey.shade600)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) => NotificationScreen(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.notifications_none_outlined),
                    title: Text('profile_notifi'.tr,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'montserrat_medium',
                            color: Colors.grey.shade600)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 100.w,
                    child: Text('profile_heading2'.tr,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'montserrat_medium',
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) => const ContactUs(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.touch_app_outlined),
                    title: Text('profile_touch'.tr,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'montserrat_medium',
                            color: Colors.grey.shade600)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      int val = -1;
                      if (Get.deviceLocale == 'en') {
                        val = 1;
                      } else {
                        val = 2;
                      }
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return DraggableScrollableSheet(
                              initialChildSize: 1.0, //set this as you want
                              maxChildSize: 1.0, //set this as you want
                              minChildSize: 1.0, //set this as you want
                              // expand: true,//set this as you want
                              builder: (context, scrollController) {
                                return StatefulBuilder(
                                    builder: (BuildContext contex, setter) {
                                  return SingleChildScrollView(
                                    child: Wrap(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.grey.shade500,
                                            )),
                                        SizedBox(
                                          height: 3.h,
                                          width: 100.w,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Container(
                                              width: 100.w,
                                              child: Text(
                                                'language_heading'.tr,
                                                style: TextStyle(
                                                    fontFamily:
                                                        'montserrat_bold',
                                                    fontSize: 16),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                          width: 100.w,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Container(
                                              width: 100.w,
                                              child: Text('language_sub'.tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'montserrat_regular',
                                                      fontSize: 14))),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                          width: 100.w,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffE4E7E8),
                                                borderRadius: BorderRadius.circular(6)),
                                            child: ListTile(
                                              title: Text(
                                                'English',
                                                style: TextStyle(fontFamily: 'avenir_roman',color: Colors.grey.shade600),
                                                //style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 5 ? Colors.black38 : Colors.black),
                                              ),
                                              trailing: Radio(
                                                value: 1,
                                                groupValue: val,
                                                activeColor: const Color(0xff6ed1ec),
                                                onChanged:(int? value) {
                                                  setter(() {
                                                    val = value!;
                                                    print('_valueAr--$val');
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffE4E7E8),
                                                borderRadius: BorderRadius.circular(6)),
                                            child: ListTile(
                                              title: Text(
                                                'العربية',
                                                style: TextStyle(fontFamily: 'avenir_roman',color: Colors.grey.shade600),
                                                //style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 5 ? Colors.black38 : Colors.black),
                                              ),
                                              trailing: Radio(
                                                value: 2,
                                                groupValue: val,
                                                activeColor: const Color(0xff6ed1ec),
                                                onChanged: (int? value) {
                                                  setter(() {
                                                    val = value!;
                                                    print('_valueAr--$val');
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                          width: 100.w,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: TextButton(
                                            onPressed: () {
                                              if (val == 1) {
                                                var local = Locale('en', 'US');
                                                Get.updateLocale(local);
                                                Navigator.popUntil(context, (route) => route.isFirst);
                                              } else if (val == 2) {
                                                var local = Locale('ar', 'SA');
                                                Get.updateLocale(local);
                                                Navigator.popUntil(context, (route) => route.isFirst);
                                              } else {
                                                AppMethods.toastMsg('Choose any language');
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff6ed1ec),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              height: 40,
                                              width: 100.w,
                                              child: Center(
                                                child: Text(
                                                  'language_button'.tr,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'montserrat_medium',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } //whatever you're returning, does not have to be a Container
                                    );
                              });
                        },
                      );
                    },
                    leading: const Icon(Icons.language),
                    title: Text('profile_lang'.tr,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'montserrat_medium',
                            color: Colors.grey.shade600)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return SizedBox(
                            height: 70.h,
                            width: 100.w,
                            child: DraggableScrollableSheet(
                                initialChildSize: 1.0, //set this as you want
                                maxChildSize: 1.0, //set this as you want
                                minChildSize: 1.0, //set this as you want
                                // expand: true,//set this as you want
                                builder: (context, scrollController) {
                                  return SingleChildScrollView(
                                    child: Wrap(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Colors.grey.shade500,
                                                )),
                                            Text(
                                              'rate_app'.tr,
                                              style: TextStyle(
                                                  fontFamily: 'montserrat_bold',
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 50,
                                              width: 60,
                                            )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                          width: 100.w,
                                        ),
                                        Center(
                                            child: Container(
                                          height: 20.h,
                                          width: 45.w,
                                          child: Image.asset(
                                              'assets/images/rating .png'),
                                        )),
                                        SizedBox(
                                          height: 2.h,
                                          width: 100.w,
                                        ),
                                        Center(
                                            child: Text(
                                          'rate_app_sub_text'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'montserrat_regular',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        SizedBox(
                                          height: 3.h,
                                          width: 100.w,
                                        ),
                                        Center(
                                          child: RatingBar.builder(
                                            initialRating: 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                          width: 100.w,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 18, right: 18),
                                          child: Container(
                                            color: Colors.grey.shade200,
                                            child: TextField(
                                              minLines: 3,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'montserrat_regular'),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 16, top: 16),
                                                  hintText:
                                                      'rate_app_disc_text'.tr),
                                              maxLines: 3,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                          width: 100.w,
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color(0xff6ed1ec),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            height: 40,
                                            width: 100.w,
                                            child: Center(
                                              child: Text(
                                                'rate_button'.tr,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'montserrat_medium',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ); //whatever you're returning, does not have to be a Container
                                }),
                          );
                        },
                      );
                    },
                    leading: const Icon(Icons.star_border),
                    title: Text('profile_Rate_app'.tr,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'montserrat_medium',
                            color: Colors.grey.shade600)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 6,
                  ),
                  Center(
                    child: Text(
                      'drawer_conditions'.tr,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'montserrat_regular',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff6ed1ec),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
