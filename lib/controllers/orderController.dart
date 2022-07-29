import 'package:app/common/print.dart';
import 'package:app/const/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Future<dynamic> getCustomerOrders(query) async {
    final _orderResponse = await Dio().get(
      baseUrl + "/order",
      queryParameters: query,
    );
    return _orderResponse.data;
  }

  Future<void> updateOrderStatus({prevStatus, id}) async {
    try {
      String? status;
      if (prevStatus == "to-pack") {
        status = "packed";
      }
      if (prevStatus == "packed") {
        status = "to-deliver";
      }
      if (prevStatus == "to-deliver") {
        status = "delivered";
      }
      await Dio().put(baseUrl + "/order", queryParameters: {
        "_id": id,
        "status": status,
      });
    } on DioError catch (e) {
      if (kDebugMode) {
        prettyPrint("updateOrderStatus()", e.response!.data);
      }
    }
  }
}
