import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

import '../resources/network_helper.dart';
import '../screens/mainscreen.dart';
import '../screens/webview_screen.dart';
import '../utils/shared_preference.dart';

class PaymentSummeryController extends GetxController{

  String? serviceType;
  int? paymentMode;
  int? mainId;
  bool? valueFirst;
  String? description;
  String? name;
  String? email;
  String? dateTime;
  String? mobile;
  double? amount;
  double? vat;
  double? savedUsingPromoCode=0;
  String _url='';
  String? deviceId;
  String? address;

  void modalBottomBooking(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (builder) {
          return Wrap(
            children: [
              Container(
                  color: Colors
                      .transparent, //could change this to Color(0xFF737373),
                  //so you don't have to change MaterialApp canvasColor
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: 3,
                              color: const Color(0xff6ed1ec),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              size: 32,
                              color: Color(0xff6ed1ec),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                         Text(
                          'booking_success'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat_bold'),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    const MainScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff6ed1ec),
                                borderRadius: BorderRadius.circular(16)),
                            height: 40,
                            child:  Center(
                              child: Text(
                                'back_to_home'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  )),
            ],
          );
        });
  }

  void paymentBlock(BuildContext context,RxBool isButtonPressed){
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('mobile', nest: () {
      builder.element('store', nest: (){
        builder.text('25927');
      });
      builder.element('key', nest: (){
        builder.text('46MfZ^82XG-2bTFD');
      });

      builder.element('device', nest: (){
        builder.element('type', nest: (){
          builder.text(Platform.isIOS?'ios':'android');
        });
        builder.element('id', nest: () async {
          builder.text(deviceId!);
        });
      });

      // app
      builder.element('app', nest: (){
        builder.element('name', nest: (){
          builder.text('Telr');
        });
        builder.element('version', nest: (){
          builder.text('1.1.6');
        });
        builder.element('user', nest: (){
          builder.text('2');
        });
        builder.element('id', nest: (){
          builder.text('123');
        });
      });

      //tran
      builder.element('tran', nest: (){
        builder.element('test', nest: (){
          builder.text('1');
        });
        builder.element('type', nest: (){
          builder.text('auth');
        });
        builder.element('class', nest: (){
          builder.text('paypage');
        });
        builder.element('cartid', nest: (){
          builder.text(100000000 + Random().nextInt(999999999));
        });
        builder.element('description', nest: (){
          builder.text('$description');
        });
        builder.element('currency', nest: (){
          builder.text('aed');
        });
        builder.element('amount', nest: (){
          builder.text(getGrandAmount().toString());
        });
        builder.element('language', nest: (){
          builder.text('en');
        });
        builder.element('firstref', nest: (){
          builder.text('first');
        });
        builder.element('ref', nest: (){
          builder.text('null');
        });
      });

      //billing
      builder.element('billing', nest: (){
        // name
        builder.element('name', nest: (){
          builder.element('title', nest: (){
            builder.text('');
          });
          builder.element('first', nest: (){
            builder.text(name!);
          });
          builder.element('last', nest: (){
            builder.text(name!);
          });
        });

        // address
        builder.element('address', nest: (){
          builder.element('line1', nest: (){
            builder.text('${Get.find<MapViewController>().flatNo!.value},${Get.find<MapViewController>().buildingName!.value},${Get.find<MapViewController>().streetName!.value}');
          });
          builder.element('city', nest: (){
            builder.text('');
          });
          builder.element('region', nest: (){
            builder.text('');
          });
          builder.element('country', nest: (){
            builder.text('AED');
          });
          builder.element('zip', nest: (){
            builder.text('');
          });
        });

        builder.element('phone', nest: (){
          builder.text(mobile!.isEmpty?'${SharedPreference.getStringValueFromSF(SharedPreference.GET_MOBILE)}':mobile!);
        });
        builder.element('email', nest: (){
          builder.text(email!.isEmpty?'${SharedPreference.getStringValueFromSF(SharedPreference.GET_EMAIL)}':email!);
        });
      });
    });

    final bookshelfXml = builder.buildDocument();
    // print(bookshelfXml);
    pay(context,bookshelfXml,isButtonPressed);

  }

  double? getGrandAmount(){
    return amount!+getVat() - savedUsingPromoCode!;
  }

  void pay(BuildContext context,XmlDocument xml,RxBool isButtonPressed)async{

    print('Payment XML:: $xml');
    NetworkHelper _networkHelper = NetworkHelper();
    var response =  await _networkHelper.pay(xml);
    print('Payment Summery------$response');
    if(response == 'failed' || response == null){
      // failed
      alertShow(context,'Failed');
    }
    else
    {
      final doc = XmlDocument.parse(response);
      final url = doc.findAllElements('start').map((node) => node.text);
      final code = doc.findAllElements('code').map((node) => node.text);
      print(url);
      _url = url.toString();
      String _code = code.toString();
      if(_url.length>2){
        _url =  _url.replaceAll('(', '');
        _url = _url.replaceAll(')', '');
        _code = _code.replaceAll('(', '');
        _code = _code.replaceAll(')', '');
        launchURL(context,_url,_code,isButtonPressed);
      }
      print('Pay URL::=> $_url');
      final message = doc.findAllElements('message').map((node) => node.text);
      print('Message =  $message');
      if(message.toString().length>2){
        String msg = message.toString();
        msg = msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        alertShow(context,msg);
      }
    }
  }

  void launchURL(BuildContext context,String url, String code,RxBool isButtonPressed) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WebViewScreen(
              mainId:  mainId,
              service_type:serviceType,
              descriptionController:description,
              valuefirst:valueFirst,
              nameController: name,
              emailController: email,
              mobileController: mobile,
              url : url,
              code: code,
            )));
    isButtonPressed.value=false;
  }

  void alertShow(BuildContext context,String text) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(text, style: const TextStyle(fontSize: 15),),
        // content: Text('$text Please try again.'),
        actions: <Widget>[
          BasicDialogAction(
              title: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
  double getVat(){
    return (vat!*amount!)/100;
  }
}