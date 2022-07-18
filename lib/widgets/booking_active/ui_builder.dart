
import 'package:flutter/material.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/widgets/booking_active/builder.dart';
import 'package:shimmer/shimmer.dart';

class ActiveBookingUiBuilder extends StatelessWidget {
   ActiveBookingUiBuilder({Key? key,this.data,this.context}) : super(key: key);

  final Stream<BookingActiveModel>? data;
  BuildContext? context;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BookingActiveModel>(
      stream: data,
      builder:
          (BuildContext context, AsyncSnapshot<BookingActiveModel> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return ActiveBookingBuilder(blocks: snapshot,context:context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return ListView.builder(
            itemCount:6,
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white60,
                  child:  Container(
                    height: 140,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
