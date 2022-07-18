import 'package:flutter/material.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/screens/my_booking/active_screen.dart';
import 'package:kegi_sudo/screens/my_booking/history_screen.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';

class MyBookingScreen extends StatefulWidget {

  @override
  _MyBookingScreenState createState() =>
      _MyBookingScreenState();
}

class _MyBookingScreenState
    extends State<MyBookingScreen> {

  int _currentSelection = 0;
  bool activeColor=true;
  bool historyColor=false;
  HomeBloc homeBloc=HomeBloc();
  List<Widget>? _Screens;

  @override
  void initState() {
    _Screens=[
      ActiveScreen(homeBloc:homeBloc),
      HistoryScreen(homeBloc: homeBloc,)
    ];
    super.initState();
  }

  @override
  void dispose() {
   // homeBloc.fetchActiveBookingBloc();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Map<int, Widget> _children = {
      0: Text('ACTIVE',style: TextStyle(fontFamily: 'montserrat_medium',fontSize: 15,color:!activeColor?Colors.grey:Colors.white ),),
      1: Text('HISTORY',style: TextStyle(fontFamily: 'montserrat_medium',fontSize: 15,color:!historyColor?Colors.grey:Colors.white),),
    };
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             SizedBox(height: 2.h,),
              SizedBox(
                  width: 500.0,
                  child:
                  MaterialSegmentedControl(
                    children: _children,
                    selectionIndex: _currentSelection,
                    borderColor: Colors.white,
                    selectedColor:Color(0xff06CEEA),
                    unselectedColor: Color(0xffc2ebf3),
                    borderRadius: 32.0,
                    onSegmentChosen: (index) {
                      setState(() {
                        if(int.parse(index.toString())==0){
                          activeColor=true;
                          historyColor=false;
                        }
                        else{
                          activeColor=false;
                          historyColor=true;
                        }
                        _currentSelection = int.parse(index.toString());
                      });
                    },
                  )
              ),
              SizedBox(height: 3.h,),
              Padding(
                padding: EdgeInsets.only(left: 15,right: 15),
                  child: _Screens![_currentSelection]),
            ],
          ),
        ),
      ),
    );
  }
}