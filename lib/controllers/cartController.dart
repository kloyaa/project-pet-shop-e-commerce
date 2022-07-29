import 'package:app/common/print.dart';
import 'package:app/const/url.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxList items = [].obs;
  RxInt total = 0.obs;

  void add(data) {
    final _item = items.where((el) => el["_id"] == data["_id"]);
    if (_item.isEmpty) {
      items.add(data);
      items.refresh();
      calculateTotal();

      return;
    }
    items[items.indexWhere((el) => el["_id"] == data["_id"])]["qty"] += 1;
    items.refresh();
    calculateTotal();
  }

  void remove(id) {
    items.removeWhere((el) => el["_id"] == id);
    items.refresh();
    calculateTotal();
  }

  void updateQuantity(id, type) {
    if (type == "add") {
      items[items.indexWhere((el) => el["_id"] == id)]["qty"] += 1;
      items.refresh();
    }
    if (type == "minus") {
      items[items.indexWhere((el) => el["_id"] == id)]["qty"] -= 1;
      items.refresh();
    }
    calculateTotal();
  }

  void clear() {
    total.value = 0;
    items.clear();
    items.refresh();
  }

  void calculateTotal() {
    total.value = 0; //reset
    for (var item in items) {
      final _qty = item["qty"];
      final _price = int.parse(item["price"]);
      final _sum = _qty * _price;
      total += _sum;
    }
  }

  Future<void> chekoutCart(data) async {
    await Dio().post(baseUrl + "/order", data: data);
    clear();
  }
}
