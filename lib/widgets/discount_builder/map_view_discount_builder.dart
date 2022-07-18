import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:kegi_sudo/models/promocode_model.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:provider/provider.dart';

class DiscountBuilder extends StatelessWidget {
  DiscountBuilder({Key? key, this.data}) : super(key: key);

  PromoCodeModel? data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: data!.result!.promoCodeIds!.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  data!.result!.promoCodeIds![index].code!,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'montserrat_bold'),
                ),
                subtitle: Text(data!.result!.promoCodeIds![index].notes!,
                    style: const TextStyle(
                        fontSize: 12, fontFamily: 'montserrat_medium')),
                trailing: TextButton(
                  onPressed: () {
                    Provider.of<DataListner>(context, listen: false).setPromoApplyCheck(data!.result!.promoCodeIds![index].code!);
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                        color: const Color(0xff6ed1ec),
                        borderRadius: BorderRadius.circular(6)),
                    child:  Center(
                      child: Text(
                        'apply_code'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'montserrat_medium',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          );
        });
  }
}
