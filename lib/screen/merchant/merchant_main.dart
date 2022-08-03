import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/screen/merchant/sub/merchant_qrCode.dart';
import 'package:app/widget/snapshot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class MerchantMain extends StatefulWidget {
  const MerchantMain({Key? key}) : super(key: key);

  @override
  State<MerchantMain> createState() => _MerchantMainState();
}

class _MerchantMainState extends State<MerchantMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());
  final _order = Get.put(OrderController());

  late Future _getOrders;

  Future<void> onRefreshOrders(query) async {
    setState(() {
      _getOrders = _order.getCustomerOrders(query);
    });
  }

  int _calculateTotal(items) {
    int total = 0; //reset
    for (var item in items) {
      final _qty = item["qty"];
      final _price = int.parse(item["price"]);
      final _sum = _qty * _price;
      total += _sum as int;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _getOrders = _order.getCustomerOrders({
      "accountId": _profile.data["accountId"],
      "status": "to-pack",
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text(
        _profile.data["name"],
        style: GoogleFonts.roboto(
          fontSize: 14.0,
          color: kDark,
        ),
      ),
      leading: const SizedBox(),
      leadingWidth: 0.0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15.0),
          child: IconButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            splashRadius: 20.0,
            icon: const Icon(
              Ionicons.menu,
              color: kDark,
            ),
          ),
        )
      ],
      backgroundColor: kWhite,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: kDark.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    );
    final _drawer = Drawer(
      backgroundColor: kLight,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: kPrimary,
              image: DecorationImage(
                image: NetworkImage(_profile.data["avatar"]),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  kPrimary.withOpacity(0.7),
                  BlendMode.dstOut,
                ),
              ),
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              currentAccountPictureSize: const Size.square(70.0),
              margin: const EdgeInsets.all(0),
              accountName: Text(
                _profile.data["name"],
                style: GoogleFonts.chivo(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                _profile.data["contact"]["email"],
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/merchant-orders"),
            leading: const Icon(
              Ionicons.receipt_outline,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Customer Orders",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/merchant-additem"),
            leading: const Icon(
              AntDesign.plus,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Add Item",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/merchant-posteditems"),
            leading: Icon(
              Entypo.list,
              size: 24.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "My Posted Items",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          const Spacer(flex: 5),
          ListTile(
            onTap: () => Get.to(
              () => MerchantQRCode(code: _user.userLoginData["accountId"]),
            ),
            leading: Icon(
              MaterialCommunityIcons.qrcode_edit,
              size: 24.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Show QR Code",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => _user.logout(),
            leading: Icon(
              MaterialCommunityIcons.logout_variant,
              size: 24.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Log out",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
    final _containerAddItem = Expanded(
      child: GestureDetector(
        onTap: () => Get.toNamed("/merchant-additem"),
        child: Container(
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: kDefaultRadius,
          ),
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                AntDesign.plus,
                color: kLight,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ADD ITEM",
                    style: GoogleFonts.chivo(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: kLight,
                    ),
                  ),
                  Text(
                    "Upload Products\nto my store",
                    style: GoogleFonts.roboto(
                      fontSize: 8.0,
                      color: kLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    final _containerMyOrders = Expanded(
      child: GestureDetector(
        onTap: () => Get.toNamed("/merchant-orders"),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: kDefaultRadius,
          ),
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Ionicons.receipt_outline,
                color: kLight,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MY ORDERS",
                    style: GoogleFonts.chivo(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: kLight,
                    ),
                  ),
                  Text(
                    "Manage and View \nCustomer Orders",
                    style: GoogleFonts.roboto(
                      fontSize: 8.0,
                      color: kLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    final _containerPosteItems = GestureDetector(
      onTap: () => Get.toNamed("/merchant-posteditems"),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: kDefaultRadius,
        ),
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesome.th_list,
              color: kLight,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MY POSTED ITEMS",
                  style: GoogleFonts.chivo(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: kLight,
                  ),
                ),
                Text(
                  "View and Manage uploaded products",
                  style: GoogleFonts.chivo(
                    fontSize: 10.0,
                    color: kLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kLight,
        appBar: _appBar,
        drawer: _drawer,
        body: Container(
          margin: kDefaultBodyMargin,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Row(
                children: [
                  _containerAddItem,
                  const SizedBox(width: 5),
                  _containerMyOrders,
                ],
              ),
              const SizedBox(height: 5.0),
              _containerPosteItems,
              const SizedBox(height: 10.0),
              Expanded(
                child: FutureBuilder(
                  future: _getOrders,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return snapshotSpinner();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return snapshotSpinner();
                    }
                    if (snapshot.data == null) {
                      return snapshotSpinner();
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data.length == 0) {
                        return snapshotEmptyMessage(
                          "You have no pending\norders available.",
                        );
                      }
                    }

                    return RefreshIndicator(
                      onRefresh: () => onRefreshOrders({
                        "accountId": _profile.data["accountId"],
                        "accountType": "merchant",
                        "status": "to-pack",
                      }),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final _customerName = snapshot.data[index]["header"]
                                  ["customer"]["firstName"] +
                              " " +
                              snapshot.data[index]["header"]["customer"]
                                  ["lastName"];
                          final _dateOrdered =
                              snapshot.data[index]["date"]["createdAt"];
                          return GestureDetector(
                            onTap: () => Get.toNamed("/merchant-orders"),
                            child: Container(
                              margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
                              padding: const EdgeInsets.all(25.0),
                              decoration: const BoxDecoration(
                                color: kWhite,
                                borderRadius: kDefaultRadius,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 250.0,
                                        child: Text(
                                          _customerName,
                                          style: GoogleFonts.roboto(
                                            color: kDark,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 250.0,
                                        child: Text(
                                          Jiffy(_dateOrdered)
                                              .startOf(Units.SECOND)
                                              .fromNow(),
                                          style: GoogleFonts.roboto(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    itemCount: snapshot
                                        .data[index]["content"]["items"].length,
                                    itemBuilder: (context, imgIndex) {
                                      final _title = snapshot.data[index]
                                              ["content"]["items"][imgIndex]
                                          ["title"];
                                      final _qty = snapshot.data[index]
                                          ["content"]["items"][imgIndex]["qty"];
                                      final _price = int.parse(
                                          snapshot.data[index]["content"]
                                              ["items"][imgIndex]["price"]);

                                      final _subTotal = _qty * _price;
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        height: 100.0,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: kDefaultRadius,
                                                child: CachedNetworkImage(
                                                  imageUrl: snapshot.data[index]
                                                              ["content"]
                                                          ["items"][imgIndex]
                                                      ["images"][0]["url"],
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    color: kLight,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      _title,
                                                      style: GoogleFonts.roboto(
                                                        color: kDark,
                                                        fontSize: 14.0,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    "Quantity: x$_qty",
                                                    style: GoogleFonts.roboto(
                                                      color: kDark,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Subtotal: P$_subTotal",
                                                    style:
                                                        GoogleFonts.robotoMono(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kDanger,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
