import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/cartController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/widget/bottomsheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CustomerShoppingCart extends StatefulWidget {
  const CustomerShoppingCart({Key? key}) : super(key: key);

  @override
  State<CustomerShoppingCart> createState() => _CustomerShoppingCartState();
}

class _CustomerShoppingCartState extends State<CustomerShoppingCart> {
  final _cart = Get.put(CartController());
  final _profile = Get.put(ProfileController());

  late Future _getMerchant;
  bool isCheckingOut = false;

  Future<void> onDeleteFromCart(id) async {
    _cart.remove(id);
    Future.delayed(const Duration(milliseconds: 200), () {
      bottomSheet(
        message: "Item removed from the cart.",
        type: BottomSheetType.toast,
      );
    });
  }

  Future<void> onCheckout() async {
    setState(() {
      isCheckingOut = true;
    });
    final _cartMerchantId = _cart.items[0]["accountId"];
    final _merchantProfile = await _profile.getMerchantProfile(_cartMerchantId);
    Map data = {
      "header": {
        "customer": {
          "accountId": _profile.data["accountId"],
          "firstName": _profile.data["name"]["first"],
          "lastName": _profile.data["name"]["last"],
          "contactNo": _profile.data["contact"]["number"],
          "address": _profile.data["address"]["name"],
          "img": _profile.data["img"],
        },
        "merchant": {
          "accountId": _cartMerchantId,
          "name": _merchantProfile["merchantName"],
          "contactNo": _merchantProfile["contact"]["number"],
          "address": _merchantProfile["address"]["name"],
          "img": _merchantProfile["img"]
        }
      },
      "content": {
        "items": [..._cart.items],
        "total": _cart.total.value,
      },
      "status": "to-pack",
    };
    bottomSheet(
      message: "Order placed successfully!",
      type: BottomSheetType.toast,
    );
    await _cart.chekoutCart(data);
    Get.toNamed("/customer-orders");
    setState(() {
      isCheckingOut = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (_cart.items.isNotEmpty) {
      _getMerchant = _profile.getMerchantProfile(
        _cart.items[0]["accountId"],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text(
        "My Cart",
        style: GoogleFonts.chivo(
          fontSize: 16.0,
          color: kDark,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        splashRadius: 20.0,
        icon: const Icon(
          AntDesign.arrowleft,
          color: kDark,
        ),
      ),
      backgroundColor: kWhite,
      // elevation: 0,
      bottom: PreferredSize(
        child: Container(
          decoration: BoxDecoration(
            color: kWhite,
            border: Border(
              top: BorderSide(
                color: kDark.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          height: 100.0,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    MaterialCommunityIcons.truck_delivery,
                    color: kDark,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 320,
                    child: Text(
                      _profile.data["address"]["name"],
                      style: GoogleFonts.roboto(
                        color: kDark,
                        fontSize: 12.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              FutureBuilder(
                future: _getMerchant,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade50,
                      highlightColor: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 15.0,
                                width: 15.0,
                                color: kWhite,
                              ),
                              const SizedBox(width: 15.0),
                              Container(
                                height: 15.0,
                                width: 200.0,
                                color: kWhite,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2.0),
                          Container(
                            height: 15.0,
                            margin: const EdgeInsets.only(left: 30.0),
                            width: double.infinity,
                            color: kWhite,
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade50,
                      highlightColor: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 15.0,
                                width: 15.0,
                                color: kWhite,
                              ),
                              const SizedBox(width: 15.0),
                              Container(
                                height: 15.0,
                                width: 200.0,
                                color: kWhite,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2.0),
                          Container(
                            height: 15.0,
                            margin: const EdgeInsets.only(left: 30.0),
                            width: double.infinity,
                            color: kWhite,
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.data == null) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade50,
                      highlightColor: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 15.0,
                                width: 15.0,
                                color: kWhite,
                              ),
                              const SizedBox(width: 15.0),
                              Container(
                                height: 15.0,
                                width: 200.0,
                                color: kWhite,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2.0),
                          Container(
                            height: 15.0,
                            margin: const EdgeInsets.only(left: 30.0),
                            width: double.infinity,
                            color: kWhite,
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.length == 0) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade50,
                        highlightColor: Colors.grey.shade100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 15.0,
                                  width: 15.0,
                                  color: kWhite,
                                ),
                                const SizedBox(width: 15.0),
                                Container(
                                  height: 15.0,
                                  width: 200.0,
                                  color: kWhite,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2.0),
                            Container(
                              height: 15.0,
                              margin: const EdgeInsets.only(left: 30.0),
                              width: double.infinity,
                              color: kWhite,
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        MaterialCommunityIcons.store,
                        color: kDark,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data["merchantName"],
                              style: GoogleFonts.roboto(
                                color: kDark,
                                fontSize: 15.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              snapshot.data["address"]["name"],
                              style: GoogleFonts.roboto(
                                color: kDark.withOpacity(0.5),
                                fontSize: 10.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
        preferredSize: const Size.fromHeight(95.0),
      ),
    );
    return Obx(() => Scaffold(
          appBar: _appBar,
          backgroundColor: kLight,
          body: Container(
            padding: kDefaultBodyMargin.copyWith(top: 20.0),
            child: _cart.items.isEmpty
                ? Center(
                    child: Text(
                      "Cart is Empty",
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        color: kDark,
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      itemCount: _cart.items.length,
                      itemBuilder: (context, index) {
                        final _qty = _cart.items[index]["qty"];
                        final _price = _cart.items[index]["price"];
                        final _title = _cart.items[index]["title"];
                        return Container(
                          padding: kDefaultBodyMargin.copyWith(top: 20.0),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (v) => onDeleteFromCart(
                                    _cart.items[index]["_id"],
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: kWhite,
                                  icon: AntDesign.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 80.0,
                                  width: 80.0,
                                  child: ClipRRect(
                                    borderRadius: kDefaultRadius,
                                    child: CachedNetworkImage(
                                      imageUrl: _cart.items[index]["images"][0]
                                          ["url"],
                                      placeholder: (context, url) => Container(
                                        color: kLight,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _title,
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "P${int.parse(_price) * _qty}.00",
                                              style: GoogleFonts.robotoMono(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: kDanger,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      if (_qty != 1) {
                                                        _cart.updateQuantity(
                                                          _cart.items[index]
                                                              ["_id"],
                                                          "minus",
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      AntDesign.minussquareo,
                                                      color: kDark
                                                          .withOpacity(0.5),
                                                    )),
                                                Text(
                                                  _qty.toString(),
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: kDark,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () =>
                                                        _cart.updateQuantity(
                                                          _cart.items[index]
                                                              ["_id"],
                                                          "add",
                                                        ),
                                                    icon: Icon(
                                                      AntDesign.plussquareo,
                                                      color: kDark
                                                          .withOpacity(0.5),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      reverse: true,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                    ),
                  ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: isCheckingOut ? 0.3 : 1,
              child: IgnorePointer(
                ignoring: isCheckingOut ? true : false,
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  height: 80.0,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: kDark.withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SUBTOTAL: P${_cart.total.value}.00",
                            style: GoogleFonts.robotoMono(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: kDark,
                              height: 0.8,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Shipping Fee: Free",
                            style: GoogleFonts.roboto(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: kDark,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: TextButton(
                          onPressed: () => onCheckout(),
                          style: TextButton.styleFrom(
                            //primary: kFadeWhite,
                            backgroundColor: kPrimary,
                            shape: const RoundedRectangleBorder(
                              borderRadius: kDefaultRadius,
                            ),
                          ),
                          child: Text(
                            "CHECKOUT",
                            style: GoogleFonts.roboto(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
