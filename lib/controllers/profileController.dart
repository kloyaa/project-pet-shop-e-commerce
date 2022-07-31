import 'package:app/common/print.dart';
import 'package:app/const/uri.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileController extends GetxController {
  Map createProfileData = {};
  Map data = {};

  Future<void> getProfile(String id) async {
    try {
      final _response = await Dio().get(
        baseUrl + "/profile/customer/$id",
      );
      data = _response.data;

      prettyPrint("PROFILE", _response.data);

      Get.toNamed("/customer-main");
    } on DioError catch (e) {
      Get.toNamed("/register-account-profile");
      if (kDebugMode) {
        prettyPrint("getProfile()", e.response!.data);
      }
    }
  }

  Future<dynamic> getMerchantProfile(String id) async {
    try {
      final _getProfileResponse = await Dio().get(baseUrl + "/profile/$id");
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
      Get.toNamed("/loading");
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
      if (userType == "merchant") {}
      if (userType == "rider") {}
    } on DioError catch (e) {
      if (kDebugMode) {
        prettyPrint("createProfile()", e.response!.data);
      }
    }
  }
}
