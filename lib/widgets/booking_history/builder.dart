
import 'package:flutter/material.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/models/booking_history_model.dart';
import 'package:kegi_sudo/widgets/booking_history/block.dart';

class HistoryBookingBuilder extends StatelessWidget {
  HistoryBookingBuilder({Key? key, @required this.blocks,this.context})
      : super(key: key);

  final AsyncSnapshot<BookingHistoryModel>? blocks;
   BuildContext? context;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blocks!.data!.result!.bookingIds!.length,
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return HistoryBookingBlock(
          data:blocks!.data!.result!.bookingIds,
          index:index,
          context:context
        );
      },
    );
  }
}