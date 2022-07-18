import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/controller/payment_summery_controller.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:kegi_sudo/widgets/app_widgets.dart';
import 'package:provider/provider.dart';
import '../../provider/delivery_data_screen_listner.dart';
import '../../resources/api_provider_preload.dart';

class PaymentSummeryScreen extends StatefulWidget {
  String? serviceType;
  String? description;
  String? email;
  String? mobile;
  String? name;
  bool? valueFirst;
  int? mainId;
  String? dateTime;
  int? paymentMode;
  String? url;
  double? amount;
  double? vat;
  double? savedUsingPromoCode;
  String? address;

  PaymentSummeryScreen(
      {Key? key,
      required this.serviceType,
      required this.description,
      required this.email,
      required this.valueFirst,
      required this.name,
      required this.mobile,
      required this.mainId,
      required this.paymentMode,
        required this.dateTime,
      required this.url,
      required this.amount,
      required this.vat,
      required this.savedUsingPromoCode,
        required this.address
      })
      : super(key: key);

  @override
  State<PaymentSummeryScreen> createState() => _PaymentSummeryScreenState();
}

class _PaymentSummeryScreenState extends State<PaymentSummeryScreen> {

  final PaymentSummeryController _controller=PaymentSummeryController();
  PreloadApiProvider preloadApiProvider = PreloadApiProvider();
  RxBool isButtonPressed=false.obs;

