import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kegi_sudo/models/preload_model.dart';
import 'package:kegi_sudo/screens/map_view/map_view_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as tt;

class SearchScreen extends StatefulWidget {
   SearchScreen({Key? key,this.preloadModel}) : super(key: key);

   PreloadModel? preloadModel;

  @override
  _SearchScreenState createState() => _SearchScreenState(preloadModel);
}

class _SearchScreenState extends State<SearchScreen> {
  _SearchScreenState(this.preloadModel);

  PreloadModel? preloadModel;
  final TextEditingController SearchController = TextEditingController();
  bool isLoadData=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text('Search',style: TextStyle(color: Colors.black),),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_sharp,color: Colors.black,),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [

            SizedBox(
              height: 2.h,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: Container(
                color: const Color(0xffe7e7e7),
                height: 40,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  controller: SearchController,
                  onChanged: (String query) {
                    if (query.trim().length >= 2) {
                      setState(() {
                        isLoadData = true;
                      });
                    } else {
                      print('isLoadData--------');
                      setState(() {
                        isLoadData = false;
                      });
                    }
                  },
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'montserrat_Medium'),
                  keyboardType: TextInputType.text,
                  decoration:  InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 5),
                    border:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                        fontFamily: 'montserrat_Medium',
                        color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: (){

                    }, icon: const Icon(Icons.search,color: Colors.black,),)
                  ),
                ),
              ),
            ),

           const SizedBox(height: 6,),

            !isLoadData
                ? const SizedBox()

                : ListView.builder(
                shrinkWrap: true,
                itemCount: preloadModel!.result!.serviceCategoryIds!.length,
                itemBuilder: (_, i) {
                  final ServiceCategoryIds item = preloadModel!.result!.serviceCategoryIds![i];
                  return Column(
                    children: [

                      ListTile(
                        onTap: () async{
                          FocusScope.of(context).unfocus();
                          await Get.to(
                                  () => MapViewScreen(
                                mainId: item.id,
                                preloadData: preloadModel,
                                pageKey: 'SERVICE_SCREEN',
                              ),
                              transition: tt.Transition.fadeIn,
                              duration:
                              const Duration(milliseconds: 350));
                        },
                        title: SubstringHighlight(
                          text: item.name!,                        // each string needing highlighting
                          term: SearchController.value.text,                           // user typed "m4a"
                          textStyle:  TextStyle(                       // non-highlight style
                            color: Colors.grey.shade700,
                          ),
                          textStyleHighlight: const TextStyle(              // highlight style
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const Divider()
                    ],
                  );
                })

          ],
        ),
      ),
    );

  }

}
