import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kegi_sudo/models/timesheet_model.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:provider/provider.dart';

class TimeSheetBuilder extends StatefulWidget {
  TimeSheetBuilder({
    Key? key,
    this.saveDateLocally,
    this.data,
    this.setter,
    this.updatedTimeColor1,
    this.updatedTimeColor2,
    this.updatedTimeColor3,
    this.updatedTimeColor4,
    this.updatedTimeColor5,
    this.updatedTimeColor6,
    this.updatedTimeColor7,
    this.day,
  }) : super(key: key);

  String? saveDateLocally;
  TimeSheetModel? data;
  Function? setter;
  int? day;
  List<bool>? updatedTimeColor1;
  List<bool>? updatedTimeColor2;
  List<bool>? updatedTimeColor3;
  List<bool>? updatedTimeColor4;
  List<bool>? updatedTimeColor5;
  List<bool>? updatedTimeColor6;
  List<bool>? updatedTimeColor7;

  @override
  State<TimeSheetBuilder> createState() => _TimeSheetBuilderState();
}

class _TimeSheetBuilderState extends State<TimeSheetBuilder> {

  Color unselectColor = Colors.grey.shade300;
  Color selectColor = Colors.blue;
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  final _dayNameFormatter = DateFormat('EEE');

  @override
  void initState() {
      print('CURRENT ID----->>>>${widget.day}');
    switch (widget.day!) {
      case 1:
        for (var element in widget.data!.result!.slotIds!) {
          widget.updatedTimeColor1!.add(false);
        }
        for(int i=0;i<widget.data!.result!.slotIds!.length;i++)
          if(int.parse(DateFormat('HH:mm').format(DateTime.now()).replaceAll(':', ""))<=int.parse(widget.data!.result!.slotIds![i].name!.replaceAll(':', ''))){

          }
          else
           {

           }
        break;
      case 2:
        for (var element in widget.data!.result!.slotIds!) {
          widget.updatedTimeColor2!.add(false);
        }

        break;
      case 3:
        for (var element in widget.data!.result!.slotIds!) {
          widget.updatedTimeColor3!.add(false);
        }

        break;
      case 4:
        for (var element in widget.data!.result!.slotIds!) {
          widget.updatedTimeColor4!.add(false);
        }


        break;
      case 5:
        for (var element in widget.data!.result!.slotIds!) {
          widget.updatedTimeColor5!.add(false);
        }

        break;
      case 6:
        for (var element in widget.data!.result!.slotIds!) {
          widget.updatedTimeColor6!.add(false);
        }

        break;
      case 7:
        for (var element in widget.data!.result!.slotIds!) {
          widget.updatedTimeColor7!.add(false);
        }
        break;
    }
    super.initState();
  }

  Color seletColor(int i) {
    switch (widget.day!) {
      case 1:
        return widget.updatedTimeColor1![i] ? selectColor : unselectColor;
      case 2:
        return widget.updatedTimeColor2![i] ? selectColor : unselectColor;
      case 3:
        return widget.updatedTimeColor3![i] ? selectColor : unselectColor;
      case 4:
        return widget.updatedTimeColor4![i] ? selectColor : unselectColor;
      case 5:
        return widget.updatedTimeColor5![i] ? selectColor : unselectColor;
      case 6:
        return widget.updatedTimeColor6![i] ? selectColor : unselectColor;
      case 7:
        return widget.updatedTimeColor7![i] ? selectColor : unselectColor;
      default:
        {
          return unselectColor;
        }
    }
  }

