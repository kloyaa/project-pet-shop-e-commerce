import 'dart:io';
import 'package:app/common/destroyTextFieldFocus.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/listingController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/upload_images.dart';
import 'package:app/widget/bottomsheet.dart';
import 'package:app/widget/dialog.dart';
import 'package:app/widget/form.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MwerchantAddItem extends StatefulWidget {
  const MwerchantAddItem({Key? key}) : super(key: key);

  @override
  State<MwerchantAddItem> createState() => _MwerchantAddItemState();
}

class _MwerchantAddItemState extends State<MwerchantAddItem> {
  final GlobalKey<ExpansionTileCardState> _tileKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  final _listing = Get.put(ListingController());
  final _profile = Get.put(ProfileController());

  final _titleController = TextEditingController();
  final _stocksQtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _detailsController = TextEditingController();

  final List<Map> _images = [];

  Future<void> onAddProduct() async {
    dialogLoading(context);

    final _title = _titleController.text.trim();
    final _description = _detailsController.text.trim();
    final _price = _priceController.text.trim();
    final _stocksQuantity = _stocksQtyController.text.trim();

    if (_title.isEmpty ||
        _description.isEmpty ||
        _price.isEmpty ||
        _stocksQuantity.isEmpty) {
      Get.back();
      return _tileKey.currentState!.expand();
    }

    await _listing.createProduct({
      "accountId": _profile.data["accountId"],
      "title": _title,
      "description": _description,
      "images": await uploadImages(_images),
      "price": _price,
      "stocksQuantity": _stocksQuantity,
      "availability": true
    });
    destroyTextFieldFocus(context);
    Get.back();
    Future.delayed(const Duration(milliseconds: 500), () {
      bottomSheet(
        message: "Product added successfully!",
        type: BottomSheetType.toast,
      );
    });
  }

  Future<void> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _images.add({
          "name": image.name,
          "path": image.path,
        });
      });
    }
  }

  void removeSelectedImage(path) {
    setState(() {
      _images.removeWhere((element) => element["path"] == path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text(
        "Add Product",
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
      actions: [
        _images.length == 5
            ? Container(
                height: 10,
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () => onAddProduct(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      primary: kSecondary,
                      elevation: 0,
                    ),
                    child: Text(
                      "POST",
                      style: GoogleFonts.roboto(
                        fontSize: 10.0,
                        color: kLight,
                      ),
                    )),
              )
            : const SizedBox()
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
    final _containerAddItem = GestureDetector(
      onTap: () async => await selectImage(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: const BoxDecoration(
          color: kLight,
          borderRadius: kDefaultRadius,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              MaterialIcons.add_to_photos,
              color: kDark,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _images.isNotEmpty ? "ADD MORE IMAGES" : "ADD IMAGE",
                  style: GoogleFonts.chivo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: kDark,
                  ),
                ),
                Text(
                  "Pick images that is relevant to the post",
                  style: GoogleFonts.chivo(
                    fontSize: 12.0,
                    color: kDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: () => destroyTextFieldFocus(context),
      child: Scaffold(
        appBar: _appBar,
        backgroundColor: kWhite,
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: kDefaultBodyMargin,
          child: Column(
            children: [
              const SizedBox(height: 5),
              ExpansionTileCard(
                key: _tileKey,
                elevation: 0,
                duration: const Duration(milliseconds: 400),
                turnsCurve: Curves.bounceInOut,
                colorCurve: Curves.bounceInOut,
                contentPadding: const EdgeInsets.all(20.0),
                leading: const Icon(AntDesign.plus, color: kDark),
                title: Text(
                  "More Details",
                  style: GoogleFonts.chivo(
                    fontSize: 14.0,
                    color: kDark.withOpacity(0.8),
                  ),
                ),
                subtitle: Text(
                  "Give customers an idea about your product",
                  style: GoogleFonts.roboto(
                    fontSize: 10.0,
                    color: kDark.withOpacity(0.8),
                  ),
                ),
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: inputTextField(
                          controller: _titleController,
                          labelText: "Product Name",
                          textFieldStyle: GoogleFonts.chivo(
                            fontSize: 12.0,
                            color: kDark,
                          ),
                          hintStyleStyle: GoogleFonts.chivo(
                            fontSize: 12.0,
                            color: kDark,
                          ),
                          hasError: false,
                          color: kLight,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: inputNumberTextField(
                          controller: _stocksQtyController,
                          labelText: "Stocks Available",
                          textFieldStyle: GoogleFonts.chivo(
                            fontSize: 12.0,
                            color: kDark,
                          ),
                          hintStyleStyle: GoogleFonts.chivo(
                            fontSize: 12.0,
                            color: kDark,
                          ),
                          hasError: false,
                          color: kLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  inputNumberTextField(
                    controller: _priceController,
                    labelText: "Price in PHP",
                    textFieldStyle: GoogleFonts.chivo(
                      fontSize: 12.0,
                      color: kDark,
                    ),
                    hintStyleStyle: GoogleFonts.chivo(
                      fontSize: 12.0,
                      color: kDark,
                    ),
                    hasError: false,
                    color: kLight,
                  ),
                  const SizedBox(height: 5),
                  inputTextArea(
                    controller: _detailsController,
                    labelText: "Product Guide",
                    textFieldStyle: GoogleFonts.chivo(
                      fontSize: 12.0,
                      color: kDark,
                    ),
                    hintStyleStyle: GoogleFonts.chivo(
                      fontSize: 12.0,
                      color: kDark,
                    ),
                    hasError: false,
                    color: kLight,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Scrollbar(
                  thickness: 5,
                  isAlwaysShown: true,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: _images.length,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: kDefaultRadius,
                            child: Image.file(
                              File(_images[index]["path"]),
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 15,
                            top: 5,
                            child: IconButton(
                              onPressed: () => removeSelectedImage(
                                _images[index]["path"],
                              ),
                              icon: const Icon(
                                MaterialCommunityIcons.delete_circle,
                                color: Colors.redAccent,
                                size: 34.0,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: _images.length == 5 ? true : false,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _images.length == 5 ? 0.3 : 1,
                  child: _containerAddItem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
