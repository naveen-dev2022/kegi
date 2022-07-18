import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class ReferEarn extends StatelessWidget {
  const ReferEarn({Key? key}) : super(key: key);

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
        title:  Text(
          'refer_heading'.tr,
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16,right: 16),
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            SizedBox(height: 5.h),
            SizedBox(
              width: 60.w,
              height: 22.h,
              child: Image.asset('assets/images/gift-box .png'),
            ),
            SizedBox(height: 3.h),
             Text('refer_content'.tr,textAlign: TextAlign.center,),
            SizedBox(height: 3.h),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: Container(
                color: Colors.grey.shade200,
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 18,top: 15),
                    border: InputBorder.none,
                 hintStyle: const TextStyle(color: Color(0xff6ed1ec)),
                  hintText: 'REF123',
                  enabled: false,
                    suffixIcon: IconButton(
                      onPressed: (){

                      },
                      icon: Text('refer_copy'.tr),
                    ),
                ),),
              ),
            ),
            SizedBox(height: 3.h),
             Text('refer_sub_content'.tr,textAlign: TextAlign.center,),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
