import 'package:app/common/destroyTextFieldFocus.dart';
import 'package:app/common/print.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:app/services/location_name.dart';
import 'package:app/widget/form.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class RegisterAsMerchant extends StatefulWidget {
  const RegisterAsMerchant({Key? key}) : super(key: key);

  @override
  State<RegisterAsMerchant> createState() => _RegisterAsMerchantState();
}

class _RegisterAsMerchantState extends State<RegisterAsMerchant> {
  final _user = Get.put(UserController());
  final _global = Get.put(GlobalController());
  final _profile = Get.put(ProfileController());

  late TextEditingController _emailController;
  late FocusNode _emailFocus;

  late TextEditingController _nameController;
  late FocusNode _nameFocus;

  late TextEditingController _contactController;
  late FocusNode _contactFocus;

  late TextEditingController _addressController;
  late FocusNode _addressFocus;

  late TextEditingController _merchantNameController;
  late FocusNode _merchantNameFocus;

  String _openTime = "Select Open Time";
  String _closingTime = "Select Closing Time";

  Future<void> onProceed() async {
    final _name = _nameController.text.trim();

    final _contact = _contactController.text.trim().replaceAll(r' ', "");

    // VALIDATE
    if (_name.isEmpty) {
      return _nameFocus.requestFocus();
    }

    if (_contact.isEmpty) {
      return _contactFocus.requestFocus();
    }

    if (_openTime == "Select Open Time") {
      return selectServiceHrs("open");
    }
    if (_closingTime == "Select Closing Time") {
      return selectServiceHrs("close");
    }

    final serviceHrs = _openTime + " to " + _closingTime;

    final _locationCoordinates = await getLocation();
    final _locationName = await getLocationName(
      lat: _locationCoordinates?.latitude,
      long: _locationCoordinates?.longitude,
    );

    // ASSIGN VALUE TO GLOBAL STATE
    _profile.createProfileData.clear();
    _profile.createProfileData.addAll(
      {
        "accountId": _user.userLoginData["accountId"],
        "name": _name,
        "contact": {
          "email": _user.userLoginData["email"],
          "number": _contact,
        },
        "address": {
          "name": "${_locationName[0].street}, ${_locationName[0].locality}",
          "coordinates": {
            "longitude": _locationCoordinates?.longitude,
            "latitude": _locationCoordinates?.latitude
          }
        },
        "serviceHrs": serviceHrs,
        "verified": false,
        "visibility": true
      },
    );

    prettyPrint("createProfileData", _profile.createProfileData);

    // REDIRECT
    Get.toNamed("/register-as-merchant-banner");
  }

  void onLocationSync() async {
    final _locationCoordinates = await getLocation();
    final _locationName = await getLocationName(
      lat: _locationCoordinates?.latitude,
      long: _locationCoordinates?.longitude,
    );

    final _location = _locationName[0];
    _addressController.text = "${_location.street}, ${_location.locality}";
  }

  void selectServiceHrs(type) {
    if (type == "open") {
      return BottomPicker.time(
        height: Get.height * 0.50,
        title: "Select Opening Time",
        buttonAlignement: MainAxisAlignment.end,
        buttonSingleColor: kPrimary,
        pickerTextStyle: GoogleFonts.roboto(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          color: kPrimary,
        ),
        titleStyle: GoogleFonts.roboto(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kPrimary,
        ),
        onSubmit: (date) {
          setState(() {
            _openTime = Jiffy(date).jm;
          });
        },
        onClose: () {
          print("Picker closed");
        },
        use24hFormat: false,
      ).show(context);
    }
    if (type == "close") {
      return BottomPicker.time(
        height: Get.height * 0.50,
        title: "Select Closing Time",
        buttonAlignement: MainAxisAlignment.end,
        buttonSingleColor: kPrimary,
        pickerTextStyle: GoogleFonts.roboto(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          color: kPrimary,
        ),
        titleStyle: GoogleFonts.roboto(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kPrimary,
        ),
        onSubmit: (date) {
          setState(() {
            _closingTime = Jiffy(date).jm;
          });
        },
        onClose: () {
          print("Picker closed");
        },
        use24hFormat: false,
      ).show(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _nameFocus = FocusNode();

    _contactController = MaskedTextController(mask: '0000 000 0000');
    _contactFocus = FocusNode();
    _addressController = TextEditingController();
    _addressFocus = FocusNode();
    _emailController = TextEditingController();
    _emailFocus = FocusNode();

    _merchantNameController = TextEditingController();
    _merchantNameFocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _nameFocus.dispose();

    _contactController.dispose();
    _contactFocus.dispose();
    _addressController.dispose();
    _addressFocus.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    _merchantNameController.dispose();
    _merchantNameFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _title = Text(
      "Store Profile",
      style: GoogleFonts.chivo(
        fontWeight: FontWeight.bold,
        color: kLight,
        fontSize: 15,
      ),
    );
    final _subTitle = Text(
      "Update your new info",
      style: GoogleFonts.roboto(
        fontSize: 12.0,
        fontWeight: FontWeight.w300,
        color: kLight,
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
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: inputTextField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      hasError: false,
                      labelText: _user.userLoginData["email"],
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
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: inputTextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    hasError: false,
                    labelText: "Name",
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
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: inputNumberTextField(
                    controller: _contactController,
                    focusNode: _contactFocus,
                    hasError: false,
                    labelText: "Mobile Number",
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
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: TextButton(
                    onPressed: () => onLocationSync(),
                    child: Text(
                      "Tap to Sync Address",
                      style: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 5.0),
                    child: inputTextArea(
                      controller: _addressController,
                      focusNode: _addressFocus,
                      // obscureText: true,
                      hasError: false,
                      labelText: "Address",
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
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => selectServiceHrs("open"),
                          child: Text(
                            _openTime,
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: _openTime == "Select Open Time"
                                  ? FontWeight.w400
                                  : FontWeight.bold,
                              color: kLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      _openTime != "Select Open Time"
                          ? Text(
                              "to",
                              style: GoogleFonts.roboto(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kLight.withOpacity(0.5),
                              ),
                            )
                          : const SizedBox(),
                      Expanded(
                        child: TextButton(
                          onPressed: () => selectServiceHrs("close"),
                          child: Text(
                            _closingTime,
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: _closingTime == "Select Closing Time"
                                  ? FontWeight.w400
                                  : FontWeight.bold,
                              color: kLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: TextButton(
                    onPressed: () => onProceed(),
                    style: TextButton.styleFrom(
                      //primary: kFadeWhite,
                      backgroundColor: kSecondary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: kDefaultRadius,
                      ),
                    ),
                    child: Text(
                      "SAVE PROFILE",
                      style: GoogleFonts.roboto(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: kLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