  @override
  void initState() {
    // TODO: implement initState

    _controller.address=widget.address;
    _controller.serviceType=widget.serviceType;
    _controller.paymentMode=widget.paymentMode;
    _controller.description=widget.description;
    _controller.name=widget.name!;
    _controller.email=widget.email;
    _controller.mobile=widget.mobile;
    _controller.mainId=widget.mainId;
    _controller.dateTime=widget.dateTime;
    _controller.valueFirst=widget.valueFirst;
    _controller.amount=widget.amount;
    _controller.vat=widget.vat;
    _controller.savedUsingPromoCode=widget.savedUsingPromoCode;

    print('widget.valueFirst-------${widget.valueFirst}');
    print('_controller.valueFirst-------${_controller.valueFirst}');
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    _controller.deviceId=await AppMethods.getDeviceId();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appbar(context,title: 'payment_heading'.tr),
      body: _buildChildWidget(),
    );
  }

  Widget _buildChildWidget(){

    return ListView(
      shrinkWrap: true,
      children: [
        _userInfo(),
        _controller.amount!=0?_billInfo():const SizedBox(),
       // const Spacer(),
        Obx((){
          if(isButtonPressed.value){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffade8f1),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                height: 40,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    "LET'S KEGI",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'montserrat_medium',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
          else{
            return _button();
          }
        }),
        const SizedBox(height: 32,),
      ],
    );
  }

  Widget _userInfo(){
    print('NAME:=> '+_controller.name!);
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF5F7F9),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              blurRadius: 4,
              offset: const Offset(2, 2),
              color: const Color(0xff000000).withOpacity(0.08)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          userItem('payment_name'.tr, SharedPreference.getStringValueFromSF(SharedPreference.GET_FIRSTNAME)),
          userItem('payment_email'.tr, SharedPreference.getStringValueFromSF(SharedPreference.GET_EMAIL)),
          userItem('payment_mobile'.tr, SharedPreference.getStringValueFromSF(SharedPreference.GET_MOBILE)),
          userItem('payment_service'.tr, AppMethods.getServiceType(_controller.mainId!)),
          userItem('payment_visit'.tr, _controller.serviceType!.replaceAll('_', ' ')),
          userItem('payment_date'.tr, _controller.dateTime),
          userItem('payment_description'.tr, _controller.description),
          userItem('payment_address'.tr, _controller.address),
        ],
      ),
    );
  }

  Widget _billInfo(){
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          billItem('total'.tr, 'AED ${_controller.amount!}'),
          const SizedBox(height: 12,),
          billItem('Vat (${_controller.vat}%)', 'AED ${_controller.getVat()}'),
          const SizedBox(height: 12,),
          promoItem('Promo code', 'you saved AED ${_controller.savedUsingPromoCode}'),
          const SizedBox(height: 12,),
          const Divider(height: 1,),
          const SizedBox(height: 12,),
          grandTotal('grand_total'.tr, 'AED ${_controller.getGrandAmount()}')
        ],
      ),
    );
  }

  Widget billItem(String? header, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppWidgets.buildText(text: header,fontWeight: FontWeight.w400),
        AppWidgets.buildText(text: value,fontWeight: FontWeight.w400),
      ],
    );
  }

  Widget promoItem(String? header, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppWidgets.buildText(text: header,color: const Color(0xff06CEEA),fontWeight: FontWeight.w400,fontSize: 16),
        AppWidgets.buildText(text: value,color: const Color(0xff06CEEA),fontSize: 12),
      ],
    );
  }

  Widget grandTotal(String? header, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppWidgets.buildText(text: header),
        AppWidgets.buildText(text: value),
      ],
    );
  }


  Widget userItem(String? header, String? value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppWidgets.buildText(
            text: header,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xff313131)),
        AppWidgets.buildText(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _button(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: () {
          isButtonPressed.value=true;
          //Booking successful or redirect on payment gateway web view
          if (widget.serviceType == 'expert_visit_req') {
            if(_controller.paymentMode!=1){
              bookServiceAPI();
            } else {
              _controller.paymentBlock(context,isButtonPressed);
            }
          } else if (widget.serviceType == 'i_know_what_issue') {
            bookServiceAPI();
          } else if (widget.serviceType == 'assistance') {
            bookServiceAPI();
          } else if (widget.serviceType == 'emergency') {
            if(_controller.paymentMode!=1){
              bookServiceAPI();
            } else {
              isButtonPressed.value=false;
              _controller.paymentBlock(context,isButtonPressed);
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff06CEEA),
            borderRadius:
            BorderRadius.circular(20),
          ),
          height: 40,
          width: double.infinity,
          child: const Center(
            child: Text(
              "LET'S KEGI",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'montserrat_medium',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void bookServiceAPI(){
    print('PROMOCODE CHECK----------${Provider.of<DataListner>(context,
        listen: false)
        .promoApplyCheck
        .value
        .text}');
    preloadApiProvider
        .fetchBookingSubmitApi(
        widget.mainId,
        widget.serviceType,
        widget.description,
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
        widget.valueFirst,
        widget.name,
        widget.email,
        widget.mobile,
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
        '',
        '',
        Provider
            .of<DataListner>(
            context,
            listen: false)
            .imageFileList!)
        .then((value) {
      if (value.status == true) {
        print('Booking Done :: ${value.status} :: ${value.name}');
        isButtonPressed.value=false;
        Provider.of<DataListner>(context, listen: false)
            .promoApplyCheck
            .text = '';
        Get.find<MapViewController>().isCheck=null;
        Get.find<MapViewController>().valuefirst=false;
        Get.find<MapViewController>().card1 = false;
        Get.find<MapViewController>().card2 = false;
        Get.find<MapViewController>().card3 = false;
        Get.find<MapViewController>().card4 = false;
        Provider.of<DataListner>(context, listen: false).descriptionController.text='';
        Get.find<MapViewController>().nameController.value.clear();
        Get.find<MapViewController>().emailController.value.clear();
        Get.find<MapViewController>().mobileController.value.clear();
        Provider.of<DataListner>(context, listen: false).imageFileList = [];
        Provider.of<DataListner>(context, listen: false).datePickerLocally = '';
        Provider.of<DataListner>(context, listen: false)
            .SetDatePickerData('Select Time');
        _controller.modalBottomBooking(context);
        // Navigator.pop(context);
        /* Navigator.pop(context);
                            Navigator.pop(context);*/
      }
    });
  }

}
