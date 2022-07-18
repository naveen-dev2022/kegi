import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatefulWidget {
   NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool? _switchValue1;
  bool? _switchValue2;
  bool? _switchValue3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
          leading: IconButton(
            icon: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
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
        title: Text('profile_notifi'.tr,style: TextStyle(color: Colors.black,fontSize: 15,fontFamily: 'montserrat_medium',fontWeight: FontWeight.w700),)),
    body: Container(
      padding: EdgeInsets.only(left: 16,right: 16),
      height: 100.h,width: 100.w,
      child: Column(children: [
        ListTile(title: Text('enable_notification_heading'.tr,style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'montserrat_medium',fontWeight: FontWeight.w700),),subtitle: Text('enable_notification_sub'.tr,style: TextStyle(color: Colors.black,fontSize: 12,fontFamily: 'montserrat_regular'),),trailing:   Transform.scale(
          scale: 0.7,
          child: Semantics(
            child: CupertinoSwitch(
              activeColor: const Color(0xff6ed1ec),
              trackColor: Color(0xEAE2E2E2),
              value: _switchValue1 ?? false,
              onChanged: (bool value) {
setState(() {
  _switchValue1=value;
});
              },
            ),
          ),
        ),),
        const Divider(),
        ListTile(title: Text('promos_offers'.tr,style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'montserrat_medium',fontWeight: FontWeight.w700)),subtitle: Text('promos_offers_sub'.tr,style: TextStyle(color: Colors.black,fontSize: 12,fontFamily: 'montserrat_regular')),trailing:   Transform.scale(
          scale: 0.7,
          child: Semantics(
            child: CupertinoSwitch(
              activeColor: const Color(0xff6ed1ec),
              trackColor: Color(0xEAE2E2E2),
              value: _switchValue2 ?? false,
              onChanged: (bool value) {
                setState(() {
                  _switchValue2=value;
                });
              },
            ),
          ),
        ),),
        const Divider(),
        ListTile(title: Text('services_heading'.tr,style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'montserrat_medium',fontWeight: FontWeight.w700)),subtitle: Text('services_sub'.tr,style: TextStyle(color: Colors.black,fontSize: 12,fontFamily: 'montserrat_regular')),trailing:   Transform.scale(
          scale: 0.7,
          child: Semantics(
            child: CupertinoSwitch(
              activeColor: const Color(0xff6ed1ec),
              trackColor: Color(0xEAE2E2E2),
              value: _switchValue3 ?? false,
              onChanged: (bool value) {
                setState(() {
                  _switchValue3=value;
                });
              },
            ),
          ),
        ),),
        const Divider(),
        SizedBox(height:3.h),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,child: TextButton(
              onPressed: () {
                 Navigator.pop(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff6ed1ec),
                      borderRadius: BorderRadius.circular(16)),
                  height: 40,
                  width: 100.w,
                  child:  Center(
                      child: Text(
                        'notification_button'.tr,
                        style: TextStyle(color: Colors.white,fontFamily: 'montserrat_medium',fontWeight: FontWeight.bold),
                      )))),),
        ),
        const SizedBox(height:40),
      ],),
    ),
    );
  }
}
