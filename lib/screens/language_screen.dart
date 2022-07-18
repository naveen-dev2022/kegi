import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:kegi_sudo/screens/login_screen.dart';
import 'package:sizer/sizer.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key,this.repository}) : super(key: key);

  final Repository? repository;

  @override
  _LanguageScreenState createState() => _LanguageScreenState(repository);
}

class _LanguageScreenState extends State<LanguageScreen> {
  _LanguageScreenState(this.repository);

  final Repository? repository;
  int val = -1;
  Locale? locale;

  @override
  void initState() {
    locale=Get.locale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: const EdgeInsets.only(left: 16 ,right: 16),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/kegi_logo.png',height: 80,width: 70.w,),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(width: 100.w, child: const Text('Select your language',style: TextStyle(fontFamily: 'avenir_heavy',fontSize: 20,fontWeight: FontWeight.bold),)),
            const SizedBox(
              height: 8,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 2.5,
                  width: 80,
                  color: const Color(0xff6ed1ec),
                )),
            SizedBox(
              height: 4.h,
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
                      setState(() {
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
                      setState(() {
                        val = value!;
                        print('_valueAr--$val');
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            TextButton(
                onPressed: () {
                  if(val==1){
                    var local=Locale('en','US');
                    Get.updateLocale(local);
                    Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) =>
                              LoginScreen(repository:repository),
                        ));
                  }
                  else if(val==2){
                    var local=Locale('ar','SA');
                    Get.updateLocale(local);
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) =>
                            LoginScreen(repository:repository),
                      ),
                    );
                  }
                  else{
                    print('PLEASE select any one!!!');
                  }
               /*   Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (_) =>
                       LoginScreen(repository:repository),
                    ),
                  );*/
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff6ed1ec),
                        borderRadius: BorderRadius.circular(16)),
                    height: 40,
                    width: 100.w,
                    child: const Center(
                        child: Text(
                      'PROCEED',
                      style: TextStyle(color: Colors.white,fontFamily: 'montserrat_medium',fontWeight: FontWeight.bold),
                    ),),),),
            SizedBox(height: 8.h,)
          ],
        ),
      ),
    );
  }
}
