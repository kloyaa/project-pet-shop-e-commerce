import 'dart:io';
import 'package:app/common/destroyTextFieldFocus.dart';
import 'package:app/common/print.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/screen/merchant/sub/merchant_qrCode.dart';
import 'package:app/widget/form.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RegisterAsMerchantBanner extends StatefulWidget {
  const RegisterAsMerchantBanner({Key? key}) : super(key: key);

  @override
  State<RegisterAsMerchantBanner> createState() =>
      _RegisterAsMerchantBannerState();
}

class _RegisterAsMerchantBannerState extends State<RegisterAsMerchantBanner> {
  final _picker = ImagePicker();
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());

  String _img1Path = "";
  String _img1Name = "";

  bool _hasRider = false;

  late TextEditingController _deliveryFeeController;
  late FocusNode _deliveryFeeFocus;

  Future<void> onSelectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
    }
  }

  Future<void> onRegister() async {
    final _deliveryFee = _deliveryFeeController.text;
    if (_img1Path.isEmpty || _img1Name.isEmpty) return onSelectImage();
    if (_deliveryFee.isEmpty) return _deliveryFeeFocus.requestFocus();

    _profile.createProfileData.addAll(
      {
        "img": {
          "name": _img1Name,
          "path": _img1Path,
        },
      },
    );

    if (_hasRider) {
      _profile.createProfileData.addAll(
        {
          "feePerKilometer": _deliveryFee,
          "riderStatus": "active",
        },
      );
    }

    await _profile.createProfile("merchant");
  }

  void removeSelectedImage() async {
    setState(() {
      _img1Path = "";
      _img1Name = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deliveryFeeController = TextEditingController();
    _deliveryFeeFocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _deliveryFeeController.dispose();
    _deliveryFeeFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _title = Text(
      "Store Banner",
      style: GoogleFonts.chivo(
        fontWeight: FontWeight.bold,
        color: kLight,
        fontSize: 15,
      ),
    );
    final _subTitle = Text(
      "Upload your store landscape photo",
      style: GoogleFonts.roboto(
        fontSize: 12.0,
        fontWeight: FontWeight.w300,
        color: kLight,
      ),
    );
    final _info = Container(
      margin: const EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Text(
        "Note: You cannot undo this action once your profile is created as 'STORE'",
        style: GoogleFonts.roboto(
          fontSize: 10.0,
          fontWeight: FontWeight.w300,
          color: kLight.withOpacity(0.7),
        ),
        textAlign: TextAlign.center,
      ),
    );
    final _appBar = AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_title, _subTitle],
      ),
      backgroundColor: kPrimary,
      elevation: 0,
      leading: const SizedBox(),
      leadingWidth: 0.0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15.0),
          child: IconButton(
            onPressed: () => Get.back(),
            splashRadius: 20.0,
            icon: const Icon(
              AntDesign.close,
              color: kLight,
            ),
          ),
        )
      ],
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kPrimary,
          appBar: _appBar,
          body: Container(
            margin: kDefaultBodyPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: _img1Path == ""
                        ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async => await onSelectImage(),
                            child: DottedBorder(
                              borderType: BorderType.Rect,
                              dashPattern: const [10, 10],
                              color: kLight,
                              strokeWidth: 1.5,
                              child: Stack(
                                children: const [
                                  SizedBox(
                                    height: 150,
                                    width: 320,
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        AntDesign.plus,
                                        color: kLight,
                                        size: 34.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => onSelectImage(),
                            child: Image.file(
                              File(_img1Path),
                              height: 150,
                              width: 320,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: CheckboxListTile(
                    value: _hasRider,
                    onChanged: (v) {
                      setState(() {
                        _hasRider = v as bool;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "We have a personal rider/courier",
                      style: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kLight,
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: _hasRider ? false : true,
                  child: AnimatedOpacity(
                    opacity: _hasRider ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0, bottom: 10),
                          width: double.infinity,
                          child: inputNumberTextField(
                            controller: _deliveryFeeController,
                            focusNode: _deliveryFeeFocus,
                            hasError: false,
                            labelText: "Delivery fee per KM (PHP)",
                            color: kLight,
                            textFieldStyle: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: kPrimary,
                            ),
                            hintStyleStyle: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: kPrimary,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(
                                () => MerchantQRCode(
                                  code: _user.userLoginData["accountId"],
                                ),
                              ),
                              child: Hero(
                                tag: _user.userLoginData["accountId"],
                                child: ClipRRect(
                                  borderRadius: kDefaultRadius,
                                  child: QrImage(
                                    backgroundColor: kLight,
                                    data: _user.userLoginData["accountId"],
                                    version: QrVersions.auto,
                                    gapless: true,
                                    size: 160,
                                    eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.circle,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "Download the Rider Mobile Application from our official website www.petshopecommerce.cdo and scan the provided QR Code",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: kLight,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: TextButton(
                    onPressed: () => onRegister(),
                    style: TextButton.styleFrom(
                      //primary: kFadeWhite,
                      backgroundColor: kSecondary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: kDefaultRadius,
                      ),
                    ),
                    child: Text(
                      "CREATE MY STORE PROFILE",
                      style: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: kLight,
                      ),
                    ),
                  ),
                ),
                _info,
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
