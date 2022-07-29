import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/widget/snapshot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({Key? key}) : super(key: key);

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders>
    with SingleTickerProviderStateMixin {
  final _order = Get.put(OrderController());
  final _profile = Get.put(ProfileController());

  TabController? _tabController;
  late Future _getOrders;

  final List<Map> _tabTitle = [
    {"title": "To Pack", "tag": "to-pack"},
    {"title": "Packed", "tag": "pack"},
    {"title": "To Deliver", "tag": "to-deliver"},
    {"title": "Delivered", "tag": "delivered"},
  ];

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
    _tabController = TabController(length: 4, vsync: this);
    _getOrders = _order.getCustomerOrders({
      "accountId": _profile.data["accountId"],
      "accountType": "customer",
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
        "My Orders",
        style: GoogleFonts.chivo(
          fontSize: 16.0,
          color: kDark,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.toNamed("/customer-main"),
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
                    "accountType": "customer",
                    "status": "to-pack",
                  });
                }
                if (index == 1) {
                  onRefreshOrders({
                    "accountId": _profile.data["accountId"],
                    "accountType": "customer",
                    "status": "packed",
                  });
                }
                if (index == 2) {
                  onRefreshOrders({
                    "accountId": _profile.data["accountId"],
                    "accountType": "customer",
                    "status": "to-deliver",
                  });
                }
                if (index == 3) {
                  onRefreshOrders({
                    "accountId": _profile.data["accountId"],
                    "accountType": "customer",
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
              final _merchantName =
                  snapshot.data[index]["header"]["merchant"]["name"];
              final _merchantAddress =
                  snapshot.data[index]["header"]["merchant"]["address"];
              final _customerName = snapshot.data[index]["header"]["customer"]
                      ["firstName"] +
                  " " +
                  snapshot.data[index]["header"]["customer"]["lastName"];
              final _customerAddress =
                  snapshot.data[index]["header"]["customer"]["address"];
              return Container(
                margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
                padding: const EdgeInsets.all(25.0),
                color: kWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _merchantName,
                      style: GoogleFonts.roboto(
                        color: kDark,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      _merchantAddress,
                      style: GoogleFonts.roboto(
                        color: kDark.withOpacity(0.5),
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: kDefaultRadius,
                        border: Border.all(
                          color: kDark.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            AntDesign.idcard,
                            color: kDark,
                          ),
                          const SizedBox(width: 15),
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
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 5),
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
                        ],
                      ),
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
                          height: 100.0,
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
                                          fontSize: 14.0,
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
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Text(
                                      "Subtotal: P$_subTotal.00",
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
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
                                    color: kDark.withOpacity(0.8),
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Amount Paid",
                                  style: GoogleFonts.roboto(
                                    color: kDark.withOpacity(0.5),
                                    fontSize: 10.0,
                                  ),
                                ),
                                Text(
                                  "P${_calculateTotal(snapshot.data[index]["content"]["items"])}.00",
                                  style: GoogleFonts.robotoMono(
                                    color: kDark.withOpacity(0.8),
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Delivered",
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
                                    color: kDark.withOpacity(0.8),
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    snapshot.data[index]["status"] != "delivered"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 25),
                              const Divider(),
                              const SizedBox(height: 10),
                              Text(
                                "AMOUNT TO PAY",
                                style: GoogleFonts.roboto(
                                  color: kDark.withOpacity(0.5),
                                  fontSize: 10.0,
                                ),
                              ),
                              Text(
                                "P${_calculateTotal(snapshot.data[index]["content"]["items"])}.00",
                                style: GoogleFonts.robotoMono(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: kDanger,
                                ),
                              ),
                            ],
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
