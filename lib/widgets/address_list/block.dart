/*
import 'package:flutter/material.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/models/address_list_model.dart';
import 'package:kegi_sudo/screens/drawer_menu/map_with_address.dart';
import 'package:get/get.dart';

class AddressListBlock extends StatefulWidget {
  AddressListBlock({Key? key, this.data, this.index, this.pageKey,this.setter})
      : super(key: key);

  List<AddressList>? data;
  int? index;
  String? pageKey;
  Function? setter;

  @override
  State<AddressListBlock> createState() => _AddressListBlockState();
}

class _AddressListBlockState extends State<AddressListBlock> {

  final List<bool> _selected=[];
  Color unselectColor = Colors.grey.shade300;
  Color selectColor = Colors.blue;

  String findAddressType() {
    if (widget.data![widget.index!].type!.contains('home')) {
      return 'assets/images/home_icon.png';
    } else if (widget.data![widget.index!].type!.contains('office')) {
      return 'assets/images/office_icon.png';
    } else if (widget.data![widget.index!].type!.contains('store')) {
      return 'assets/images/store_icon.png';
    } else {
      return 'assets/images/other_icon.png';
    }
  }

  @override
  void initState() {
    for (var element in widget.data!) {
      _selected.add(false);
    }
    super.initState();
  }

  Color seletColor(int i) {
    return _selected[i] ? selectColor : unselectColor;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageKey!.contains('isFromBooking')) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: seletColor(widget.index!),
            )),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                if (_selected[widget.index!] == true) {
                  _selected[widget.index!] = false;
                  Get.find<MapViewController>().address.value=Get.find<MapViewController>().currentLocation!.value;
                } else {
                  for (int i = 0; i < _selected.length; i++) {
                    _selected[i] = false;
                  }
                  _selected[widget.index!] = true;
                  Get.find<MapViewController>().address.value='${widget.data![widget.index!].flatNo}, ${widget.data![widget.index!].buildingName}, ${widget.data![widget.index!].streetName} \n ${widget.data![widget.index!].countryId}';
                }
                widget.setter!((){});
               */
/* setState(() {

                });*//*

              },
              leading: ImageIcon(AssetImage(findAddressType())),
              title: Text(
                widget.data![widget.index!].type!,
                style: TextStyle(
                    fontFamily: 'montserrat_medium',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: SizedBox(
                height: 35,
                width: double.infinity,
                child: Text(
                    '${widget.data![widget.index!].flatNo}, ${widget.data![widget.index!].buildingName}, ${widget.data![widget.index!].streetName} \n ${widget.data![widget.index!].countryId}',
                    style: TextStyle(
                      fontFamily: 'montserrat_medium',
                      fontSize: 13,
                    )),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
            Divider(),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MapWithAddress(
                          pagekey: 'SAVED ADDRESS', savedData: widget.data![widget.index!])));
            },
            leading: ImageIcon(AssetImage(findAddressType())),
            title: Text(
              widget.data![widget.index!].type!,
              style: TextStyle(
                  fontFamily: 'montserrat_medium',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: SizedBox(
              height: 35,
              width: double.infinity,
              child: Text(
                  '${widget.data![widget.index!].flatNo}, ${widget.data![widget.index!].buildingName}, ${widget.data![widget.index!].streetName} \n ${widget.data![widget.index!].countryId}',
                  style: TextStyle(
                    fontFamily: 'montserrat_medium',
                    fontSize: 13,
                  )),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
          Divider(),
        ],
      );
    }
  }
}
*/
