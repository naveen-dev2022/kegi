import 'package:flutter/material.dart';
import 'package:kegi_sudo/models/barnds_model.dart';
import 'package:kegi_sudo/widgets/brands_grid_view/block.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BrandsGridBuilder extends StatelessWidget {
  BrandsGridBuilder({Key? key, @required this.blocks})
      : super(key: key);

  final AsyncSnapshot<BrandListModel>? blocks;

  @override
  Widget build(BuildContext context) {
    return  StaggeredGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      axisDirection: AxisDirection.down,
      children: [
        for(int i=0;i<blocks!.data!.result!.brandIds!.length;i++)
          BrandsGridBlock(data:blocks!.data!.result!.brandIds![i])
      ],
    );
  }

}
