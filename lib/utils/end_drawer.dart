import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:sizer/sizer.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../resources/repository.dart';
import '../screens/drawer_menu/contactus.dart';
import '../screens/drawer_menu/refer_earn.dart';
import '../screens/language_screen.dart';

class EndDrawer extends StatefulWidget
{
  const EndDrawer({Key? key}) : super(key: key);

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {

  Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.memory(base64Decode(SharedPreference.getStringValueFromSF(SharedPreference.GET_PROFILEPIC)!),height: 30,width: 30,)),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          SharedPreference.getStringValueFromSF(SharedPreference.GET_FIRSTNAME)!,
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'poppins_bold'),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:  Icon(
                        Icons.cancel,
                        size: 22,
                        color: Colors.grey.shade400,
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('drawer_about'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Helvetica_Neue_medium1',
                    )),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (_) => const ReferEarn(),
                    ),
                  );
                },
                leading: const Icon(Icons.account_balance_wallet_sharp),
                title: Text('drawer_refer'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Helvetica_Neue_medium1',
                    )),
              ),
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
                                          'rate_app_heading'.tr,
                                          style: const TextStyle(
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
                                          'rate_app_content'.tr,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
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
                                              hintStyle: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily:
                                                  'montserrat_regular'),
                                              contentPadding:
                                              const EdgeInsets.only(
                                                  left: 16, top: 16),
                                              hintText:
                                              'rate_app_feedback'.tr),
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
                                            'rate_app_submit'.tr,
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
                                  ],
                                ),
                              ); //whatever you're returning, does not have to be a Container
                            }),
                      );
                    },
                  );
                },
                leading: const Icon(Icons.star_border_purple500_outlined),
                title: Text('drawer_rate'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Helvetica_Neue_medium1',
                    )),
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
                leading: const Icon(Icons.email_outlined),
                title: Text('drawer_contact'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Helvetica_Neue_medium1',
                    )),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text('drawer_privacy'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Helvetica_Neue_medium1',
                    )),
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text('drawer_conditions'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Helvetica_Neue_medium1',
                    )),
              ),
              ListTile(
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationLoggedOut());
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LanguageScreen(
                            repository: repository,
                          )));
                },
                leading: const Icon(Icons.logout),
                title: Text('drawer_sign_out'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Helvetica_Neue_medium1',
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
