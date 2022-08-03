import 'package:app/common/print.dart';
import 'package:app/const/uri.dart';
import 'package:app/controllers/userController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileController extends GetxController {
  Map createProfileData = {};
  Map data = {};

  Future<void> getProfile(String id) async {
    await Dio()
        .get(baseUrl + "/profile/customer/$id")
        .then((value) => isCustomer(value))
        .catchError((errror) async => await Dio()
            .get(baseUrl + "/profile/merchant/$id")
            .then((value) => isMerchant(value))
            .catchError((errror) => Get.toNamed("/register-account-profile")));
  }

  Future<dynamic> getMerchantProfile(String id) async {
    try {
      final _getProfileResponse = await Dio().get(
        baseUrl + "/profile/merchant/$id",
      );
      return _getProfileResponse.data;
    } on DioError catch (e) {
      if (kDebugMode) {
        prettyPrint("getMerchantProfile()", e.response!.data);
      }
    }
  }

  Future<dynamic> getMerchants() async {
    try {
      // GET WATER REFILLIGN STATIONS NEARBY
      final getWaterRefillingStations = await Dio().get(
        baseUrl + "/profile",
        queryParameters: {
          "accountType": "merchant",
          "visibility": true,
        },
      );
      return getWaterRefillingStations.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getMerchants()", e.response!.data);
      }
    }
  }

  Future<dynamic> createProfile(userType) async {
    try {
      prettyPrint("createProfileData", createProfileData);

      Get.toNamed("/loading");

      /* 
      * CUSTOMER
      * Description: Create Customer Profile
      */
      if (userType == "customer") {
        // CREATE PROFILE
        await Dio().post(
          baseUrl + "/profile/customer",
          data: {
            ...createProfileData,
            "visibility": true,
            "verified": false,
          },
        );
        // UPDATE PROFILE AVATAR
        await Dio().put(
          baseUrl + "/profile/customer/avatar",
          data: http.FormData.fromMap({
            "accountId": createProfileData["accountId"],
            'img': await http.MultipartFile.fromFile(
              createProfileData["img"]["path"],
              filename: createProfileData["img"]["name"],
              contentType: MediaType("image", "jpeg"), //important
            ),
          }),
        );
        // GET CUSTOMER PROFILE
        await getProfile(createProfileData["accountId"]);

        return Get.toNamed("/customer-main");
      }

      /* 
      * MERCHANT
      * Description: Create Merchant Profile
      */
      if (userType == "merchant") {
        final _loginData = Get.put(UserController());

        // DELETE EXISTING PROFILE
        await Dio().delete(
          baseUrl + "/profile/g/${_loginData.userLoginData["accountId"]}",
        );
        // CREATE PROFILE
        await Dio().post(
          baseUrl + "/profile/merchant",
          data: {
            ...createProfileData,
            "visibility": true,
            "verified": false,
          },
        );
        // UPDATE PROFILE AVATAR
        await Dio().put(
          baseUrl + "/profile/merchant/avatar",
          data: http.FormData.fromMap({
            "accountId": createProfileData["accountId"],
            'img': await http.MultipartFile.fromFile(
              createProfileData["img"]["path"],
              filename: createProfileData["img"]["name"],
              contentType: MediaType("image", "jpeg"), //important
            ),
          }),
        );

        // LOGOUT
        Get.put(UserController()).logout();
      }
      if (userType == "rider") {}
    } on DioError catch (e) {
      if (kDebugMode) {
        Get.back();
        print(e);
      }
    }
  }

  dynamic isMerchant(value) {
    data = value.data;
    return Get.toNamed("/merchant-main");
  }

  dynamic isCustomer(value) {
    data = value.data;
    return Get.toNamed("/customer-main");
  }
}
