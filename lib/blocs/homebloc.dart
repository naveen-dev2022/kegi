import 'package:kegi_sudo/models/address_list_model.dart';
import 'package:kegi_sudo/models/banner_model.dart';
import 'package:kegi_sudo/models/barnds_model.dart';
import 'package:kegi_sudo/models/booking_active_model.dart';
import 'package:kegi_sudo/models/booking_history_model.dart';
import 'package:kegi_sudo/models/login_model.dart';
import 'package:kegi_sudo/models/nearbyplace_model.dart';
import 'package:kegi_sudo/models/otp_model.dart';
import 'package:kegi_sudo/models/otp_registration_model.dart';
import 'package:kegi_sudo/models/preload_model.dart';
import 'package:kegi_sudo/models/promo_apply_model.dart';
import 'package:kegi_sudo/models/promocode_model.dart';
import 'package:kegi_sudo/models/timesheet_model.dart';
import 'package:kegi_sudo/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final Repository _repository = Repository();

  final BehaviorSubject<OtpModel> _getOtpData = BehaviorSubject<OtpModel>();
  final BehaviorSubject<LoginModel> _getLoginData = BehaviorSubject<LoginModel>();
  final BehaviorSubject<NearByPlacesModel> _getNearByPlaces = BehaviorSubject<NearByPlacesModel>();
  final BehaviorSubject<RegistrationOtpModel> _getRegisOtp = BehaviorSubject<RegistrationOtpModel>();
  final BehaviorSubject<PreloadModel> _getPrelodData = BehaviorSubject<PreloadModel>();
  final BehaviorSubject<TimeSheetModel> _getTimeSheetData = BehaviorSubject<TimeSheetModel>();
  final BehaviorSubject<PromoCodeModel> _getPromoCodeData = BehaviorSubject<PromoCodeModel>();
  final BehaviorSubject<PromoApplyModel> _getPromoCodeApplyData = BehaviorSubject<PromoApplyModel>();
  final BehaviorSubject<BookingActiveModel> _getBookingActiveData = BehaviorSubject<BookingActiveModel>();
  final BehaviorSubject<BannerListModel> _getBannerListData = BehaviorSubject<BannerListModel>();
  final BehaviorSubject<BrandListModel> _getBrandListData = BehaviorSubject<BrandListModel>();
  final BehaviorSubject<AddressListModel> _getAddressListData = BehaviorSubject<AddressListModel>();
  final BehaviorSubject<BookingHistoryModel> _getBookingHistoryData = BehaviorSubject<BookingHistoryModel>();

  Stream<BookingHistoryModel> get allBookingHistoryData => _getBookingHistoryData.stream;
  Stream<AddressListModel> get allAddressListData => _getAddressListData.stream;
  Stream<BrandListModel> get allBrandListData => _getBrandListData.stream;
  Stream<BannerListModel> get allBannerListData => _getBannerListData.stream;
  Stream<BookingActiveModel> get allBookingActiveData => _getBookingActiveData.stream;
  Stream<PromoApplyModel> get allPromoApplyData => _getPromoCodeApplyData.stream;
  Stream<PreloadModel> get allPreloadData => _getPrelodData.stream;
  Stream<OtpModel> get allOtpData => _getOtpData.stream;
  Stream<NearByPlacesModel> get allNearByPlaces => _getNearByPlaces.stream;
  Stream<LoginModel> get allLoginData => _getLoginData.stream;
  Stream<TimeSheetModel> get allTimeSheetData => _getTimeSheetData.stream;
  Stream<PromoCodeModel> get allPromoCodeData => _getPromoCodeData.stream;


  Future<BookingHistoryModel> fetchHistoryBookingBloc(
      ) async {
    final BookingHistoryModel bookingHistoryModel =
    await _repository.fetchHistoryBookingApi();
    _getBookingHistoryData.sink.add(bookingHistoryModel);
    return bookingHistoryModel;
  }


  Future<AddressListModel> fetchAddressListBloc(
      ) async {
    final AddressListModel addressListModel =
    await _repository.fetchAddressListApi();
    _getAddressListData.sink.add(addressListModel);
    return addressListModel;
  }

  Future<BrandListModel> fetchBrandListBloc(
      ) async {
    final BrandListModel brandListModel =
    await _repository.fetchBrandsListData();
    _getBrandListData.sink.add(brandListModel);
    return brandListModel;
  }

  Future<BannerListModel> fetchBannerListBloc(
      ) async {
    final BannerListModel bannerListModel =
    await _repository.fetchBrandsData();
    _getBannerListData.sink.add(bannerListModel);
    return bannerListModel;
  }

  Future<BookingActiveModel> fetchActiveBookingBloc(
      ) async {
    final BookingActiveModel bookingActiveModel =
    await _repository.fetchActiveBookingApi();
    _getBookingActiveData.sink.add(bookingActiveModel);
    return bookingActiveModel;
  }

  Future<PromoApplyModel> fetchPromoCodeApplyBloc(
      String code,String service_type) async {
    final PromoApplyModel promoCodeModel =
    await _repository.fetchPromoCodeApplyData(code, service_type);
    _getPromoCodeApplyData.sink.add(promoCodeModel);
    return promoCodeModel;
  }

  Future<PromoCodeModel> fetchPromoCodeBloc(
      ) async {
    final PromoCodeModel promoCodeModel =
    await _repository.fetchPromoCodeApi();
    _getPromoCodeData.sink.add(promoCodeModel);
    return promoCodeModel;
  }

  Future<TimeSheetModel> fetchTimeSheetBloc(
      int? id,String date) async {
    final TimeSheetModel timeSheetModel =
    await _repository.fetchTimeSheetData(id, date);
    _getTimeSheetData.sink.add(timeSheetModel);
    return timeSheetModel;
  }

  Future<PreloadModel> fetchPreloadApiBloc(
      ) async {
    final PreloadModel preloadModel =
    await _repository.fetchPreloadApi();
    _getPrelodData.sink.add(preloadModel);
    return preloadModel;
  }

  Future<NearByPlacesModel> fetchNearByPlacesBloc(
      double lat,double lang) async {
    final NearByPlacesModel nearByPlacesModel =
    await _repository.fetchNearByPlaces(lat,lang);
    _getNearByPlaces.sink.add(nearByPlacesModel);
    return nearByPlacesModel;
  }

  Future<RegistrationOtpModel> fetchRegistrationOtpBloc(
      String email,String mobile,String name) async {
    final RegistrationOtpModel registrationOtpModel =
    await _repository.fetchRegistrationOtpData(email,mobile,name);
    _getRegisOtp.sink.add(registrationOtpModel);
    return registrationOtpModel;
  }

  Future<OtpModel> fetchOtpBloc(
      String email,String mobile) async {
    final OtpModel otpModel =
    await _repository.fetchOtpData(email,mobile);
    _getOtpData.sink.add(otpModel);
    return otpModel;
  }

  Future<LoginModel> fetchLoginBloc(
      String email,String mobile,String otp) async {
    final LoginModel loginModel =
    await _repository.authenticate(email,mobile,otp);
    _getLoginData.sink.add(loginModel);
    return loginModel;
  }

  Future<void> fetchActiveBookingBlocDispose() async {
    await _getBookingActiveData.drain<BookingActiveModel>();
    _getBookingActiveData.close();
  }

  Future<void> fetchPromoApplyDispose() async {
    await _getPromoCodeApplyData.drain<PromoApplyModel>();
    _getPromoCodeApplyData.close();
  }

  Future<void> fetchTimeSheetDispose() async {
    await _getTimeSheetData.drain<TimeSheetModel>();
    _getTimeSheetData.close();
  }

  Future<void> fetchPromoCodeDispose() async {
    await _getPromoCodeData.drain<PromoCodeModel>();
    _getPromoCodeData.close();
  }

  Future<void> fetchPreloadDispose() async {
    await _getPrelodData.drain<PreloadModel>();
    _getPrelodData.close();
  }

  Future<void> fetchNearByPlacesBlocDispose() async {
    await _getNearByPlaces.drain<NearByPlacesModel>();
    _getNearByPlaces.close();
  }

  Future<void> fetchLoginBlocDispose() async {
    await _getOtpData.drain<LoginModel>();
    _getLoginData.close();
  }

  Future<void> fetchOtpBlocDispose() async {
    await _getOtpData.drain<OtpModel>();
    _getOtpData.close();
  }

  Future<void> allBlocDispose() async {
    await _getOtpData.drain<OtpModel>();
    await _getLoginData.drain<LoginModel>();
    _getOtpData.close();
    _getLoginData.close();
  }

}
