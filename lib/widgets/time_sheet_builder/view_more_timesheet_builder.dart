import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kegi_sudo/models/timesheet_model.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:provider/provider.dart';

class ViewMoreTimeSheetBuilder extends StatefulWidget {
  ViewMoreTimeSheetBuilder({Key? key, this.data, this.setter})
      : super(key: key);

  Function? setter;
  TimeSheetModel? data;

  @override
  _ViewMoreTimeSheetBuilderState createState() =>
      _ViewMoreTimeSheetBuilderState(data);
}

class _ViewMoreTimeSheetBuilderState extends State<ViewMoreTimeSheetBuilder> {
  _ViewMoreTimeSheetBuilderState(this.data);

  TimeSheetModel? data;
  Color unselectColor = Colors.grey.shade300;
  Color selectColor = Colors.blue;
  List<bool>? updatedTimeColor1 = [];
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  final _dayNameFormatter = DateFormat('EEE');

  @override
  void initState() {
    print('WWWWWWWW--------${data!.result!.slotIds!.length}');
    for (int i = 0; i < data!.result!.slotIds!.length; i++) {
      updatedTimeColor1!.add(false);
    }
    super.initState();
  }

  Color seletColor(int i) {
    return updatedTimeColor1![i] ? selectColor : unselectColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ListView.builder(
        itemCount: data!.result!.slotIds!.length,
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  widget.setter!(() {
                    if (updatedTimeColor1![i] == true) {
                      updatedTimeColor1![i] = false;
                    } else {
                      for (int index = 0;
                          index < updatedTimeColor1!.length;
                          index++) {
                        updatedTimeColor1![index] = false;
                      }
                      updatedTimeColor1![i] = true;
                      int day = (int.parse(
                          Provider.of<DataListner>(context, listen: false)
                              .selectedDay!));
                      Provider.of<DataListner>(context, listen: false)
                          .SetTimeSlotId(data!.result!.slotIds![i].id);
                      Provider.of<DataListner>(context, listen: false)
                          .SetDatePickerDataLocally(
                              '${DateFormat('EEEE').format(Provider.of<DataListner>(context, listen: false).dayMonthYear!)}, ${DateFormat('MMM').format(Provider.of<DataListner>(context, listen: false).dayMonthYear!)}, ${Provider.of<DataListner>(context, listen: false).selectedDay!}, ${data!.result!.slotIds![i].name}');
                      Provider.of<DataListner>(context, listen: false)
                          .setConfirmDate('${Provider.of<DataListner>(context, listen: false).dayMonthYear!.year}/${Provider.of<DataListner>(context, listen: false).dayMonthYear!.month}/${Provider.of<DataListner>(context, listen: false).dayMonthYear!.day}');
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: seletColor(i),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    data!.result!.slotIds![i].name!,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              )
            ],
          );
        },
      ),
    );
  }
}
