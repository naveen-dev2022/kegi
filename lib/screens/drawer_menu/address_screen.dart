import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:kegi_sudo/blocs/homebloc.dart';
import 'package:kegi_sudo/screens/drawer_menu/map_with_address.dart';
import 'package:kegi_sudo/widgets/address_list/ui_builder.dart';
import 'package:sizer/sizer.dart';

class AddressScreen extends StatefulWidget {
   AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  HomeBloc homeBloc=HomeBloc();

  @override
  void initState() {
    homeBloc.fetchAddressListBloc();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'address_title'.tr,
          style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'montserrat_medium',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            AddressListUiBuilder(data: homeBloc.allAddressListData,pageKey:'isFromAddress'),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MapWithAddress(pagekey:'NEW ADDRESS')
                    ));
              },
              leading: const Icon(
                Icons.add,
                size: 22,
                color: Color(0xff6ed1ec),
              ),
              title:  Text(
                'add_address'.tr,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'montserrat_medium',
                    color: Color(0xff6ed1ec)),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Color(0xff6ed1ec),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
