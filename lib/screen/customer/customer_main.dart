import 'package:app/common/print.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/cartController.dart';
import 'package:app/controllers/listingController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/helpers/generate_minmax.dart';
import 'package:app/widget/form.dart';
import 'package:app/widget/snapshot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerMain extends StatefulWidget {
  const CustomerMain({Key? key}) : super(key: key);

  @override
  State<CustomerMain> createState() => _CustomerMainState();
}

class _CustomerMainState extends State<CustomerMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _listing = Get.put(ListingController());
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());
  final _cart = Get.put(CartController());

  late TextEditingController _searchKeywordController;
  late final _searchKeywordFocus;

  late Future _getListings;

  Future<void> onRefreshListings() async {
    setState(() {
      _getListings = _listing.getAllListings();
    });
  }

  Future<void> onKeywordChange() async {
    final _keyword = _searchKeywordController.text.trim();
    if (_keyword.isEmpty) return onRefreshListings();
    setState(() {
      _getListings = _listing.searchListings(_keyword);
    });
  }

  Future<void> onSelectListing(data) async {
    _listing.selectedListing = data;
    Get.toNamed("/customer-view-product");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListings = _listing.getAllListings();
    _searchKeywordController = TextEditingController();
    _searchKeywordFocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchKeywordController.dispose();
    _searchKeywordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text(
        "Welcome Back, ${_profile.data["name"]["first"]}!",
        style: GoogleFonts.chivo(
          fontSize: 16.0,
          color: kDark,
        ),
      ),
      leading: const SizedBox(),
      leadingWidth: 0.0,
      actions: [
        _cart.items.isNotEmpty
            ? IconButton(
                onPressed: () => Get.toNamed("/customer-shopping-cart"),
                splashRadius: 20.0,
                icon: const Icon(
                  Ionicons.cart_outline,
                  color: kDark,
                ),
              )
            : const SizedBox(),
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
        ),
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
                _profile.data["name"]["first"] +
                    " " +
                    _profile.data["name"]["last"],
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

          // const Divider(),
          ListTile(
            onTap: () => Get.toNamed("/customer-orders"),
            leading: const Icon(
              Ionicons.receipt_outline,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "My Orders",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          _cart.items.isNotEmpty
              ? ListTile(
                  onTap: () => Get.toNamed("/customer-shopping-cart"),
                  leading: const Icon(
                    Ionicons.cart_outline,
                    color: kDark,
                  ),
                  title: Text(
                    "Cart",
                    style: GoogleFonts.roboto(
                      fontSize: 12.0,
                      color: kDark,
                    ),
                  ),
                )
              : const SizedBox(),
          const Spacer(flex: 5),
          ListTile(
            onTap: () => Get.toNamed("/register-as-merchant"),
            leading: const Icon(
              MaterialCommunityIcons.store_outline,
              size: 24.0,
              color: kDark,
            ),
            title: Text(
              "I want to sell",
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
              Container(
                margin: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: inputSearchTextField(
                  controller: _searchKeywordController,
                  focusNode: _searchKeywordFocus,
                  labelText: "Search Product",
                  textFieldStyle: GoogleFonts.roboto(
                    color: kDark.withOpacity(0.5),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                  hintStyleStyle: GoogleFonts.roboto(
                    color: kDark.withOpacity(0.5),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                  onSubmited: () => onKeywordChange(),
                  color: kWhite,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _getListings,
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
                          "No listings available",
                        );
                      }
                    }
                    return RefreshIndicator(
                      onRefresh: onRefreshListings,
                      child: GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.69,
                        ),
                        itemBuilder: (context, index) {
                          final _rnd = randomNumber(1, 5);
                          final _title = snapshot.data[index]["title"];
                          final _img =
                              snapshot.data[index]["images"][_rnd]["url"];
                          final _price = snapshot.data[index]["price"];

                          return GestureDetector(
                            onTap: () => onSelectListing(snapshot.data[index]),
                            child: Container(
                              color: kWhite,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 200.0,
                                    child: CachedNetworkImage(
                                      imageUrl: _img,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _title,
                                          style: GoogleFonts.roboto(
                                            color: kDark,
                                            fontSize: 13.0,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "P$_price.00",
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: kDanger,
                                          ),
                                        ),
                                      ],
                                    ),
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
