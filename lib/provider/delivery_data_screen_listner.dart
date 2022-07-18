import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kegi_sudo/models/favorite_model.dart';
import 'package:kegi_sudo/models/preload_model.dart';

class DataListner extends ChangeNotifier {

String datePicker='Select Time';
String datePickerLocally='';
List<Favorite> favListFromProvider =[];
bool loadData=false;
List<bool> likedIconColor = [];
List<XFile>? imageFileList=[];
List<XFile>? photo=[];
int? timeSoltId;
TextEditingController promoApplyCheck=TextEditingController();
String? confirmDate;
String? locationName;
String? vicinity;
String? selectedDay;
int timeRemaining=59;
String? getMonthName;
DateTime? dayMonthYear;
TextEditingController descriptionController = TextEditingController();


setBookingDescription(String? value) {
  descriptionController.text=value!;
  notifyListeners();
}


setCompleteDate(DateTime? value) {
  dayMonthYear=value!;
  notifyListeners();
}

setSelectedDay(String? value) {
  selectedDay=value!;
  notifyListeners();
}

setlocationName(String? value) {
  locationName=value!;
  notifyListeners();
}

setvicinity(String? value) {
  vicinity=value!;
  notifyListeners();
}

setConfirmDate(String? value) {
  confirmDate=value!;
  notifyListeners();
}

setPromoApplyCheck(String? value) {
  promoApplyCheck.text=value!;
  notifyListeners();
}

SetTimeSlotId(int? value) {
  timeSoltId=value;
  notifyListeners();
}

SetImageDataFromCamera(XFile value) {
//  photo!.add(value);
  imageFileList!.add(value);
  notifyListeners();
}

SetImageDataFromGallery(List<XFile> value) {
  imageFileList!.addAll(value);
  notifyListeners();
}

SetDatePickerDataLocally(String value) {
  datePickerLocally=value;
  notifyListeners();
}

Future SetToLoadData(bool value) async{
  loadData=await value;
  notifyListeners();
}

  SetDatePickerData(String value) {
    datePicker=value;
    notifyListeners();
  }

SetFavListData(List<Favorite> value) {

  for(int i=0;i<value.length;i++){
    likedIconColor.add(true);
  }

  favListFromProvider=value;

  notifyListeners();
}

}
