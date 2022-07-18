import 'package:flutter/material.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/widgets/booking_history/ui_builder.dart';
import 'package:sizer/sizer.dart';


class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key,this.homeBloc}) : super(key: key);

  HomeBloc? homeBloc;
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  void initState() {
    widget.homeBloc!.fetchHistoryBookingBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100.h,
        width: 100.w,
        child:Padding(
          padding: const EdgeInsets.only(bottom: 220.0),
          child: HistoryBookingUiBuilder(data:widget.homeBloc!.allBookingHistoryData,context:context),
        )
    );
  }

}
