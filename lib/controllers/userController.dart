import 'package:app/common/print.dart';
import 'package:app/const/uri.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';

class UserController extends GetxController {
  Map userLoginData = {};
  Map userAvatarData = {};

  Future<void> login({email, password}) async {
    try {
      Get.toNamed("/loading");

      final _profile = Get.put(ProfileController());
      final _loginResponse = await Dio().post(
        baseUrl + "/user/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      // ASSIGN VALUE TO GLOBAL STATE
      userLoginData = {
        "accountId": _loginResponse.data["accountId"],
        "email": _loginResponse.data["email"],
      };

      // GET PROFILE
      await _profile.getProfile(userLoginData["accountId"]);
    } on DioError catch (e) {
      print(e.response!.statusMessage);
      Get.back();
      if (e.response!.statusCode == 400) {
        throw Error();
      }
    }
  }

  Future<void> register({email, password}) async {
    try {
      Get.toNamed("/loading");

      final _registerResponse = await Dio().post(
        baseUrl + "/user/register",
        data: {
          "email": email,
          "password": password,
        },
      );

      // ASSIGN VALUE TO GLOBAL STATE
      userLoginData = {
        "accountId": _registerResponse.data["accountId"],
        "email": _registerResponse.data["email"],
      };

      // REDIRECT TO NEXT STEP
      Get.toNamed("/register-account-profile");
    } on DioError catch (e) {
      Get.back();
      if (e.response!.statusCode == 400) {
        throw Error();
      }
    }
  }

  void logout() {
    final _global = Get.put(GlobalController());
    final _profile = Get.put(ProfileController());

    Get.toNamed("/loading");

    Future.delayed(const Duration(seconds: 1), () {
      _global.registrationProperties.clear();
      _profile.data.clear();
      userLoginData.clear();

      return Get.toNamed("/login");
    });
  }

  Future<void> createProfile() async {
    try {
      Get.toNamed("/loading");
      final _global = Get.put(GlobalController());
      final _accountId = userLoginData["accountId"];
      final _payload = http.FormData.fromMap({
        "accountId": _accountId,
        'img': await http.MultipartFile.fromFile(
          _global.registrationProperties["img"]["path"],
          filename: _global.registrationProperties["img"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      });

      // REMOVE IMG DATA
      _global.registrationProperties.remove("img");

      // ASSIGN VALUE OF ACCOUNT ID
      // CEATE PROFILE
      _global.registrationProperties["accountId"] = _accountId;

      // await Dio().post(
      //   baseUrl + "/profile",
      //   data: {
      //     ..._global.registrationProperties,
      //     "visibility": true,
      //     "verified": false,
      //   },
      // );

      // await Dio().put(
      //   baseUrl + "/profile/customer/avatar",
      //   data: _payload,
      // );
      prettyPrint(
        "onCreateProfile() : Customer",
        _global.registrationProperties,
      );

      // lOGIN AUTOMATICALLY AFTER REGISTRATION
      // await login(
      //   email: _global.registrationProperties["loginData"]["email"],
      //   password: _global.registrationProperties["loginData"]["password"],
      // );
      // // UPDATE PROFILE

      // // UPDATE PROFILE ADDRESS
      // await Dio().put(baseUrl + "/address/profile/$accountId", data: {
      //   "name": userRegistrationProfileData["address"],
      //   "lat": "0",
      //   "long": "0"
      // });

      // // UPDATE PROFILE CONTACT
      // await Dio().put(baseUrl + "/contact/profile/$accountId", data: {
      //   "number": userRegistrationProfileData["contact"],
      //   "email": userLoginData["email"],
      // });

    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("createProfile()", e.response!.data);
      }
    }
  }
}
