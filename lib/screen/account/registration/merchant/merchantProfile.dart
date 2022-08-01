import 'package:app/common/destroyTextFieldFocus.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:app/services/location_name.dart';
import 'package:app/widget/form.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
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

  late TextEditingController _firstNameController;
  late FocusNode _firstNameFocus;

  late TextEditingController _lastNameController;
  late FocusNode _lastNameFocus;

  late TextEditingController _contactController;
  late FocusNode _contactFocus;

  late TextEditingController _addressController;
  late FocusNode _addressFocus;

  late TextEditingController _merchantNameController;
  late FocusNode _merchantNameFocus;

  Future<void> onProceed() async {
    final _firstName = _firstNameController.text.trim();
    final _lastName = _lastNameController.text.trim();
    final _address = _addressController.text.trim();

    final _contact = _contactController.text.trim().replaceAll(r' ', "");

    // VALIDATE
    if (_firstName.isEmpty) {
      return _firstNameFocus.requestFocus();
    }
    if (_lastName.isEmpty) {
      return _lastNameFocus.requestFocus();
    }
    if (_contact.isEmpty) {
      return _contactFocus.requestFocus();
    }

    final _locationCoordinates = await getLocation();
    final _locationName = await getLocationName(
      lat: _locationCoordinates?.latitude,
      long: _locationCoordinates?.longitude,
    );

    // ASSIGN VALUE TO GLOBAL STATE
    _profile.createProfileData.addAll(
      {
        "accountId": _user.userLoginData["accountId"],
        "name": {
          "first": _firstName,
          "last": _lastName,
        },
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
        "verified": false,
        "visibility": true
      },
    );

    // REDIRECT
    Get.toNamed("/register-account-picture");
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController = TextEditingController();
    _firstNameFocus = FocusNode();
    _lastNameController = TextEditingController();
    _lastNameFocus = FocusNode();
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
    _firstNameController.dispose();
    _firstNameFocus.dispose();
    _lastNameController.dispose();
    _lastNameFocus.dispose();
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
      "Profile Setup",
      style: GoogleFonts.chivo(
        fontWeight: FontWeight.bold,
        color: kLight,
        fontSize: 15,
      ),
    );
    final _subTitle = Text(
      "It’s quick and easy.",
      style: GoogleFonts.roboto(
        fontSize: 12.0,
        fontWeight: FontWeight.w300,
        color: kLight,
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kPrimary,
          appBar: AppBar(
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
          ),
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
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
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
