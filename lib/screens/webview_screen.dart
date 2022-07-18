import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/resources/api_provider_preload.dart';
import 'package:kegi_sudo/resources/network_helper.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xml/xml.dart';

class WebViewScreen extends StatefulWidget {

  final url;
  final code;
  int? mainId;
  String? service_type;
  String? descriptionController;
  bool? valuefirst;
  String? nameController;
  String? emailController;
  String? mobileController;

  WebViewScreen({@required this.url, @required this.code,this.service_type,this.nameController,this.valuefirst,this.mainId,this.descriptionController,this.emailController,this.mobileController});

  @override
  _WebViewScreenState createState() => _WebViewScreenState(mainId,service_type,descriptionController,valuefirst,nameController,emailController,mobileController);
}

class _WebViewScreenState extends State<WebViewScreen> {
  _WebViewScreenState(this.mainId,this.service_type,this.descriptionController,this.valuefirst,this.nameController,this.emailController,this.mobileController);

  int? mainId;
  String? service_type;
  String? descriptionController;
  bool? valuefirst;
  String? nameController;
  String? emailController;
  String? mobileController;
  String _url = '';
  String _code = '';
  bool _showLoader = false;
  bool _showedOnce = false;
  bool disableButton=true;
  PreloadApiProvider preloadApiProvider =
  PreloadApiProvider();

