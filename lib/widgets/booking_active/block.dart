import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/controller/payment_summery_controller.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/models/timesheet_model.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/resources/api_provider_booking.dart';
import 'package:kegi_sudo/screens/mainscreen.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:kegi_sudo/widgets/time_sheet_builder/time_sheet_builder.dart';
import 'package:kegi_sudo/widgets/time_sheet_builder/view_more_timesheet_builder.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ActiveBookingBlock extends StatefulWidget {
  ActiveBookingBlock({Key? key, this.data, this.index, this.context})
      : super(key: key);

  List<BookingIds>? data;
  int? index;
  BuildContext? context;

  @override
  State<ActiveBookingBlock> createState() => _ActiveBookingBlockState();
}

class _ActiveBookingBlockState extends State<ActiveBookingBlock> {
  RxBool isCancelButtonPressed = false.obs;
  RxBool isRecheduleButtonPressed = false.obs;
  RxBool isConfirmRecheduleButtonPressed = false.obs;
  HomeBloc homeBloc = HomeBloc();
  bool showExtraTime = false;
  DateTime? selectedDate;
  Rx<int> paymentMode = 1.obs;
  RxBool isDiscountPressed = false.obs;
  double? discountUsingPromoCode = 0.0;
  bool? isCheck;

  void _modalBottomSheetCancelPolicy() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isDismissible: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          builder: (builder) {
            return StatefulBuilder(builder: (BuildContext context, setter) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                       SizedBox(
                          width: double.infinity,
                          child: Text(
                            'cancel_heading'.tr,
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'montserrat_bold'),
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                       SizedBox(
                          width: double.infinity,
                          child: Text(
                           'cancel_heading_sub'.tr,
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'montserrat_medium'),
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Text(
                            'details'.tr,
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'montserrat_bold'),
                          ),
                          Text(
                            'charge'.tr,
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'montserrat_bold'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Text(
                                'cancel_sub_text1'.tr,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'montserrat_medium'),
                              ),
                              Text(
                                '100% Refund',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'montserrat_bold',
                                  color: const Color(0xff6ed1ec),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Text(
                                'cancel_sub_text2'.tr,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'montserrat_medium'),
                              ),
                              Text(
                                'No Refund',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'montserrat_bold',
                                  color: const Color(0xff6ed1ec),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      TextButton(
                        onPressed: () {
                          _modalBottomSheetCancel();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff6ed1ec),
                              borderRadius: BorderRadius.circular(20)),
                          height: 40,
                          width: 100.w,
                          child: const Center(
                            child: Text(
                              'GOT IT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'montserrat_medium',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          });
    });
  }

  void _modalBottomSheetReschedulePolicy() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isDismissible: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          builder: (builder) {
            return StatefulBuilder(builder: (BuildContext context, setter) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                       SizedBox(
                          width: double.infinity,
                          child: Text(
                            'reschedule_heading'.tr,
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'montserrat_bold'),
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                       SizedBox(
                          width: double.infinity,
                          child: Text('reschedule_heading_sub'.tr,
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'montserrat_medium'),
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Text(
                            'details'.tr,
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'montserrat_bold'),
                          ),
                          Text(
                            'charge'.tr,
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'montserrat_bold'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Text(
                                'reschedule_sub_text1'.tr,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'montserrat_medium'),
                              ),
                              Text(
                                'No Charges',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'montserrat_bold',
                                  color: const Color(0xff6ed1ec),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'reschedule_sub_text2'.tr,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'montserrat_medium'),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Extra 50% of service',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'montserrat_bold',
                                      color: const Color(0xff6ed1ec),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    'charge + Tax',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'montserrat_bold',
                                      color: const Color(0xff6ed1ec),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      TextButton(
                        onPressed: () {
                          _modalBottomSheetReschedulationService();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff6ed1ec),
                              borderRadius: BorderRadius.circular(20)),
                          height: 40,
                          width: 100.w,
                          child: const Center(
                            child: Text(
                              'GOT IT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'montserrat_medium',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          });
    });
  }

  void _modalBottomSheetReschedulationService() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isDismissible: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          builder: (builder) {
            return StatefulBuilder(builder: (BuildContext context, setter) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Reschedule Service',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'montserrat_bold'),
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/booking_assistant.png',
                                  height: 14,
                                  width: 14,
                                  color: Colors.grey.shade600),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                '${widget.data![widget.index!].category}',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/booking_assistant.png',
                                  height: 14,
                                  width: 14,
                                  color: Colors.grey.shade600),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                '${widget.data![widget.index!].serviceType}',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Icon(Icons.history_toggle_off,
                                  size: 14, color: Colors.grey.shade800),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                date!,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'montserrat_medium'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/booking_id.png',
                                  height: 14,
                                  width: 14,
                                  color: Colors.grey.shade600),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Booking: ${widget.data![widget.index!].number!.toString().replaceAll('REQUEST/', '')}',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'montserrat_medium'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Bill details',
                            style: TextStyle(
                                fontSize: 12, fontFamily: 'montserrat_bold'),
                          ),
                          Text(
                            'View Rescheduling Policy',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'montserrat_bold',
                              color: Color(0xff6ed1ec),
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Site Visit Charge',
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'montserrat_medium'),
                          ),
                          Text(
                            'AED 70/hr',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'montserrat_bold',
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Rescheduling Charge',
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'montserrat_medium'),
                          ),
                          Text(
                            'AED 35',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'montserrat_bold',
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'montserrat_bold'),
                          ),
                          Text(
                            'AED 105',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'montserrat_bold',
                                color: Color(0xff6ed1ec)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Obx(
                        () => isConfirmRecheduleButtonPressed.value
                            ? Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffb9e1ec),
                                    borderRadius: BorderRadius.circular(20)),
                                height: 40,
                                width: 100.w,
                                child: const Center(
                                  child: Text(
                                    'RESCHEDULE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'montserrat_medium',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  isConfirmRecheduleButtonPressed.value = true;
                                  ApiProviderActiveBooking
                                      apiProviderActiveBooking =
                                      ApiProviderActiveBooking();
                                  apiProviderActiveBooking
                                      .fetchRechedulingBookingApi(
                                    widget.data![widget.index!].id,
                                    Provider.of<DataListner>(context,
                                            listen: false)
                                        .timeSoltId,
                                    Provider.of<DataListner>(context,
                                            listen: false)
                                        .confirmDate!
                                        .replaceAll('/', '-'),
                                  )
                                      .then((value) {
                                    if (value.result!.status!) {
                                      AppMethods.toastMsg(value.result!.msg);
                                      isConfirmRecheduleButtonPressed.value =
                                          false;
                                      _modalBottomSheetRescheduleConfirmed();
                                    } else {
                                      isConfirmRecheduleButtonPressed.value =
                                          false;
                                      AppMethods.toastMsg(value.result!.msg);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xff6ed1ec),
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 40,
                                  width: 100.w,
                                  child: const Center(
                                    child: Text(
                                      'RESCHEDULE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'montserrat_medium',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            });
          });
    });
  }

  void _modalBottomSheetCancel() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isDismissible: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          builder: (builder) {
            return StatefulBuilder(builder: (BuildContext context, setter) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Cancel Site Visit',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'montserrat_bold'),
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/booking_assistant.png',
                                  height: 14,
                                  width: 14,
                                  color: Colors.grey.shade600),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                '${widget.data![widget.index!].category}',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/booking_assistant.png',
                                  height: 14,
                                  width: 14,
                                  color: Colors.grey.shade600),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                '${widget.data![widget.index!].serviceType}',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Icon(Icons.history_toggle_off,
                                  size: 14, color: Colors.grey.shade800),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                date!,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'montserrat_medium'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/booking_id.png',
                                  height: 14,
                                  width: 14,
                                  color: Colors.grey.shade600),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Booking: ${widget.data![widget.index!].number!.toString().replaceAll('REQUEST/', '')}',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'montserrat_medium'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Bill details',
                            style: TextStyle(
                                fontSize: 12, fontFamily: 'montserrat_bold'),
                          ),
                          Text(
                            'View Cancellation Policy',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'montserrat_bold',
                              color: Color(0xff6ed1ec),
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Site Visit Charge',
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'montserrat_medium'),
                          ),
                          Text(
                            'AED 70/hr',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'montserrat_bold',
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Cancellation Charge',
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'montserrat_medium'),
                          ),
                          Text(
                            'AED 35',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'montserrat_bold',
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                                fontSize: 11, fontFamily: 'montserrat_bold'),
                          ),
                          Text(
                            'AED 105',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'montserrat_bold',
                                color: Color(0xff6ed1ec)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Obx(
                        () => isCancelButtonPressed.value
                            ? Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffb9e1ec),
                                    borderRadius: BorderRadius.circular(20)),
                                height: 40,
                                width: 100.w,
                                child: const Center(
                                  child: Text(
                                    'CANCEL',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'montserrat_medium',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  isCancelButtonPressed.value = true;
                                  ApiProviderActiveBooking
                                      apiProviderActiveBooking =
                                      ApiProviderActiveBooking();
                                  apiProviderActiveBooking
                                      .fetchCancellationBookingApi(
                                          widget.data![widget.index!].id)
                                      .then((value) {
                                    if (value.result!.status!) {
                                      AppMethods.toastMsg(value.result!.msg);
                                      isCancelButtonPressed.value = false;
                                      _modalBottomSheetCancelConfirmed();
                                    } else {
                                      isCancelButtonPressed.value = false;
                                      AppMethods.toastMsg(value.result!.msg);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xff6ed1ec),
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 40,
                                  width: 100.w,
                                  child: const Center(
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'montserrat_medium',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            });
          });
    });
  }

  void _modalBottomSheetRescheduleConfirmed() {
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
                          'Reschedule Request successful',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat_bold'),
                        ),
                        SizedBox(
                          height: 2.h,
                          width: 100.w,
                        ),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Malesuada molestie morbi',
                          style: TextStyle(
                              fontSize: 13, fontFamily: 'montserrat_medium'),
                        ),
                        SizedBox(
                          height: 3.h,
                          width: 100.w,
                        ),
                        TextButton(
                          onPressed: () {
                            _myprovider!.datePickerLocally = '';
                            _myprovider!.SetDatePickerData('Select Time');
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MainScreen()));
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

  void _modalBottomSheetCancelConfirmed() {
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
                          'Cancellation Request successful',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'montserrat_bold'),
                        ),
                        SizedBox(
                          height: 2.h,
                          width: 100.w,
                        ),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Malesuada molestie morbi',
                          style: TextStyle(
                              fontSize: 13, fontFamily: 'montserrat_medium'),
                        ),
                        SizedBox(
                          height: 3.h,
                          width: 100.w,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const MainScreen()));
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

  void _modalBottomSheetTime(BuildContext context, int? categoryId) {
    print('TIME BOTTOM MODEL SHEET OPEN');
    showModalBottomSheet(
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext contex, setter) {
              return FractionallySizedBox(
                heightFactor: 1.0,
                child: Container(
                    color: Colors.transparent,
                    //could change this to Color(0xFF737373),
                    //so you don't have to change MaterialApp canvasColor
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                        height: 25,
                                        width: double.infinity,
                                        child: Text(
                                          '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 0)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 0)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 0)))}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime1.allTimeSheetData,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<TimeSheetModel>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return TimeSheetBuilder(
                                              data: snapshot.data,
                                              setter: setter,
                                              updatedTimeColor1:
                                                  updatedTimeColor1,
                                              updatedTimeColor2:
                                                  updatedTimeColor2,
                                              updatedTimeColor3:
                                                  updatedTimeColor3,
                                              updatedTimeColor4:
                                                  updatedTimeColor4,
                                              updatedTimeColor5:
                                                  updatedTimeColor5,
                                              updatedTimeColor6:
                                                  updatedTimeColor6,
                                              updatedTimeColor7:
                                                  updatedTimeColor7,
                                              day: 1,
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                    const Divider()
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                        height: 25,
                                        width: double.infinity,
                                        child: Text(
                                          '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 1)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 1)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 1)))}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime2.allTimeSheetData,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<TimeSheetModel>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return TimeSheetBuilder(
                                                data: snapshot.data,
                                                setter: setter,
                                                updatedTimeColor1:
                                                    updatedTimeColor1,
                                                updatedTimeColor2:
                                                    updatedTimeColor2,
                                                updatedTimeColor3:
                                                    updatedTimeColor3,
                                                updatedTimeColor4:
                                                    updatedTimeColor4,
                                                updatedTimeColor5:
                                                    updatedTimeColor5,
                                                updatedTimeColor6:
                                                    updatedTimeColor6,
                                                updatedTimeColor7:
                                                    updatedTimeColor7,
                                                day: 2);
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                    const Divider()
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                        height: 25,
                                        width: double.infinity,
                                        child: Text(
                                          '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 2)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 2)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 2)))}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime3.allTimeSheetData,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<TimeSheetModel>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return TimeSheetBuilder(
                                                data: snapshot.data,
                                                setter: setter,
                                                updatedTimeColor1:
                                                    updatedTimeColor1,
                                                updatedTimeColor2:
                                                    updatedTimeColor2,
                                                updatedTimeColor3:
                                                    updatedTimeColor3,
                                                updatedTimeColor4:
                                                    updatedTimeColor4,
                                                updatedTimeColor5:
                                                    updatedTimeColor5,
                                                updatedTimeColor6:
                                                    updatedTimeColor6,
                                                updatedTimeColor7:
                                                    updatedTimeColor7,
                                                day: 3);
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                    const Divider()
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                        height: 25,
                                        width: double.infinity,
                                        child: Text(
                                          '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 3)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 3)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 3)))}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime4.allTimeSheetData,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<TimeSheetModel>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return TimeSheetBuilder(
                                                data: snapshot.data,
                                                setter: setter,
                                                updatedTimeColor1:
                                                    updatedTimeColor1,
                                                updatedTimeColor2:
                                                    updatedTimeColor2,
                                                updatedTimeColor3:
                                                    updatedTimeColor3,
                                                updatedTimeColor4:
                                                    updatedTimeColor4,
                                                updatedTimeColor5:
                                                    updatedTimeColor5,
                                                updatedTimeColor6:
                                                    updatedTimeColor6,
                                                updatedTimeColor7:
                                                    updatedTimeColor7,
                                                day: 4);
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                    const Divider()
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                        height: 25,
                                        width: double.infinity,
                                        child: Text(
                                          '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 4)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 4)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 4)))}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime5.allTimeSheetData,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<TimeSheetModel>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return TimeSheetBuilder(
                                                data: snapshot.data,
                                                setter: setter,
                                                updatedTimeColor1:
                                                    updatedTimeColor1,
                                                updatedTimeColor2:
                                                    updatedTimeColor2,
                                                updatedTimeColor3:
                                                    updatedTimeColor3,
                                                updatedTimeColor4:
                                                    updatedTimeColor4,
                                                updatedTimeColor5:
                                                    updatedTimeColor5,
                                                updatedTimeColor6:
                                                    updatedTimeColor6,
                                                updatedTimeColor7:
                                                    updatedTimeColor7,
                                                day: 5);
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                    const Divider()
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                        height: 25,
                                        width: double.infinity,
                                        child: Text(
                                          '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 5)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 5)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 5)))}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime6.allTimeSheetData,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<TimeSheetModel>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return TimeSheetBuilder(
                                                data: snapshot.data,
                                                setter: setter,
                                                updatedTimeColor1:
                                                    updatedTimeColor1,
                                                updatedTimeColor2:
                                                    updatedTimeColor2,
                                                updatedTimeColor3:
                                                    updatedTimeColor3,
                                                updatedTimeColor4:
                                                    updatedTimeColor4,
                                                updatedTimeColor5:
                                                    updatedTimeColor5,
                                                updatedTimeColor6:
                                                    updatedTimeColor6,
                                                updatedTimeColor7:
                                                    updatedTimeColor7,
                                                day: 6);
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                    const Divider()
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                        height: 25,
                                        width: double.infinity,
                                        child: Text(
                                          '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 6)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 6)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 6)))}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'montserrat_medium'),
                                        )),
                                    StreamBuilder<TimeSheetModel>(
                                        stream: homeBlocTime7.allTimeSheetData,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<TimeSheetModel>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return TimeSheetBuilder(
                                                data: snapshot.data,
                                                setter: setter,
                                                updatedTimeColor1:
                                                    updatedTimeColor1,
                                                updatedTimeColor2:
                                                    updatedTimeColor2,
                                                updatedTimeColor3:
                                                    updatedTimeColor3,
                                                updatedTimeColor4:
                                                    updatedTimeColor4,
                                                updatedTimeColor5:
                                                    updatedTimeColor5,
                                                updatedTimeColor6:
                                                    updatedTimeColor6,
                                                updatedTimeColor7:
                                                    updatedTimeColor7,
                                                day: 7);
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                    const Divider()
                                  ],
                                ),
                                const SizedBox(
                                  height: 80,
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 80,
                              width: double.infinity,
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    Provider.of<DataListner>(context,
                                            listen: false)
                                        .SetDatePickerData(
                                            Provider.of<DataListner>(context,
                                                    listen: false)
                                                .datePickerLocally);
                                    _modalBottomSheetReschedulePolicy();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 40,
                                    width: double.infinity,
                                    child:  Center(
                                      child: Text(
                                        'date_time_button'.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'montserrat_medium',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 40,
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          color: Colors.white,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children:  [
                                                Text(
                                                  'select_date_time'.tr,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'montserrat_bold'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print('View more click!!');
                                            _modalBottomSheetTimeViewMore(
                                                context, categoryId);
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 16),
                                            height: 40,
                                            width: 120,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children:  [
                                                  Text('view_more'.tr),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              );
            },
          );
        });
  }

  void _modalBottomSheetTimeViewMore(BuildContext context, int? id) {
    showModalBottomSheet(
        backgroundColor: Colors.grey.shade200,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, setter) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 12, right: 12),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 150,
                        child: CupertinoDatePicker(
                          minimumDate: DateTime.now(),
                          mode: CupertinoDatePickerMode.date,
                          minimumYear: 2000,
                          maximumYear: 2100,
                          onDateTimeChanged: (value) {
                            selectedDate = value;
                            print('####----${selectedDate}');
                            Provider.of<DataListner>(context, listen: false)
                                .setCompleteDate(value);
                            Provider.of<DataListner>(context, listen: false)
                                .setSelectedDay(selectedDate!.day.toString());
                            homeBloc.fetchTimeSheetBloc(
                                id, selectedDate.toString());
                            setter(() {
                              showExtraTime = true;
                            });
                          },
                          initialDateTime: DateTime.now(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      showExtraTime
                          ? SizedBox(
                              height: 25,
                              width: double.infinity,
                              child: Text(
                                '${DateFormat('EEEE').format(Provider.of<DataListner>(context, listen: false).dayMonthYear!)}, '
                                '${DateFormat('MMM').format(Provider.of<DataListner>(context, listen: false).dayMonthYear!)} '
                                '${Provider.of<DataListner>(context, listen: false).selectedDay!}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'montserrat_medium'),
                              ))
                          : const SizedBox(),
                      const SizedBox(
                        height: 6,
                      ),
                      StreamBuilder<TimeSheetModel>(
                          stream: homeBloc.allTimeSheetData,
                          builder: (BuildContext context,
                              AsyncSnapshot<TimeSheetModel> snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ViewMoreTimeSheetBuilder(
                                      data: snapshot.data, setter: setter));
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else {
                              return const SizedBox();
                            }
                          }),
                      const SizedBox(
                        height: 12,
                      ),
                      showExtraTime
                          ? Container(
                              height: 50,
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    print(
                                        'Selected Date from More:: ${Provider.of<DataListner>(context, listen: false).datePickerLocally}');
                                    Provider.of<DataListner>(context,
                                            listen: false)
                                        .SetDatePickerData(
                                            Provider.of<DataListner>(context,
                                                    listen: false)
                                                .datePickerLocally);
                                    _modalBottomSheetReschedulePolicy();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: const Center(
                                      child: Text(
                                        'SELECT DATES',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'montserrat_medium',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Color buttonColor = const Color(0xff06CEEA);
  HomeBloc homeBlocTime1 = HomeBloc();
  HomeBloc homeBlocTime2 = HomeBloc();
  HomeBloc homeBlocTime3 = HomeBloc();
  HomeBloc homeBlocTime4 = HomeBloc();
  HomeBloc homeBlocTime5 = HomeBloc();
  HomeBloc homeBlocTime6 = HomeBloc();
  HomeBloc homeBlocTime7 = HomeBloc();
  List<bool>? updatedTimeColor1 = [];
  List<bool>? updatedTimeColor2 = [];
  List<bool>? updatedTimeColor3 = [];
  List<bool>? updatedTimeColor4 = [];
  List<bool>? updatedTimeColor5 = [];
  List<bool>? updatedTimeColor6 = [];
  List<bool>? updatedTimeColor7 = [];
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  final _dayNameFormatter = DateFormat('EEEE');
  DateTime now = DateTime.now();
  DateTime? bookingTiming;
  String? date;
  DataListner? _myprovider;
  RxBool isImageAvailable=false.obs;

  @override
  void initState() {
    if(widget.data![widget.index!].images!.isNotEmpty){
      isImageAvailable.value=true;
    }
    bookingTiming = DateTime.parse(widget.data![widget.index!].date!);
    date =
        '${DateFormat('EEEE').format(bookingTiming!)} ${DateFormat('MMM').format(bookingTiming!)} ${bookingTiming!.day}, ${bookingTiming!.hour}:${bookingTiming!.minute}';

    _myprovider = Provider.of<DataListner>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    _myprovider!.datePickerLocally = '';
    _myprovider!.datePicker = 'Select Time';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '^^^^^^^^^^^^^^^${widget.index}---------${widget.data![widget.index!].images}');
    /*String uri = 'data:image/png;base64,${widget.data![widget.index!].images}';
    Uint8List _bytes = base64.decode(uri.split(',').last);
    Uint8List encodeedimg = _bytes;*/

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            context: context,
            builder: (builder) {
              return StatefulBuilder(builder: (BuildContext context, setter) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.data![widget.index!].category}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'montserrat_bold'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: buttonColor),
                                    child: Text(
                                      '${widget.data![widget.index!].state}'
                                          .toUpperCase(),
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontFamily: 'montserrat_medium',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 2.h,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                    'assets/images/booking_assistant.png',
                                    height: 14,
                                    width: 14,
                                    color: Colors.grey.shade600),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  '${widget.data![widget.index!].serviceType}',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'montserrat_medium',
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              children: [
                                Icon(Icons.history_toggle_off,
                                    size: 14, color: Colors.grey.shade800),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  date!,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'montserrat_medium'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/booking_id.png',
                                    height: 14,
                                    width: 14,
                                    color: Colors.grey.shade600),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Booking: ${widget.data![widget.index!].number!.toString().replaceAll('REQUEST/', '')}',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'montserrat_medium'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Described issue',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'montserrat_bold'),
                            )),
                        SizedBox(
                          height: 2.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            '${widget.data![widget.index!].description}',
                            style: const TextStyle(
                                fontSize: 10, fontFamily: 'montserrat_medium'),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Obx(()=>isImageAvailable.value? Container(
                          height: 70,
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount:
                            widget.data![widget.index!].images!.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              String uri =
                                  'data:image/png;base64,${widget.data![widget.index!].images![index]}';
                              Uint8List _bytes =
                              base64.decode(uri.split(',').last);
                              Uint8List encodeedimg = _bytes;
                              print(
                                  'widget.data![widget.index!].images-----${widget.data![widget.index!].images![index]}');
                              return Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: MemoryImage(encodeedimg)))),
                              );
                            },
                          ),
                        ):SizedBox()),
                        /* Container(
                          height: 80,
                          width: double.infinity,
                         color:Colors.grey */ /*Container(
                           decoration: BoxDecoration(
                               image: DecorationImage(
                                   fit: BoxFit.fill, image: MemoryImage(encodeedimg))),
                         ),*/ /*
                        ),*/
                        SizedBox(
                          height: 2.h,
                        ),
                        TextButton(
                          onPressed: () {
                            _modalBottomSheetCancelPolicy();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xff6ed1ec)),
                                borderRadius: BorderRadius.circular(20)),
                            height: 40,
                            width: 100.w,
                            child: const Center(
                              child: Text(
                                'CANCEL BOOKING',
                                style: TextStyle(
                                    color: const Color(0xff6ed1ec),
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => isRecheduleButtonPressed.value
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xffb4dde8),
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 40,
                                  width: 100.w,
                                  child: const Center(
                                    child: Text(
                                      'RESCHEDULE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'montserrat_medium',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                              : TextButton(
                                  onPressed: () {
                                    isRecheduleButtonPressed.value = true;
                                    homeBlocTime1.fetchTimeSheetBloc(
                                        AppMethods.getServiceTypeIdByName(widget
                                            .data![widget.index!].category),
                                        DateFormat('M/d/y').format(
                                            DateTime.now()
                                                .add(const Duration(days: 0))));
                                    homeBlocTime2.fetchTimeSheetBloc(
                                        AppMethods.getServiceTypeIdByName(widget
                                            .data![widget.index!].category),
                                        DateFormat('M/d/y').format(
                                            DateTime.now()
                                                .add(const Duration(days: 1))));
                                    homeBlocTime3.fetchTimeSheetBloc(
                                        AppMethods.getServiceTypeIdByName(widget
                                            .data![widget.index!].category),
                                        DateFormat('M/d/y').format(
                                            DateTime.now()
                                                .add(const Duration(days: 2))));
                                    homeBlocTime4.fetchTimeSheetBloc(
                                        AppMethods.getServiceTypeIdByName(widget
                                            .data![widget.index!].category),
                                        DateFormat('M/d/y').format(
                                            DateTime.now()
                                                .add(const Duration(days: 3))));
                                    homeBlocTime5.fetchTimeSheetBloc(
                                        AppMethods.getServiceTypeIdByName(widget
                                            .data![widget.index!].category),
                                        DateFormat('M/d/y').format(
                                            DateTime.now()
                                                .add(const Duration(days: 4))));
                                    homeBlocTime6.fetchTimeSheetBloc(
                                        AppMethods.getServiceTypeIdByName(widget
                                            .data![widget.index!].category),
                                        DateFormat('M/d/y').format(
                                            DateTime.now()
                                                .add(const Duration(days: 5))));
                                    homeBlocTime7
                                        .fetchTimeSheetBloc(
                                            AppMethods.getServiceTypeIdByName(
                                                widget.data![widget.index!]
                                                    .category),
                                            DateFormat('M/d/y').format(
                                                DateTime.now().add(
                                                    const Duration(days: 6))))
                                        .then((value) {
                                      isRecheduleButtonPressed.value = false;
                                      _modalBottomSheetTime(
                                          context,
                                          AppMethods.getServiceTypeIdByName(
                                              widget.data![widget.index!]
                                                  .category));
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xff6ed1ec),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 40,
                                    width: 100.w,
                                    child: const Center(
                                      child: Text(
                                        'RESCHEDULE',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'montserrat_medium',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            });
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            children: [
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.data![widget.index!].category}',
                        style: TextStyle(
                            fontSize: 18, fontFamily: 'montserrat_bold'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          height: 35,
                          width: 40.w,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: buttonColor),
                          child: Center(
                            child: Text(
                              '${widget.data![widget.index!].state}'
                                  .toUpperCase(),
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontFamily: 'montserrat_medium',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/booking_discription.png',
                    height: 14,
                    width: 14,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    width: 70.w,
                    child: Text(
                      '${widget.data![widget.index!].description}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10, fontFamily: 'montserrat_medium'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Image.asset('assets/images/booking_assistant.png',
                      height: 14, width: 14, color: Colors.grey.shade600),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    '${widget.data![widget.index!].serviceType}',
                    style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'montserrat_medium',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Icon(Icons.history_toggle_off,
                      size: 14, color: Colors.grey.shade800),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    date!,
                    style: const TextStyle(
                        fontSize: 10, fontFamily: 'montserrat_medium'),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/booking_id.png',
                      height: 14, width: 14, color: Colors.grey.shade600),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Booking: ${widget.data![widget.index!].number!.toString().replaceAll('REQUEST/', '')}',
                    style: const TextStyle(
                        fontSize: 10, fontFamily: 'montserrat_medium'),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15.0)),
          height: 160,
          width: double.infinity,
        ),
      ),
    );
  }
}
