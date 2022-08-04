import 'package:app/common/print.dart';
import 'package:app/const/uri.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Future<dynamic> getCustomerOrders(query) async {
    final _orderResponse = await Dio().get(
      baseUrl + "/checkout/get-by-customers",
      queryParameters: query,
    );
    return _orderResponse.data;
  }

  Future<dynamic> getMerchantOrders(query) async {
    final _orderResponse = await Dio().get(
      baseUrl + "/checkout/get-by-merchants",
      queryParameters: query,
    );
    return _orderResponse.data;
  }

  Future<void> updateOrderStatus({prevStatus, refNumber}) async {
    try {
      String? status;
      if (prevStatus == "to-pack") {
        status = "to-deliver";
      }

      if (prevStatus == "to-deliver") {
        status = "delivered";
      }

      await Dio().put(
        baseUrl + "/checkout",
        data: {
          "refNumber": refNumber,
          "status": status,
        },
      );
    } on DioError catch (e) {
      if (kDebugMode) {
        prettyPrint("updateOrderStatus()", e.response!.data);
      }
    }
  }
}