  Widget buildWidgets(){
    print('EEEEEEEEE------->>>>${int.parse(DateFormat('HH:mm').format(DateTime.now()).replaceAll(':', ""))}');
    if(widget.day==1){
      if(int.parse(DateFormat('HH:mm').format(DateTime.now()).replaceAll(':', ""))<=int.parse(widget.data!.result!.slotIds![widget.data!.result!.slotIds!.length-1].name!.replaceAll(':', '')))
      {
        return SizedBox(
          height: 40,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for(int i=0;i<widget.data!.result!.slotIds!.length;i++)
                if(int.parse(DateFormat('HH:mm').format(DateTime.now()).replaceAll(':', ""))<=int.parse(widget.data!.result!.slotIds![i].name!.replaceAll(':', '')))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.setter!(() {
                            if (widget.updatedTimeColor1![i] == true) {
                              widget.updatedTimeColor1![i] = false;
                            } else {
                              for (int index = 0;
                              index < widget.updatedTimeColor1!.length;
                              index++) {
                                widget.updatedTimeColor1![index] = false;
                              }

                              for (int index = 0;
                              index < widget.updatedTimeColor2!.length;
                              index++) {
                                widget.updatedTimeColor2![index] = false;
                              }
                              for (int index = 0;
                              index < widget.updatedTimeColor3!.length;
                              index++) {
                                widget.updatedTimeColor3![index] = false;
                              }
                              for (int index = 0;
                              index < widget.updatedTimeColor4!.length;
                              index++) {
                                widget.updatedTimeColor4![index] = false;
                              }
                              for (int index = 0;
                              index < widget.updatedTimeColor5!.length;
                              index++) {
                                widget.updatedTimeColor5![index] = false;
                              }
                              for (int index = 0;
                              index < widget.updatedTimeColor6!.length;
                              index++) {
                                widget.updatedTimeColor6![index] = false;
                              }
                              for (int index = 0;
                              index < widget.updatedTimeColor7!.length;
                              index++) {
                                widget.updatedTimeColor7![index] = false;
                              }

                              widget.updatedTimeColor1![i] = true;
                              Provider.of<DataListner>(context, listen: false)
                                  .SetDatePickerDataLocally(
                                  '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 0)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 0)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 0)))}, ${widget.data!.result!.slotIds![i].name}');
                              Provider.of<DataListner>(context, listen: false)
                                  .SetTimeSlotId(
                                  widget.data!.result!.slotIds![i].id);
                              Provider.of<DataListner>(context, listen: false)
                                  .setConfirmDate(DateFormat('y/M/d').format(
                                  _currentDate.add(const Duration(days: 0))));
                            }
                          });
                        },
                        child:Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: seletColor(i),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            widget.data!.result!.slotIds![i].name!,
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
                  )
                else
                  const SizedBox()
            ],),
        );
      }
     else{
       return SizedBox();
      }
    }
    else{
      return SizedBox(
        height: 40,
        width: double.infinity,
        child: ListView.builder(
          itemCount: widget.data!.result!.slotIds!.length,
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    switch (widget.day!) {
                      case 2:
                        widget.setter!(() {
                          if (widget.updatedTimeColor2![i] == true) {
                            print('updatedTimeColor![i]==true');
                            widget.updatedTimeColor2![i] = false;
                          } else {
                            print(
                                'updatedTimeColor![2]====else--${widget.updatedTimeColor1!.map<bool>((v) => false).toList()}');
                            for (int index = 0;
                            index < widget.updatedTimeColor1!.length;
                            index++) {
                              widget.updatedTimeColor1![index] = false;
                            }

                            for (int index = 0;
                            index < widget.updatedTimeColor2!.length;
                            index++) {
                              widget.updatedTimeColor2![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor3!.length;
                            index++) {
                              widget.updatedTimeColor3![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor4!.length;
                            index++) {
                              widget.updatedTimeColor4![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor5!.length;
                            index++) {
                              widget.updatedTimeColor5![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor6!.length;
                            index++) {
                              widget.updatedTimeColor6![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor7!.length;
                            index++) {
                              widget.updatedTimeColor7![index] = false;
                            }
                            widget.updatedTimeColor2![i] = true;
                            Provider.of<DataListner>(context, listen: false)
                                .SetDatePickerDataLocally(
                                '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 1)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 1)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 1)))}, ${widget.data!.result!.slotIds![i].name}');
                            Provider.of<DataListner>(context, listen: false)
                                .SetTimeSlotId(
                                widget.data!.result!.slotIds![i].id);
                            Provider.of<DataListner>(context, listen: false)
                                .setConfirmDate(DateFormat('y/M/d').format(
                                _currentDate.add(const Duration(days: 1))));
                          }
                        });
                        break;
                      case 3:
                        widget.setter!(() {
                          if (widget.updatedTimeColor3![i] == true) {
                            print('updatedTimeColor![i]==true');
                            widget.updatedTimeColor3![i] = false;
                          } else {
                            print('updatedTimeColor![i]====else');
                            for (int index = 0;
                            index < widget.updatedTimeColor1!.length;
                            index++) {
                              widget.updatedTimeColor1![index] = false;
                            }

                            for (int index = 0;
                            index < widget.updatedTimeColor2!.length;
                            index++) {
                              widget.updatedTimeColor2![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor3!.length;
                            index++) {
                              widget.updatedTimeColor3![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor4!.length;
                            index++) {
                              widget.updatedTimeColor4![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor5!.length;
                            index++) {
                              widget.updatedTimeColor5![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor6!.length;
                            index++) {
                              widget.updatedTimeColor6![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor7!.length;
                            index++) {
                              widget.updatedTimeColor7![index] = false;
                            }
                            widget.updatedTimeColor3![i] = true;
                            Provider.of<DataListner>(context, listen: false)
                                .SetDatePickerDataLocally(
                                '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 2)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 2)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 2)))}, ${widget.data!.result!.slotIds![i].name}');
                            Provider.of<DataListner>(context, listen: false)
                                .SetTimeSlotId(
                                widget.data!.result!.slotIds![i].id);
                            Provider.of<DataListner>(context, listen: false)
                                .setConfirmDate(DateFormat('y/M/d').format(
                                _currentDate.add(const Duration(days: 2))));
                          }
                        });
                        break;
                      case 4:
                        widget.setter!(() {
                          if (widget.updatedTimeColor4![i] == true) {
                            print('updatedTimeColor![i]==true');
                            widget.updatedTimeColor4![i] = false;
                          } else {
                            print('updatedTimeColor![i]====else');
                            for (int index = 0;
                            index < widget.updatedTimeColor1!.length;
                            index++) {
                              widget.updatedTimeColor1![index] = false;
                            }

                            for (int index = 0;
                            index < widget.updatedTimeColor2!.length;
                            index++) {
                              widget.updatedTimeColor2![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor3!.length;
                            index++) {
                              widget.updatedTimeColor3![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor4!.length;
                            index++) {
                              widget.updatedTimeColor4![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor5!.length;
                            index++) {
                              widget.updatedTimeColor5![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor6!.length;
                            index++) {
                              widget.updatedTimeColor6![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor7!.length;
                            index++) {
                              widget.updatedTimeColor7![index] = false;
                            }
                            widget.updatedTimeColor4![i] = true;

                            Provider.of<DataListner>(context, listen: false)
                                .SetDatePickerDataLocally(
                                '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 3)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 3)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 3)))}, ${widget.data!.result!.slotIds![i].name}');
                            Provider.of<DataListner>(context, listen: false)
                                .SetTimeSlotId(
                                widget.data!.result!.slotIds![i].id);
                            Provider.of<DataListner>(context, listen: false)
                                .setConfirmDate(DateFormat('y/M/d').format(
                                _currentDate.add(const Duration(days: 3))));
                          }
                        });
                        break;
                      case 5:
                        widget.setter!(() {
                          if (widget.updatedTimeColor5![i] == true) {
                            print('updatedTimeColor![i]==true');
                            widget.updatedTimeColor5![i] = false;
                          } else {
                            print('updatedTimeColor![i]====else');
                            for (int index = 0;
                            index < widget.updatedTimeColor1!.length;
                            index++) {
                              widget.updatedTimeColor1![index] = false;
                            }

                            for (int index = 0;
                            index < widget.updatedTimeColor2!.length;
                            index++) {
                              widget.updatedTimeColor2![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor3!.length;
                            index++) {
                              widget.updatedTimeColor3![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor4!.length;
                            index++) {
                              widget.updatedTimeColor4![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor5!.length;
                            index++) {
                              widget.updatedTimeColor5![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor6!.length;
                            index++) {
                              widget.updatedTimeColor6![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor7!.length;
                            index++) {
                              widget.updatedTimeColor7![index] = false;
                            }
                            widget.updatedTimeColor5![i] = true;

                            Provider.of<DataListner>(context, listen: false)
                                .SetDatePickerDataLocally(
                                '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 4)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 4)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 4)))}, ${widget.data!.result!.slotIds![i].name}');
                            Provider.of<DataListner>(context, listen: false)
                                .SetTimeSlotId(
                                widget.data!.result!.slotIds![i].id);
                            Provider.of<DataListner>(context, listen: false)
                                .setConfirmDate(DateFormat('y/M/d').format(
                                _currentDate.add(const Duration(days: 4))));
                          }
                        });
                        break;
                      case 6:
                        widget.setter!(() {
                          if (widget.updatedTimeColor6![i] == true) {
                            print('updatedTimeColor![i]==true');
                            widget.updatedTimeColor6![i] = false;
                          } else {
                            print('updatedTimeColor![i]====else');
                            for (int index = 0;
                            index < widget.updatedTimeColor1!.length;
                            index++) {
                              widget.updatedTimeColor1![index] = false;
                            }

                            for (int index = 0;
                            index < widget.updatedTimeColor2!.length;
                            index++) {
                              widget.updatedTimeColor2![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor3!.length;
                            index++) {
                              widget.updatedTimeColor3![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor4!.length;
                            index++) {
                              widget.updatedTimeColor4![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor5!.length;
                            index++) {
                              widget.updatedTimeColor5![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor6!.length;
                            index++) {
                              widget.updatedTimeColor6![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor7!.length;
                            index++) {
                              widget.updatedTimeColor7![index] = false;
                            }
                            widget.updatedTimeColor6![i] = true;

                            Provider.of<DataListner>(context, listen: false)
                                .SetDatePickerDataLocally(
                                '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 5)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 5)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 5)))}, ${widget.data!.result!.slotIds![i].name}');
                            Provider.of<DataListner>(context, listen: false)
                                .SetTimeSlotId(
                                widget.data!.result!.slotIds![i].id);
                            Provider.of<DataListner>(context, listen: false)
                                .setConfirmDate(DateFormat('y/M/d').format(
                                _currentDate.add(const Duration(days: 5))));
                          }
                        });
                        break;
                      case 7:
                        widget.setter!(() {
                          if (widget.updatedTimeColor7![i] == true) {
                            print('updatedTimeColor![i]==true');
                            widget.updatedTimeColor7![i] = false;
                          } else {
                            print('updatedTimeColor![i]====else');
                            for (int index = 0;
                            index < widget.updatedTimeColor1!.length;
                            index++) {
                              widget.updatedTimeColor1![index] = false;
                            }

                            for (int index = 0;
                            index < widget.updatedTimeColor2!.length;
                            index++) {
                              widget.updatedTimeColor2![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor3!.length;
                            index++) {
                              widget.updatedTimeColor3![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor4!.length;
                            index++) {
                              widget.updatedTimeColor4![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor5!.length;
                            index++) {
                              widget.updatedTimeColor5![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor6!.length;
                            index++) {
                              widget.updatedTimeColor6![index] = false;
                            }
                            for (int index = 0;
                            index < widget.updatedTimeColor7!.length;
                            index++) {
                              widget.updatedTimeColor7![index] = false;
                            }
                            widget.updatedTimeColor7![i] = true;
                            Provider.of<DataListner>(context, listen: false)
                                .SetDatePickerDataLocally(
                                '${_dayNameFormatter.format(_currentDate.add(const Duration(days: 6)))}, ${_monthFormatter.format(_currentDate.add(const Duration(days: 6)))} ${_dayFormatter.format(_currentDate.add(const Duration(days: 6)))}, ${widget.data!.result!.slotIds![i].name}');
                            Provider.of<DataListner>(context, listen: false)
                                .SetTimeSlotId(
                                widget.data!.result!.slotIds![i].id);
                            Provider.of<DataListner>(context, listen: false)
                                .setConfirmDate(DateFormat('y/M/d').format(
                                _currentDate.add(const Duration(days: 6))));
                          }
                        });
                        break;
                    }
                  },
                  child:Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: seletColor(i),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.data!.result!.slotIds![i].name!,
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

  @override
  Widget build(BuildContext context) {
    print('%%%%%%-----${DateFormat('HH:mm').format(DateTime.now())}');
    return buildWidgets();
  }
}
