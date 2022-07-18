
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kegi_sudo/models/barnds_model.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/widgets/booking_active/builder.dart';
import 'package:kegi_sudo/widgets/brands_grid_view/builder.dart';
import 'package:shimmer/shimmer.dart';

class BrandsGridUiBuilder extends StatelessWidget {
  BrandsGridUiBuilder({Key? key,this.data}) : super(key: key);

  final Stream<BrandListModel>? data;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BrandListModel>(
      stream: data,
      builder:
          (BuildContext context, AsyncSnapshot<BrandListModel> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return BrandsGridBuilder(blocks: snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return StaggeredGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            axisDirection: AxisDirection.down,
            children: [
              for(int i=0;i<4;i++)
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white60,
                  child:  Container(
                    //  padding: EdgeInsets.only(left: 8,right: 8),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),),
                  ),
                )
            ],
          );
        }
      },
    );
  }
}
