
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/models/address_list_model.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/screens/drawer_menu/map_with_address.dart';
import 'package:kegi_sudo/widgets/address_list/block.dart';
import 'package:kegi_sudo/widgets/booking_active/block.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:kegi_sudo/models/address_list_model.dart';

class AddressListBuilder extends StatefulWidget {
  AddressListBuilder({Key? key, @required this.blocks,this.pageKey,this.setter})
      : super(key: key);

  String? pageKey;
  final AsyncSnapshot<AddressListModel>? blocks;
  Function? setter;

  @override
  State<AddressListBuilder> createState() => _AddressListBuilderState();

}

class _AddressListBuilderState extends State<AddressListBuilder> {

  final List<bool> _selected=[];
  Color unselectColor = Colors.white;
  Color selectColor = Colors.blue;
  ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  MapViewController _controller = Get.put(MapViewController());

  String findAddressType(List<AddressList>? data,int index) {
    if (data![index].type!.contains('home')) {
      return 'assets/images/home_icon.png';
    } else if (data[index].type!.contains('office')) {
      return 'assets/images/office_icon.png';
    } else if (data[index].type!.contains('store')) {
      return 'assets/images/store_icon.png';
    } else {
      return 'assets/images/other_icon.png';
    }
  }

 // List<AddressList>? mockupAddressList=[];

  @override
  void initState() {
    _controller.addressListData.value=widget.blocks!.data!;

/*    for(int i=0;i<widget.blocks!.data!.result!.addressList!.length;i++){
      if(_controller.addressListData.value.result!.addressList![i].addressId==widget.blocks!.data!.result!.addressList![i].addressId){
        mockupAddressList!.add(widget.blocks!.data!.result!.addressList![i]);
      }

    }*/


    for (int i=0;i<widget.blocks!.data!.result!.addressList!.length;i++) {
      print('');
      if(i==0){

        _controller.flatNo!.value=widget.blocks!.data!.result!.addressList![i].flatNo!;
        _controller.buildingName!.value=widget.blocks!.data!.result!.addressList![i].buildingName!;
        _controller.streetName!.value=widget.blocks!.data!.result!.addressList![i].streetName!;
        _controller.latitude!.value=double.parse(widget.blocks!.data!.result!.addressList![i].latitude!);
        _controller.longitude!.value=double.parse(widget.blocks!.data!.result!.addressList![i].longitude!);
        _controller.countryFromApi!.value=widget.blocks!.data!.result!.addressList![i].countryId!;
       _selected.add(true);
      }
     else{
        _selected.add(false);
      }
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      widget.blocks!.data!.result!.addressList!.isNotEmpty?_scrollController.jumpTo(index: 0):null;
    });
  //  _scrollController.scrollTo(index: 0, duration: const Duration(seconds: 1));
    super.initState();
  }

  Color seletColor(int i) {
    return _selected[i] ? selectColor : unselectColor;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: widget.blocks!.data!.result!.addressList!.length,
      itemScrollController: _scrollController,
      addAutomaticKeepAlives: true,
      itemPositionsListener: itemPositionsListener,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        if (widget.pageKey!.contains('isFromBooking')) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: seletColor(index),
                )),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
/*
                    if (_selected[index] == true) {
                      _selected[index] = false;
                      Get.find<MapViewController>().address.value=Get.find<MapViewController>().currentLocation!.value;
                      Get.find<MapViewController>().currentCountry!.value=Get.find<MapViewController>().country!.value;
                      Get.find<MapViewController>().currentPostalCode!.value=Get.find<MapViewController>().postalCode!.value;
                      Get.find<MapViewController>().currentCity!.value=Get.find<MapViewController>().city!.value;
                      Get.find<MapViewController>().currentRegion!.value = Get.find<MapViewController>().region!.value;

                    } else {


                      Get.find<MapViewController>().address.value ='${widget.blocks!.data!.result!.addressList![index].flatNo}, ${widget.blocks!.data!.result!.addressList![index].buildingName}, ${widget.blocks!.data!.result!.addressList![index].streetName} \n ${widget.blocks!.data!.result!.addressList![index].countryId}';
                      Get.find<MapViewController>().currentCountry!.value = widget.blocks!.data!.result!.addressList![index].countryId!;
                      Get.find<MapViewController>().currentPostalCode!.value ='';
                      Get.find<MapViewController>().currentCity!.value ='';
                      Get.find<MapViewController>().currentRegion!.value ='';
                      print('%%%%%%%%------current address----${Get.find<MapViewController>().address.value}');

                    }*/

                    for (int i = 0; i < _selected.length; i++) {
                      _selected[i] = false;
                    }

                    _controller.flatNo!.value=widget.blocks!.data!.result!.addressList![index].flatNo!;
                    _controller.buildingName!.value=widget.blocks!.data!.result!.addressList![index].buildingName!;
                    _controller.streetName!.value=widget.blocks!.data!.result!.addressList![index].streetName!;
                    _controller.countryFromApi!.value=widget.blocks!.data!.result!.addressList![index].countryId!;
                    _controller.latitude!.value=double.parse(widget.blocks!.data!.result!.addressList![index].latitude!);
                    _controller.longitude!.value=double.parse(widget.blocks!.data!.result!.addressList![index].longitude!);

                    _selected[index] = true;

                    widget.setter!((){});
                  },
                  leading: ImageIcon(AssetImage(findAddressType(widget.blocks!.data!.result!.addressList!,index))),
                  title: Text(
                    widget.blocks!.data!.result!.addressList![index].type!,
                    style: TextStyle(
                        fontFamily: 'montserrat_medium',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: Text(
                        '${widget.blocks!.data!.result!.addressList![index].flatNo}, ${widget.blocks!.data!.result!.addressList![index].buildingName}, ${widget.blocks!.data!.result!.addressList![index].streetName} \n ${widget.blocks!.data!.result!.addressList![index].countryId}',
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
                              pagekey: 'SAVED ADDRESS', savedData: widget.blocks!.data!.result!.addressList![index])));
                },
                leading: ImageIcon(AssetImage(findAddressType(widget.blocks!.data!.result!.addressList!,index))),
                title: Text(
                  widget.blocks!.data!.result!.addressList![index].type!,
                  style: TextStyle(
                      fontFamily: 'montserrat_medium',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: Text(
                      '${widget.blocks!.data!.result!.addressList![index].flatNo}, ${widget.blocks!.data!.result!.addressList![index].buildingName}, ${widget.blocks!.data!.result!.addressList![index].streetName} \n ${widget.blocks!.data!.result!.addressList![index].countryId}',
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
      },
    );

  }
}