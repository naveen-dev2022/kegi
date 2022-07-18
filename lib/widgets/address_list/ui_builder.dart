import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/models/address_list_model.dart';
import 'package:kegi_sudo/widgets/address_list/builder.dart';
import 'package:shimmer/shimmer.dart';

class AddressListUiBuilder extends StatelessWidget {
  AddressListUiBuilder({Key? key,this.data,this.pageKey,this.setter}) : super(key: key);

  final Stream<AddressListModel>? data;
  String? pageKey;
  Function? setter;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddressListModel>(
      stream: data,
      builder:
          (BuildContext context, AsyncSnapshot<AddressListModel> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return AddressListBuilder(blocks: snapshot,pageKey:pageKey,setter:setter);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return ListView.builder(
            itemCount:4,
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white60,
                  child:  Container(
                    height: 80,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
