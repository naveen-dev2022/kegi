import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:kegi_sudo/models/booking_history_model.dart';
import 'package:kegi_sudo/utils/shared_preference.dart';
import 'package:sizer/sizer.dart';

class HistoryBookingBlock extends StatefulWidget {
  HistoryBookingBlock({Key? key,this.data,this.index,this.context}) : super(key: key);

   List<BookingIds>? data;
   int? index;
   BuildContext? context;

  @override
  State<HistoryBookingBlock> createState() => _HistoryBookingBlockState();
}

class _HistoryBookingBlockState extends State<HistoryBookingBlock> {

  Color buttonColor = const Color(0xff06CEEA);
  String? date;
  DateTime? bookingTiming;
  RxBool? isBeforeImage=false.obs;
  RxBool? isAfterImage=false.obs;

  @override
  void initState() {
    if(widget.data![widget.index!].workBeforeImages!.isNotEmpty){
      isBeforeImage!.value=true;
    }
    if(widget.data![widget.index!].workAfterImages!.isNotEmpty){
      isAfterImage!.value=true;
    }
    bookingTiming = DateTime.parse(widget.data![widget.index!].date!);
    date =
    '${DateFormat('EEEE').format(bookingTiming!)} ${DateFormat('MMM').format(bookingTiming!)} ${bookingTiming!.day}, ${bookingTiming!.hour}:${bookingTiming!.minute}';

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
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
                                      fontSize: 18, fontFamily: 'montserrat_bold'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Color(0xff3490cd)),
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
                                Image.asset('assets/images/booking_assistant.png',height: 14,width: 14,color:Colors.grey.shade600),
                                SizedBox(width: 6,),
                                Text(
                                  '${widget.data![widget.index!].serviceType}',
                                  style: TextStyle(
                                      fontSize: 10, fontFamily: 'montserrat_medium',fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              children: [
                                Icon(Icons.person_outline,size: 14,color:Colors.grey.shade800),
                                SizedBox(width: 6,),
                                Text(
                                  '${SharedPreference.getStringValueFromSF(SharedPreference.GET_FIRSTNAME)}',
                                  style: const TextStyle(
                                      fontSize: 10, fontFamily: 'montserrat_medium'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              children: [
                                Icon(Icons.history_toggle_off,size: 14,color:Colors.grey.shade800),
                                SizedBox(width: 6,),
                                Text(
                                    "Service completed :${date!}",
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
                                Image.asset('assets/images/booking_id.png',height: 14,width: 14,color: Colors.grey.shade600),
                                SizedBox(width: 6,),
                                Text(
                                  'Booking: ${widget.data![widget.index!].number!.toString().replaceAll('REQUEST/', '')}',
                                  style: TextStyle(
                                      fontSize: 10, fontFamily: 'montserrat_medium'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        TextButton(
                          onPressed: () {

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(  color: const Color(0xff6ed1ec)),
                                borderRadius: BorderRadius.circular(20)),
                            height: 40,
                            width: 100.w,
                            child: const Center(
                              child: Text(
                                'VIEW SERVICE TRACK REPORT',
                                style: TextStyle(
                                    color: const Color(0xff6ed1ec),
                                    fontFamily: 'montserrat_medium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Service report',
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
                      /*  const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Material used',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'montserrat_bold'),
                            )),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(
                            'Item used',
                            style: TextStyle(
                                fontSize: 12, fontFamily: 'montserrat_bold'),
                          ),
                          Text(
                            'Quantity',
                            style: TextStyle(
                                fontSize: 12, fontFamily: 'montserrat_bold'),
                          )
                        ],),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pendant bulb holder',
                              style: TextStyle(
                                  fontSize: 12, fontFamily: 'montserrat_medium'),
                            ),
                            Text(
                              '01 Pc',
                              style: TextStyle(
                                  fontSize: 12, fontFamily: 'montserrat_bold'),
                            )
                          ],),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Pendant Switch',
                              style: TextStyle(
                                  fontSize: 12, fontFamily: 'montserrat_medium'),
                            ),
                            Text(
                              '02 Pc',
                              style: TextStyle(
                                  fontSize: 12, fontFamily: 'montserrat_bold'),
                            )
                          ],),
                        SizedBox(
                          height: 2.h,
                        ),*/

                        Obx(()=> isBeforeImage!.value?
                        Column(children: [
                          const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Before images',
                                style: TextStyle(
                                    fontSize: 15, fontFamily: 'montserrat_bold'),
                              )),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            height: 70,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount:
                              widget.data![widget.index!].workBeforeImages!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                String uri =
                                    'data:image/png;base64,${widget.data![widget.index!].workBeforeImages![index]}';
                                Uint8List _bytes =
                                base64.decode(uri.split(',').last);
                                Uint8List encodeedimg = _bytes;
                                print(
                                    'widget.data![widget.index!].images-----${widget.data![widget.index!].workBeforeImages![index]}');
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
                          ),
                        ],):SizedBox()),


                        Obx(()=> isAfterImage!.value?
                        Column(children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'After images',
                                style: TextStyle(
                                    fontSize: 15, fontFamily: 'montserrat_bold'),
                              )),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            height: 70,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount:
                              widget.data![widget.index!].workAfterImages!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                String uri =
                                    'data:image/png;base64,${widget.data![widget.index!].workAfterImages![index]}';
                                Uint8List _bytes =
                                base64.decode(uri.split(',').last);
                                Uint8List encodeedimg = _bytes;
                                print(
                                    'widget.data![widget.index!].images-----${widget.data![widget.index!].workAfterImages![index]}');
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
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],):SizedBox()),


                        TextButton(
                          onPressed: () {
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
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff6ed1ec),
                                borderRadius: BorderRadius.circular(20)),
                            height: 40,
                            width: 100.w,
                            child: const Center(
                              child: Text(
                                'RATE OUR SERVICES',
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
                        style: const TextStyle(
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
                  Image.asset('assets/images/booking_discription.png',height: 14,width: 14,color: Colors.grey.shade600,),
                  SizedBox(width: 6,),
                  Text(
                    '${widget.data![widget.index!].description}',
                    style: TextStyle(
                        fontSize: 10, fontFamily: 'montserrat_medium'),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Image.asset('assets/images/booking_assistant.png',height: 14,width: 14,color:Colors.grey.shade600),
                  SizedBox(width: 6,),
                  Text(
                    '${widget.data![widget.index!].serviceType}',
                    style: TextStyle(
                        fontSize: 10, fontFamily: 'montserrat_medium',fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Icon(Icons.history_toggle_off,size: 14,color:Colors.grey.shade800),
                  SizedBox(width: 6,),
                  Text(
                    '${widget.data![widget.index!].date}',
                    style: TextStyle(
                        fontSize: 10, fontFamily: 'montserrat_medium'),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/booking_id.png',height: 14,width: 14,color: Colors.grey.shade600),
                  SizedBox(width: 6,),
                  Text(
                    'Booking: ${widget.data![widget.index!].number!.toString().replaceAll('REQUEST/', '')}',
                    style: TextStyle(
                        fontSize: 10, fontFamily: 'montserrat_medium'),
                  ),
                ],
              ),*/
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15.0)),
          height: 130,
          width: double.infinity,
        ),
      ),
    );
  }
}
