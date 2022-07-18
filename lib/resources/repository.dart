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
import 'package:kegi_sudo/models/registration_model.dart';
import 'package:kegi_sudo/models/timesheet_model.dart';
import 'package:kegi_sudo/resources/api_provider_booking.dart';
import 'package:kegi_sudo/resources/api_provider_brands.dart';
import 'package:kegi_sudo/resources/api_provider_login.dart';
import 'package:kegi_sudo/resources/api_provider_map.dart';
import 'package:kegi_sudo/resources/api_provider_myprofile.dart';
import 'package:kegi_sudo/resources/api_provider_preload.dart';

class Repository {
  final UserApiProvider userApiProvider = UserApiProvider();
  final ApiProviderMapView apiProviderMapView = ApiProviderMapView();
  final PreloadApiProvider preloadApiProvider = PreloadApiProvider();
  final ApiProviderActiveBooking apiProviderActiveBooking = ApiProviderActiveBooking();
  final ApiProviderBrands apiProviderBrands = ApiProviderBrands();
  final MyProfileApiProvider myProfileApiProvider = MyProfileApiProvider();

  Future<BannerListModel> fetchBrandsData() => apiProviderBrands.fetchBrandBannerApi();
  Future<BrandListModel> fetchBrandsListData() => apiProviderBrands.fetchBrandListApi();

  Future<AddressListModel> fetchAddressListApi() =>
      myProfileApiProvider.fetchAddressListApi();

  Future<BookingActiveModel> fetchActiveBookingApi() =>
      apiProviderActiveBooking.fetchActiveBookingApi();

  Future<BookingHistoryModel> fetchHistoryBookingApi() =>
      apiProviderActiveBooking.fetchHistoryBookingApi();

  Future<PromoApplyModel> fetchPromoCodeApplyData(String code,String service_type) => preloadApiProvider.fetchPromoCodeApplyApi(code,service_type);

  Future<RegistrationOtpModel> fetchRegistrationOtpData(String email,String mobile,String name) => userApiProvider.registrationOtpApiProvider(email: email,mobile: mobile);

  Future<TimeSheetModel> fetchTimeSheetData(int? id,String? date) => preloadApiProvider.fetchTimeSheetApi(id,date);

  Future<PromoCodeModel> fetchPromoCodeApi() =>
      preloadApiProvider.fetchPromoCodeApi();

  Future<PreloadModel> fetchPreloadApi() =>
      preloadApiProvider.fetchPreloadApi();

  Future<RegistrationModel> register(String name, String email, String mobile,String otp
     ) =>
      userApiProvider.register(
          name: name,
          email: email,
          mobile: mobile,
        otp:otp,
          );

  Future<OtpModel> fetchOtpData(String email,String mobile) => userApiProvider.otpApiProvider(email: email,mobile: mobile);

  Future<void> deleteToken() => userApiProvider.deleteToken();

  Future<NearByPlacesModel> fetchNearByPlaces(double? lat,double? lang) =>
      apiProviderMapView.fetchMapViewData(lat,lang);

  Future<void> persistToken(String token) =>
      userApiProvider.persistToken(token: token);

  Future<LoginModel> authenticate(String email, String mobile,String otp) =>
      userApiProvider.authenticate(email: email, mobile: mobile,otp: otp);

  Future<bool> hasToken() => userApiProvider.hasToken();
}
