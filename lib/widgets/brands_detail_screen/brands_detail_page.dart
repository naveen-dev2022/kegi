import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kegi_sudo/models/banner_model.dart';
import 'package:kegi_sudo/models/brands_common_model.dart';
import 'package:sizer/sizer.dart';

class BrandsDetailScreen extends StatefulWidget {
  BrandsDetailScreen({Key? key, this.data}) : super(key: key);

  final BrandsCommonData? data;

  @override
  _BrandsDetailScreenState createState() => _BrandsDetailScreenState(data);
}

class _BrandsDetailScreenState extends State<BrandsDetailScreen> {
  _BrandsDetailScreenState(this.data);

  final BrandsCommonData? data;

  @override
  Widget build(BuildContext context) {
    String uri = 'data:image/png;base64,${data!.image}';
    Uint8List _bytes = base64.decode(uri.split(',').last);
    Uint8List encodeedimg = _bytes;
    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            SizedBox(
              height: 3.90.h,
            ),
            Stack(
              children: [
                Container(
                  height: 120,
                  width: 100.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill, image: MemoryImage(encodeedimg))),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: IconButton(
                    icon: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.white,
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
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Text(data!.name!,
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'montserrat_bold',
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Text(
                          data!.notes!,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'montserrat_medium',
                              color: Colors.grey.shade600)),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