  void _modalBottomBooking() {
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
                        SizedBox(
                          height: 3.h,
                          width: 100.w,
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
                        SizedBox(
                          height: 1.h,
                          width: 100.w,
                        ),
                        const Text(
                          'KEGI Booking successful',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat_bold'),
                        ),
                        /*  SizedBox(
                          height: 2.h,
                          width: 100.w,
                        ),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Malesuada molestie morbi',
                          style: TextStyle(
                              fontSize: 13, fontFamily: 'montserrat_medium'),
                        ),*/
                        SizedBox(
                          height: 3.h,
                          width: 100.w,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.find<MapViewController>().valuefirst=false;
                            Get.find<MapViewController>().card1 = false;
                            Get.find<MapViewController>().card2 = false;
                            Get.find<MapViewController>().card3 = false;
                            Get.find<MapViewController>().card4 = false;
                            Provider.of<DataListner>(context, listen: false).descriptionController.text='';
                            Provider.of<DataListner>(context, listen: false)
                                .promoApplyCheck
                                .text = '';
                            Get.find<MapViewController>().isCheck=null;
                            Get.find<MapViewController>().discountUsingPromoCode=0.0;
                            Get.find<MapViewController>().nameController.value.clear();
                            Get.find<MapViewController>().emailController.value.clear();
                            Get.find<MapViewController>().mobileController.value.clear();
                            Provider.of<DataListner>(context, listen: false).imageFileList = [];
                            Provider.of<DataListner>(context, listen: false).datePickerLocally = '';
                            Provider.of<DataListner>(context, listen: false)
                                .SetDatePickerData('Select Time');
                            Navigator.popUntil(context, (route) => route.isFirst);
                           /* Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    const MainScreen()));*/
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff6ed1ec),
                                borderRadius: BorderRadius.circular(20)),
                            height: 40,
                            width: 100.w,
                            child: const Center(
                              child: Text(
                                'BACK TO HOME SCREEN',
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _url = widget.url;
    _code = widget.code;
    print('url in webview $_url, $_code');
  }

  void complete(XmlDocument xml) async {
    setState(() {
      _showLoader = true;
    });
    NetworkHelper _networkHelper = NetworkHelper();
    var response = await _networkHelper.completed(xml);
    final doc = XmlDocument.parse(response);
    final message = doc.findAllElements('message').map((node) => node.text);
    final tranref = doc.findAllElements('tranref').map((node) => node.text);

    print('PAYMENT SUMMARY RESPONSE---->message:::::$message-------tranref::::$tranref');

    if (response == 'failed' || response == null) {
      alertShow('Failed. Please try again', false);
      setState(() {
        _showLoader = false;
      });
    }

    else {
      final doc = XmlDocument.parse(response);
      final message = doc.findAllElements('message').map((node) => node.text);
      if (message.toString().length > 2) {
        String msg = message.toString();
        msg = msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        setState(() {
          _showLoader = false;
        });
        if (!_showedOnce) {
          _showedOnce = true;
       //   alertShow('Your transaction is $msg', true);
          showPlatformDialog(
            context: context,
            builder: (_) => StatefulBuilder(
                builder: (BuildContext context, setter) {
                  return BasicDialogAlert(
                    title: Text(
                      'Your transaction is $msg',
                      style: TextStyle(fontSize: 15),
                    ),
                    // content: Text('$text Please try again.'),
                    actions: <Widget>[
                      disableButton ?
                      BasicDialogAction(
                          title: Text('Ok'),
                          onPressed: () {
                            setter(() {
                              disableButton = false;
                            });
                            preloadApiProvider
                                .fetchBookingSubmitApi(
                                mainId,
                                service_type,
                                descriptionController,
                                Provider
                                    .of<DataListner>(
                                    context,
                                    listen: false)
                                    .confirmDate,
                                Provider
                                    .of<DataListner>(
                                    context,
                                    listen: false)
                                    .timeSoltId,
                                valuefirst,
                                nameController,
                                emailController,
                                mobileController,
                                Get.find<MapViewController>().flatNo!.value,
                                Get.find<MapViewController>().buildingName!.value,
                                Get.find<MapViewController>().streetName!.value,
                                Get.find<MapViewController>().latitude!.value,
                                Get.find<MapViewController>().longitude!.value,
                                Provider.of<DataListner>(context,
                                    listen: false)
                                    .promoApplyCheck
                                    .value
                                    .text,
                                message.toString().replaceAll('(', '').replaceAll(')', ''),
                                tranref.toString().replaceAll('(', '').replaceAll(')', ''),
                                Provider
                                    .of<DataListner>(
                                    context,
                                    listen: false)
                                    .imageFileList!)
                                .then((value) {
                              if (value.status == true) {
                                _modalBottomBooking();
                                // Navigator.pop(context);
                                /* Navigator.pop(context);
                            Navigator.pop(context);*/
                              }
                            });
                          }) :
                      BasicDialogAction(
                          title: Text('Ok', style: TextStyle(color: Colors.grey
                              .shade400),),
                          ),
                    ],
                  );
                }
            ),
          );
        }
        // https://secure.telr.com/gateway/webview_start.html?code=a8caa483fe7260ace06a255cc32e
      }
    }
  }

  void alertShow(String text, bool pop) {
    print('popup thrown');

    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
        // content: Text('$text Please try again.'),
        actions: <Widget>[
          BasicDialogAction(
              title: Text('Ok'),
              onPressed: () {
                print(pop.toString());
                if (pop) {
                  print('inside pop');
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  print('inside false');
                  Navigator.pop(context);
                }
              }),
        ],
      ),
    );
  }

  void createXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('mobile', nest: () {
      builder.element('store', nest: () {
        builder.text('15996');
      });
      builder.element('key', nest: () {
        builder.text('pQ6nP-7rHt@5WRFv');
      });
      builder.element('complete', nest: () {
        builder.text(_code);
      });
    });

    final bookshelfXml = builder.buildDocument();
    print(bookshelfXml);
    complete(bookshelfXml);
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: const Text(
            'Payment',
            style: TextStyle(color: Colors.black),
          ),
          leading: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ),

        body: WebView(
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          navigationDelegate: (NavigationRequest request) {
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
            _showedOnce = false;
            if (url.contains('close')) {
              print('call the api');
            }
            if (url.contains('abort')) {
              print('show fail and pop');
            }
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            if (url.contains('close')) {
              print('call the api');
              createXml();
            }
            if (url.contains('abort')) {
              print('show fail and pop');
            }
          },
          gestureNavigationEnabled: true,
        ));

  }


}
