
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/utils/end_drawer.dart';
import 'package:kegi_sudo/widgets/banner_slider/ui_builder.dart';
import 'package:kegi_sudo/widgets/brands_grid_view/ui_builder.dart';
import 'package:sizer/sizer.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../resources/repository.dart';
import '../utils/shared_preference.dart';
import 'drawer_menu/contactus.dart';
import 'drawer_menu/refer_earn.dart';
import 'language_screen.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({Key? key}) : super(key: key);

  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {

  HomeBloc homeBloc=HomeBloc();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Repository repository = Repository();

  @override
  void initState() {
    homeBloc.fetchBannerListBloc();
    homeBloc.fetchBrandListBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        endDrawer: const EndDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children:  [
            _appbarRow(),
            BannerSliderUIBuilder(data: homeBloc.allBannerListData,),
            SizedBox(height: 2.h,),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: BrandsGridUiBuilder(data: homeBloc.allBrandListData,),
            )
          ],),
        ),
      ),
    );
  }

  Widget _appbarRow(){
    return SizedBox(
      width: 100.w,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Brands',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'montserrat_medium',
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
                onPressed: () {
                  _key.currentState!.openEndDrawer();
                },
                icon: const Icon(Icons.view_headline))
          ],
        ),
      ),
    );
  }
}
