import 'package:app/const/theme.dart';
import 'package:app/const/strings.dart';
import 'package:app/screen/account/login/login.dart';
import 'package:app/screen/account/registration/account.dart';
import 'package:app/screen/account/registration/accountPicture.dart';
import 'package:app/screen/account/registration/accountProfile.dart';
import 'package:app/screen/account/registration/accountType.dart';
import 'package:app/screen/account/registration/merchant/merchantBanner.dart';
import 'package:app/screen/account/registration/merchant/merchantProfile.dart';
import 'package:app/screen/customer/customer_main.dart';
import 'package:app/screen/customer/sub/customer_orders.dart';
import 'package:app/screen/customer/sub/customer_shopping_cart.dart';
import 'package:app/screen/customer/sub/customer_view_product.dart';
import 'package:app/screen/loading.dart';
import 'package:app/screen/merchant/merchant_main.dart';
import 'package:app/screen/merchant/sub/merchant_addItem.dart';
import 'package:app/screen/merchant/sub/merchant_orders.dart';
import 'package:app/screen/merchant/sub/merchant_postedItems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Strings.appTitle,
      theme: themeData,
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/loading", page: () => const Loading()),
        GetPage(name: "/login", page: () => const Login()),
        ...registration,
        ...merchant,
        ...customer,
      ],
    );
  }
}

final List<GetPage<dynamic>> customer = [
  GetPage(
    name: "/customer-main",
    page: () => const CustomerMain(),
  ),
  GetPage(
    name: "/customer-view-product",
    page: () => const CustomerViewProduct(),
  ),
  GetPage(
    name: "/customer-shopping-cart",
    page: () => const CustomerShoppingCart(),
  ),
  GetPage(
    name: "/customer-orders",
    page: () => const CustomerOrders(),
  ),
];
final List<GetPage<dynamic>> merchant = [
  GetPage(
    name: "/merchant-main",
    page: () => const MerchantMain(),
  ),
  GetPage(
    name: "/merchant-additem",
    page: () => const MwerchantAddItem(),
  ),
  GetPage(
    name: "/merchant-posteditems",
    page: () => const MerchantPostedItems(),
  ),
  GetPage(
    name: "/merchant-orders",
    page: () => const MerchantOrders(),
  ),
];
final List<GetPage<dynamic>> registration = [
  GetPage(
    name: "/register",
    page: () => const RegisterAccount(),
  ),
  GetPage(
    name: "/register-account-type",
    page: () => const RegisterAccountType(),
  ),
  GetPage(
    name: "/register-account-profile",
    page: () => const RegisterAccountProfile(),
  ),
  GetPage(
    name: "/register-account-picture",
    page: () => const RegisterAccountPicture(),
  ),
  GetPage(
    name: "/register-as-merchant",
    page: () => const RegisterAsMerchant(),
  ),
  GetPage(
    name: "/register-as-merchant-banner",
    page: () => const RegisterAsMerchantBanner(),
  ),
];
