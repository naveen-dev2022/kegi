
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:sizer/sizer.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({Key? key}) : super(key: key);

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
          'personal_info'.tr,
          style: TextStyle(color: Colors.black,fontSize: 15,fontFamily: 'montserrat_medium',fontWeight: FontWeight.w700),
        ),
      ),
      body: SizedBox(height: 100.h,width: 100.w,
        child: Padding(
          padding: const EdgeInsets.only(left: 14,right: 14),
          child: Column(children: [
            GestureDetector(
              onTap: (){
             /*   showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return SizedBox(
                      height: 40.h,
                      child: DraggableScrollableSheet(
                          initialChildSize: 1.0, //set this as you want
                          maxChildSize: 1.0, //set this as you want
                          minChildSize: 1.0, //set this as you want
                          // expand: true,//set this as you want
                          builder: (context, scrollController) {
                            return SingleChildScrollView(
                              child: Wrap(
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, icon: Icon(Icons.cancel,color: Colors.grey.shade500,)),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: Container(
                                        width: 100.w,
                                        child:  const Text(
                                          'Update Your Name',style: TextStyle(fontFamily: 'montserrat_bold',fontSize: 16),
                                        )),
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: Container(
                                        width: 100.w,
                                        child:  const Text(
                                          'This helps us know who we are getting in touch\nwith for our services.',style: TextStyle(fontFamily: 'montserrat_medium',fontSize: 14),
                                        )),
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: Container(
                                      color: Colors.grey.shade200,
                                      child: const TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 18),
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(fontSize: 13),
                                          hintText: 'Enter Full Name*',
                                          enabled: false,
                                        ),),
                                    ),
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: TextButton(
                                      onPressed: () {

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xff6ed1ec),
                                            borderRadius: BorderRadius.circular(16)),
                                        height: 40,
                                        width: 100.w,
                                        child: const Center(
                                          child: Text(
                                            'UPDATE',
                                            style: TextStyle(color: Colors.white,fontFamily: 'montserrat_medium',fontWeight: FontWeight.bold),
                                          ),),),),
                                  ),
                                ],
                              ),
                            ); //whatever you're returning, does not have to be a Container
                          }
                      ),
                    );
                  },
                );*/
              },
              child: SizedBox(
                height: 50,
                child: ListTile(
                  subtitle: Row(
                    children: [
                      const Icon(Icons.person_outline),
                      const SizedBox(width: 12,),
                      Text(SharedPreference.getStringValueFromSF(SharedPreference.GET_FIRSTNAME)!)
                    ],
                  ),
                //  trailing: Icon(Icons.edit_outlined,size: 20,),
                ),
              ),
            ),
            const SizedBox(height: 12,),
            const Divider(),
            GestureDetector(
              onTap: (){
               /* showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return Container(
                      height: 40.h,
                      child: DraggableScrollableSheet(
                          initialChildSize: 1.0, //set this as you want
                          maxChildSize: 1.0, //set this as you want
                          minChildSize: 1.0, //set this as you want
                          // expand: true,//set this as you want
                          builder: (context, scrollController) {
                            return SingleChildScrollView(
                              child: Wrap(
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, icon: Icon(Icons.cancel,color: Colors.grey.shade500,)),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: Container(
                                        width: 100.w,
                                        child:  const Text(
                                          'Update Your Phone Number',style: TextStyle(fontFamily: 'montserrat_bold',fontSize: 16),
                                        )),
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: Container(
                                        width: 100.w,
                                        child:  const Text(
                                          'This helps us know who we are getting in touch\nwith for our services.',style: TextStyle(fontFamily: 'montserrat_medium',fontSize: 14),
                                        )),
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child:   Container(
                                      height: 50,
                                      // margin: EdgeInsets.only(top: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(8)),
                                      child: TextFormField(
                                        cursorColor: Colors.blueAccent,
                                        keyboardType: TextInputType.phone,
                                    //    controller: _mobileController,
                                        decoration: InputDecoration(
                                          prefixIcon:   CountryCodePicker(
                                            textStyle: const TextStyle(fontSize: 16,
                                                fontFamily: 'avenir_roman',
                                                color: Colors.black),
                                            onChanged: (value){

                                              print('--------${value.toString()}');
                                            },
                                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                            initialSelection: '+91',
                                            showFlagDialog: true,
                                            comparator: (a, b) => b.name!.compareTo(a.name!),
                                            onInit: (code) =>
                                                print("on init ${code!.name!} ${code.dialCode!} ${code.name}"),
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
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: TextButton(
                                      onPressed: () {

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xff6ed1ec),
                                            borderRadius: BorderRadius.circular(16)),
                                        height: 40,
                                        width: 100.w,
                                        child: const Center(
                                          child: Text(
                                            'UPDATE',
                                            style: TextStyle(color: Colors.white,fontFamily: 'montserrat_medium',fontWeight: FontWeight.bold),
                                          ),),),),
                                  ),
                                ],
                              ),
                            ); //whatever you're returning, does not have to be a Container
                          }
                      ),
                    );
                  },
                );*/
              },
              child: SizedBox(
                height: 50,
                child: ListTile(
                  subtitle: Row(
                    children: [
                      const Icon(Icons.phone_android),
                      const SizedBox(width: 12,),
                      Text(SharedPreference.getStringValueFromSF(SharedPreference.GET_MOBILE)!)
                    ],
                  ),
                 // trailing: Icon(Icons.edit_outlined,size: 20,),
                ),
              ),
            ),
            const SizedBox(height: 12,),
            const Divider(),
            GestureDetector(
              onTap: (){
               /* showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return SizedBox(
                      height: 40.h,
                      child: DraggableScrollableSheet(
                          initialChildSize: 1.0, //set this as you want
                          maxChildSize: 1.0, //set this as you want
                          minChildSize: 1.0, //set this as you want
                          // expand: true,//set this as you want
                          builder: (context, scrollController) {
                            return SingleChildScrollView(
                              child: Wrap(
                                children: [
                                  IconButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, icon: Icon(Icons.cancel,color: Colors.grey.shade500,)),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: Container(
                                        width: 100.w,
                                        child:  const Text(
                                          'Update Your Email Address',style: TextStyle(fontFamily: 'montserrat_bold',fontSize: 16),
                                        )),
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: Container(
                                        width: 100.w,
                                        child:  const Text(
                                          'This helps us know who we are getting in touch\nwith for our services.',style: TextStyle(fontFamily: 'montserrat_medium',fontSize: 14),
                                        )),
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: Container(
                                      color: Colors.grey.shade200,
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(left: 18),
                                          border: InputBorder.none,
                                          hintStyle: const TextStyle(fontSize: 13),
                                          hintText: SharedPreference.getStringValueFromSF(SharedPreference.GET_EMAIL)!,
                                          enabled: false,
                                        ),),
                                    ),
                                  ),
                                  SizedBox(height: 3.h,width: 100.w,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16),
                                    child: TextButton(
                                      onPressed: () {

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xff6ed1ec),
                                            borderRadius: BorderRadius.circular(16)),
                                        height: 40,
                                        width: 100.w,
                                        child: const Center(
                                          child: Text(
                                            'UPDATE',
                                            style: TextStyle(color: Colors.white,fontFamily: 'montserrat_medium',fontWeight: FontWeight.bold),
                                          ),),),),
                                  ),
                                ],
                              ),
                            ); //whatever you're returning, does not have to be a Container
                          }
                      ),
                    );
                  },
                );*/
              },
              child: Container(
                height: 50,
                child: ListTile(
                  subtitle: Row(
                    children: [
                      const Icon(Icons.email_outlined),
                      const SizedBox(width: 12,),
                      Text(SharedPreference.getStringValueFromSF(SharedPreference.GET_EMAIL)!)
                    ],
                  ),
               //   trailing: Icon(Icons.edit_outlined,size: 20,),
                ),
              ),
            ),
            const SizedBox(height: 12,),
            const Divider(),
          ],),
        ),
      ),
    );
  }
}
