
import 'package:flutter/material.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/widgets/booking_active/block.dart';

class ActiveBookingBuilder extends StatelessWidget {
   ActiveBookingBuilder({Key? key, @required this.blocks,this.context})
      : super(key: key);

  final AsyncSnapshot<BookingActiveModel>? blocks;
   BuildContext? context;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blocks!.data!.result!.bookingIds!.length,
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return ActiveBookingBlock(
          data:blocks!.data!.result!.bookingIds,
          index:index,
          context:context
        );
      },
    );
  }
}