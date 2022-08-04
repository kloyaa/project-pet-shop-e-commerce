import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/format_currency.dart';
import 'package:app/widget/bottomsheet.dart';
import 'package:app/widget/snapshot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class MerchantOrders extends StatefulWidget {
  const MerchantOrders({Key? key}) : super(key: key);

  @override
  State<MerchantOrders> createState() => _MerchantOrdersState();
}

class _MerchantOrdersState extends State<MerchantOrders>
    with SingleTickerProviderStateMixin {
  final _order = Get.put(OrderController());
  final _profile = Get.put(ProfileController());

  TabController? _tabController;
  late Future _getOrders;

  final List<String> _buttonTtitle = [
    "Ready to Deliver",
    "To Deliver",
    "Delivered"
  ];
  final List<Map> _tabTitle = [
    {"title": "To Pack", "tag": "to-pack"},
    {"title": "To Deliver", "tag": "to-deliver"},
    {"title": "Delivered", "tag": "delivered"},
  ];

  Future<void> onMoveOrder(query) async {
    bottomSheet(
      type: BottomSheetType.toast,
      message: "Updating order status, Please wait.",
    );

    await _order.updateOrderStatus(
      refNumber: query["refNumber"],
      prevStatus: query["status"],
    );

    await onRefreshOrders({
      "accountId": _profile.data["accountId"],
      "status": query["status"],
    });
    Get.back();
  }

  Future<void> onRefreshOrders(query) async {
    setState(() {
      _getOrders = _order.getMerchantOrders(query);
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
    _tabController = TabController(length: 3, vsync: this);
    _getOrders = _order.getMerchantOrders({
      "accountId": _profile.data["accountId"],
      "status": "to-pack",
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text(
        "Customer Orders",
        style: GoogleFonts.roboto(
          fontSize: 14.0,
          color: kDark,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.toNamed("/merchant-main"),
        splashRadius: 20.0,
        icon: const Icon(
          AntDesign.arrowleft,
          color: kDark,
        ),
      ),
      backgroundColor: kWhite,
      bottom: _tabController == null
          ? null
          : TabBar(
              controller: _tabController,
              labelColor: kPrimary,
              unselectedLabelColor: Colors.black38,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
                left: 15.0,
                right: 15.0,
              ),
              labelStyle: GoogleFonts.roboto(fontSize: 11),
              indicatorWeight: 5,
              physics: const ScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              indicatorColor: kPrimary,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (index) {
                if (index == 0) {
                  onRefreshOrders({
                    "accountId": _profile.data["accountId"],
                    "status": "to-pack",
                  });
                }

                if (index == 1) {
                  onRefreshOrders({
                    "accountId": _profile.data["accountId"],
                    "status": "to-deliver",
                  });
                }
                if (index == 2) {
                  onRefreshOrders({
                    "accountId": _profile.data["accountId"],
                    "status": "delivered",
                  });
                }
              },
              tabs: _tabTitle
                  .map((e) => SizedBox(
                        width: Get.width * 0.30,
                        child: Text(
                          e["title"],
                          textAlign: TextAlign.center,
                        ),
                      ))
                  .toList(),
            ),
      // elevation: 0,
    );

    return Scaffold(
      backgroundColor: kLight,
      appBar: _appBar,
      body: FutureBuilder(
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
                "Empty",
              );
            }
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final _orderId = snapshot.data[index]["_id"];
              final _orderStatus = snapshot.data[index]["status"];

              final _customerName = snapshot.data[index]["header"]["customer"]
                      ["firstName"] +
                  " " +
                  snapshot.data[index]["header"]["customer"]["lastName"];
              final _customerAddress =
                  snapshot.data[index]["header"]["customer"]["address"];
              final _amountToPay = snapshot.data[index]["content"]["total"];

              return Container(
                margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
                padding: const EdgeInsets.all(25.0),
                color: kWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250.0,
                          child: Text(
                            _customerName,
                            style: GoogleFonts.roboto(
                              color: kDark,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 250.0,
                          child: Text(
                            _customerAddress,
                            style: GoogleFonts.roboto(
                              color: kDark.withOpacity(0.5),
                              fontSize: 10.0,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ListView.builder(
                      itemCount:
                          snapshot.data[index]["content"]["items"].length,
                      itemBuilder: (context, imgIndex) {
                        final _title = snapshot.data[index]["content"]["items"]
                            [imgIndex]["title"];
                        final _qty = snapshot.data[index]["content"]["items"]
                            [imgIndex]["qty"];
                        final _price = int.parse(snapshot.data[index]["content"]
                            ["items"][imgIndex]["price"]);

                        final _subTotal = _qty * _price;

                        return Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          height: 90.0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: kDefaultRadius,
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data[index]["content"]
                                        ["items"][imgIndex]["images"][0]["url"],
                                    placeholder: (context, url) => Container(
                                      color: kLight,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        _title,
                                        style: GoogleFonts.roboto(
                                          color: kDark,
                                          fontSize: 10.0,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "Quantity: x$_qty",
                                      style: GoogleFonts.roboto(
                                        color: kDark,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    Text(
                                      value.format(_subTotal),
                                      style: GoogleFonts.rajdhani(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
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
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    snapshot.data[index]["status"] == "to-pack"
                        ? Container(
                            margin: const EdgeInsets.only(top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: TextButton(
                                    onPressed: () => onMoveOrder({
                                      "refNumber": snapshot.data[index]
                                          ["refNumber"],
                                      "status": _orderStatus,
                                    }),
                                    style: TextButton.styleFrom(
                                      //primary: kFadeWhite,
                                      backgroundColor: kPrimary,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: kDefaultRadius,
                                      ),
                                    ),
                                    child: Text(
                                      _buttonTtitle[_tabController!.index],
                                      style: GoogleFonts.roboto(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "AMOUNT TO PAY",
                                      style: GoogleFonts.roboto(
                                        color: kDark.withOpacity(0.5),
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    Text(
                                      _amountToPay,
                                      style: GoogleFonts.rajdhani(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: kDanger,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    snapshot.data[index]["status"] == "to-deliver"
                        ? Container(
                            margin: const EdgeInsets.only(top: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AMOUNT TO PAY",
                                  style: GoogleFonts.roboto(
                                    color: kDark.withOpacity(0.5),
                                    fontSize: 10.0,
                                  ),
                                ),
                                Text(
                                  _amountToPay,
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: kDanger,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    snapshot.data[index]["status"] == "delivered"
                        ? Container(
                            margin: const EdgeInsets.only(top: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reference No.",
                                  style: GoogleFonts.roboto(
                                    color: kDark.withOpacity(0.5),
                                    fontSize: 10.0,
                                  ),
                                ),
                                Text(
                                  snapshot.data[index]["refNumber"]
                                      .toString()
                                      .substring(0, 18)
                                      .replaceAll(r'-', ""),
                                  style: GoogleFonts.robotoMono(
                                    color: kDark,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Amount Paid",
                                  style: GoogleFonts.roboto(
                                    color: kDark.withOpacity(0.5),
                                    fontSize: 10.0,
                                  ),
                                ),
                                Text(
                                  _amountToPay,
                                  style: GoogleFonts.rajdhani(
                                    color: Colors.red,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Delivered on",
                                  style: GoogleFonts.roboto(
                                    color: kDark.withOpacity(0.5),
                                    fontSize: 10.0,
                                  ),
                                ),
                                Text(
                                  Jiffy(snapshot.data[index]["date"]
                                          ["updatedAt"])
                                      .yMMMEdjm,
                                  style: GoogleFonts.roboto(
                                    color: kDark,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
