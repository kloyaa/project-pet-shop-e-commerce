import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/listingController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/widget/bottomsheet.dart';
import 'package:app/widget/snapshot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class MerchantPostedItems extends StatefulWidget {
  const MerchantPostedItems({Key? key}) : super(key: key);

  @override
  State<MerchantPostedItems> createState() => _MerchantPostedItemsState();
}

class _MerchantPostedItemsState extends State<MerchantPostedItems> {
  final _listing = Get.put(ListingController());
  final _profile = Get.put(ProfileController());

  late Future _getListings;

  Future<void> onRefreshListings() async {
    setState(() {
      _getListings = _listing.getListings(
        merchantId: _profile.data["accountId"],
      );
    });
  }

  Future<void> onDeleteListing(id) async {
    bottomSheet(
      message: "Deleting item, Please wait.",
      type: BottomSheetType.toast,
    );
    await _listing.deleteListing(id);
    Get.back();
    onRefreshListings();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListings = _listing.getListings(
      merchantId: _profile.data["accountId"],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text(
        "Posted Items",
        style: GoogleFonts.roboto(
          fontSize: 14.0,
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
      elevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: kDark.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: kWhite,
      appBar: _appBar,
      body: Container(
        margin: kDefaultBodyMargin,
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
              onRefresh: () => onRefreshListings(),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final _id = snapshot.data[index]["_id"];
                  final _title = snapshot.data[index]["title"];
                  final _img = snapshot.data[index]["images"][0]["url"];
                  final _createdAt = snapshot.data[index]["date"]["createdAt"];
                  final _price = snapshot.data[index]["price"];
                  final _qty = snapshot.data[index]["stocksQuantity"];

                  return Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            onPressed: (v) => onDeleteListing(_id),
                            backgroundColor: Colors.redAccent,
                            foregroundColor: kWhite,
                            icon: AntDesign.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                              top: 15.0,
                              right: 20.0,
                            ),
                            child: IconButton(
                              onPressed: () => onDeleteListing(_id),
                              tooltip: "Do you want to delete \n$_title?",
                              icon: const Icon(
                                AntDesign.delete,
                                color: kDark,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80.0,
                            width: 130.0,
                            child: ClipRRect(
                              borderRadius: kDefaultRadius,
                              child: CachedNetworkImage(
                                imageUrl: _img,
                                placeholder: (context, url) => Container(
                                  color: kLight,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 110.0,
                              child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _title,
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Jiffy(_createdAt)
                                              .startOf(Units.MINUTE)
                                              .fromNow(),
                                          style: GoogleFonts.roboto(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 5.0,
                                          ),
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            border: Border.all(
                                              color: kDark,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            "QTY x$_qty",
                                            style: GoogleFonts.roboto(
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.w300,
                                              color: kDark,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "P$_price",
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: kDanger,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
    );
  }
}
