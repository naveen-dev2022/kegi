import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppWidgets{

  static PreferredSizeWidget appbar(BuildContext context,{String? title}) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(50)),
            child: const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(
                Icons.arrow_back_ios,
                size: 15,
                color: Colors.black,
              ),
            )),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title??'',
        style: const TextStyle(color: Colors.black,fontSize: 15,fontFamily: 'montserrat_medium',fontWeight: FontWeight.w700),
      ),
    );
  }

  static Widget buildText(
      {required String? text, TextAlign? textAlign, double? fontSize,FontWeight? fontWeight,Color? color}) {
    return Text(
      text!,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
          color: color??Colors.black,
          fontSize: fontSize??16,
          fontFamily: 'montserrat_medium',
          fontWeight: fontWeight??FontWeight.w700),
    );
  }
}