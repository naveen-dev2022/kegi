import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:kegi_sudo/controller/mapview_controller.dart';
import 'package:kegi_sudo/provider/delivery_data_screen_listner.dart';
import 'package:kegi_sudo/resources/api_provider_map.dart';
import 'package:kegi_sudo/screens/map_view/location_name.dart';
import 'package:kegi_sudo/utils/app_methods.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:kegi_sudo/screens/map_view/map_view_screen.dart';
import 'package:sizer/sizer.dart';

class SearchCityScreen extends StatefulWidget {
  SearchCityScreen({this.lat,this.lang});

  double? lat;
  double? lang;
  @override
  _SearchCityScreenState createState() => _SearchCityScreenState(lat,lang);
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  _SearchCityScreenState(this.lat,this.lang);

  double? lat;
  double? lang;
  final TextEditingController _destinationController = TextEditingController();
  PlaceApi _placeApi = PlaceApi.instance;
  bool? buscando = false;
  List<Place>? _predictions = [];
  Rx<TextEditingController> _controller = TextEditingController().obs;
  FindLocationName findLocationName = FindLocationName();
  Placemark? currentPlaceMark;


  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    currentPlaceMark=await AppMethods.getPLaceMarkFromLatLong(lat!,lang!);
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  _search(String query) {
    _placeApi
        .searchPredictions(query)
        .asStream()
        .listen((List<Place> predictions) {
      setState(() {
        buscando = false;
        _predictions = predictions;
        //  print('Resultados: ${predictions.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        title: const Text(
          'Location',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'montserrat_medium',
              fontWeight: FontWeight.w800,
              color: Colors.black),
        ),
        backgroundColor: Colors.white60,
        shadowColor: Colors.transparent,
      ),
      body:currentPlaceMark==null?Container():_buildChildWidget()
    );
  }

  Widget _buildChildWidget(){
    return  SizedBox(
      height: 100.h,
      width: 100.w,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 35,
                  width: 65.w,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6)),
                  child: TextField(
                    controller: _controller.value,
                    onChanged: (String query) {
                      if (query.trim().length > 2) {
                        setState(() {
                          buscando = true;
                        });
                        _search(query);
                      } else {
                        if (buscando! || _predictions!.isNotEmpty) {
                          setState(() {
                            buscando = false;
                            _predictions = [];
                          });
                        }
                      }
                    },
                    enabled: true,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 6),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search for a city',
                        hintStyle: TextStyle(
                            fontSize: 12, fontFamily: 'montserrat_regular')),
                  ),
                ),
                SizedBox(width: 8,),
                  SizedBox(
                  width: 22.w,
                  height: 37,
                  child: Center(
                    child: Text('${currentPlaceMark!.country}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'quicksand_regular',
                        )),
                  ),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            color: Colors.grey.shade200,
            height: 30,
            width: 100.w,
            child: const Padding(
              padding: EdgeInsets.only(left: 15, top: 6),
              child: Text(
                'Search locations',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'quicksand_regular',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          buscando!
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
              shrinkWrap: true,
              itemCount: _predictions!.length,
              itemBuilder: (_, i) {
                final Place item = _predictions![i];
                return ListTile(
                  onTap: () {
                  /*  Get.find<MapViewController>().card1 = false;
                    Get.find<MapViewController>().card2 = false;
                    Get.find<MapViewController>().card3 = false;
                    Get.find<MapViewController>().card4 = false;*/
                  //  Get.find<MapViewController>().descriptionController.value.clear();
                  //  Provider.of<DataListner>(context, listen: false).imageFileList = [];
                 /*   Provider.of<DataListner>(context, listen: false).datePickerLocally = '';
                    Provider.of<DataListner>(context, listen: false)
                        .SetDatePickerData('Select Time');*/
                    FocusScope.of(context).unfocus();
                    print('#####${item.place_id}');
                    findLocationName
                        .displayPrediction(item.place_id)
                        .then((value) {
                      int count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 3;
                      });
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  MapViewScreen(
                        preloadData:
                        Get.find<MapViewController>()
                            .preloadData
                            .value,
                        mainId: Get.find<MapViewController>()
                            .mainId
                            .value,
                        pageKey: 'NEARBY_PLACES',
                        nearby_placelat: value
                            .result.geometry!.location.lat,
                        nearby_placelng: value
                            .result.geometry!.location.lng,
                      ),));
                    });
                  },
                  title: Obx(()=>SubstringHighlight(
                    text: item.description!,                        // each string needing highlighting
                    term: _controller.value.text,                           // user typed "m4a"
                    textStyle:  TextStyle(                       // non-highlight style
                      color: Colors.grey.shade700,
                    ),
                    textStyleHighlight: const TextStyle(              // highlight style
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  leading: const Icon(Icons.location_on,
                      color: Color(0xff5888B6)),
                );
              })
        ],
      ),
    );
  }

}

class Place {
  final String? place_id, description;

  Place({this.place_id, this.description});

  static Place fromJson(Map<String, dynamic> json) {
    return Place(
      place_id: json['place_id'],
      description: json['description'],
    );
  }

}
