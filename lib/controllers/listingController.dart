import 'package:app/const/uri.dart';
import 'package:app/controllers/profileController.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ListingController extends GetxController {
  Map selectedListing = {};

  Future<void> createProduct(data) async {
    await Dio().post(baseUrl + "/product", data: data);
  }

  Future<dynamic> getListings({String? merchantId}) async {
    if (merchantId!.isNotEmpty) {
      final _listingsResponse = await Dio().get(
        baseUrl + "/product",
        queryParameters: {
          "accountId": merchantId,
          "availability": true,
        },
      );
      return _listingsResponse.data;
    }
    final _profile = Get.put(ProfileController());
    final _listingsResponse = await Dio().get(
      baseUrl + "/product",
      queryParameters: {
        "accountId": _profile.data["accountId"],
        "availability": true,
      },
    );
    return _listingsResponse.data;
  }

  Future<dynamic> getAllListings() async {
    final _listingsResponse = await Dio().get(baseUrl + "/product/all");
    return _listingsResponse.data;
  }

  Future<dynamic> searchListings(keyword) async {
    final _listingsResponse = await Dio().get(
      baseUrl + "/product/all",
      queryParameters: {
        "keyword": keyword,
      },
    );
    return _listingsResponse.data;
  }

  Future<void> deleteListing(id) async {
    await Dio().delete(baseUrl + "/product/$id");
  }
}
