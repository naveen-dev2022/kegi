import 'package:flutter/material.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/widgets/booking_active/ui_builder.dart';
import 'package:sizer/sizer.dart';

class ActiveScreen extends StatefulWidget {
   ActiveScreen({Key? key,this.homeBloc}) : super(key: key);

  HomeBloc? homeBloc;
  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {

  @override
  void initState() {
    widget.homeBloc!.fetchActiveBookingBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      width: 100.w,
      child:Padding(
        padding: const EdgeInsets.only(bottom: 220.0),
        child: ActiveBookingUiBuilder(data:widget.homeBloc!.allBookingActiveData,context:context),
      )
    );
  }

}
