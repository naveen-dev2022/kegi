import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kegi_sudo/models/banner_model.dart';
import 'package:kegi_sudo/models/barnds_model.dart';
import 'package:kegi_sudo/models/brands_common_model.dart';
import 'package:kegi_sudo/widgets/brands_detail_screen/brands_detail_page.dart';
import 'package:shimmer/shimmer.dart';

class BrandsGridBlock extends StatelessWidget {
  BrandsGridBlock({@required this.data});

  BrandIds? data;

  @override
  Widget build(BuildContext context) {
    String uri = 'data:image/jpeg;base64,${data!.image}';
    Uint8List _bytes = base64.decode(uri.split(',').last);
    Uint8List encodeedimg = _bytes;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
      child: SizedBox(
        height: 120,
        width: 120,
        child: GestureDetector(
          onTap: () {
            BrandsCommonData brandsCommonData=BrandsCommonData(id: data!.id,name: data!.name,image:data!.image,notes: data!.notes);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BrandsDetailScreen(data: brandsCommonData)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Semantics(
              label: 'Brands',
              child:  Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: MemoryImage(encodeedimg))),
              ),
            ),
          ),
        ),
      ),
    );
  }

/*
  void _launchUrl(String url) async {
    if (url != null) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }*/
}
