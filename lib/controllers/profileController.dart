import 'package:app/common/print.dart';
import 'package:app/const/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Map data = {};

  Future<void> getProfile(String id) async {
    try {
      final _getProfileResponse = await Dio().get(baseUrl + "/profile/$id");
      data = _getProfileResponse.data;

      final _accountType = _getProfileResponse.data["accountType"];

      // REDIRECT
      if (_accountType == "customer") return Get.toNamed("/customer-main");
      if (_accountType == "merchant") return Get.toNamed("/merchant-main");

      prettyPrint("PROFILE", _getProfileResponse.data);
    } on DioError catch (e) {
      Get.toNamed("/register-account-type");
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
}
