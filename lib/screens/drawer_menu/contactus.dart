import 'package:flutter/material.dart';
import 'package:kegi_sudo/resources/api_provider_myprofile.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  bool _value = false;

  String val = '';
  RxBool? isButtonPressed=false.obs;
  TextEditingController descriptionController =TextEditingController();

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
          'contact_us_heading'.tr,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'montserrat_medium',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Column(
          children: [
            SizedBox(height: 3.h),
            SizedBox(
                width: 100.w,
                child:  Text(
                  'profile_touch'.tr,
                  style: const TextStyle(fontFamily: 'montserrat_bold', fontSize: 18,fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 1.h),
            SizedBox(
                width: 100.w,
                child:  Text(
                    'contact_us_content'.tr,
                    style: const TextStyle(
                        fontFamily: 'montserrat_regular', fontSize: 14))),
            SizedBox(height: 4.h),
            SizedBox(
                width: 100.w,
                child:  Text(
                  'contact_us_booking'.tr,
                  style: const TextStyle(fontFamily: 'montserrat_bold', fontSize: 14,fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 2.h),
            Row(children: [
              Radio(
                value: 'yes',
                groupValue: val,
                onChanged: (value) {
                  print('jkkj--${value.toString()}');
                  setState(() {
                    val = value.toString();
                  });
                },
                activeColor: const Color(0xff6ed1ec),
              ),

              const SizedBox(width: 8,),
              Text("contact_us_yes".tr,
                  style: const TextStyle(
                      fontFamily: 'montserrat_regular', fontSize: 14)),
              const SizedBox(width: 15,),
              Radio(
                value: 'no',
                groupValue: val,
                onChanged: (value) {
                  print('jkkj--${value.toString()}');
                  setState(() {
                    val = value.toString();
                  });
                },
                activeColor: const Color(0xff6ed1ec),
              ),

              const SizedBox(width: 8,),
              Text("contact_us_no".tr,
                  style: const TextStyle(
                      fontFamily: 'montserrat_regular', fontSize: 14)),
            ],),
            SizedBox(height: 2.h),
            SizedBox(
                width: 100.w,
                child:  Text('contact_us_desc'.tr,
                    style: const TextStyle(
                        fontFamily: 'montserrat_bold', fontSize: 14,fontWeight: FontWeight.bold))),
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                color: Colors.grey.shade200,
                child:  TextField(
                  minLines: 5,
                  maxLines: 5,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 18, top: 15),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'montserrat_regular',
                    ),
                    hintText:
                        'contact_us_textfield'.tr,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Obx(()=>isButtonPressed!.value?Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffb6e0ec),
                        borderRadius: BorderRadius.circular(16)),
                    height: 40,
                    width: 100.w,
                    child:  Center(
                        child: Text(
                          'rate_app_submit'.tr,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'montserrat_medium',
                              fontWeight: FontWeight.bold),
                        ))):TextButton(
                    onPressed: () {
                      if(val==''){
                        AppMethods.toastMsg('Please select yes/no');
                      }
                      else if(descriptionController.text.isEmpty){
                        print('*******---->>>${descriptionController.text.isEmpty}');
                        AppMethods.toastMsg('Please fill the description');
                      }
                      else{
                        isButtonPressed!.value=true;
                        MyProfileApiProvider myProfileApiProvider=MyProfileApiProvider();
                        myProfileApiProvider.fetchGetInTouchApi(descriptionController.text, val).then((value) {
                          if(value.result!.status==true){
                            isButtonPressed!.value=false;
                            descriptionController.text='';
                            setState(() {
                              val='';
                            });
                            AppMethods.toastMsg(value.result!.msg);
                          }
                          else{
                            isButtonPressed!.value=false;
                            AppMethods.toastMsg(value.result!.msg);
                          }
                        });
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff6ed1ec),
                            borderRadius: BorderRadius.circular(16)),
                        height: 40,
                        width: 100.w,
                        child:  Center(
                            child: Text(
                              'rate_app_submit'.tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'montserrat_medium',
                                  fontWeight: FontWeight.bold),
                            ))))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
