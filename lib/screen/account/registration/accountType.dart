import 'package:app/common/print.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/globalController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterAccountType extends StatefulWidget {
  const RegisterAccountType({Key? key}) : super(key: key);

  @override
  State<RegisterAccountType> createState() => _RegisterAccountTypeState();
}

class _RegisterAccountTypeState extends State<RegisterAccountType> {
  final _global = Get.put(GlobalController());

  String selectedRole = "customer";

  Future<void> onProceed() async {
    // ASSIGN VALUE TO GLOBAL STATE
    _global.registrationProperties.addAll(
      {
        "accountType": selectedRole,
      },
    );

    prettyPrint("RegisterAccountType", _global.registrationProperties);

    // REDIRECT TO NEXT STEP
    Get.toNamed("/register-account-profile");
  }

  @override
  Widget build(BuildContext context) {
    final _breadCrumbs = Container(
      margin: kDefaultBodyPadding.copyWith(left: 15.0),
      child: Row(
        children: [
          Text(
            "Account",
            style: GoogleFonts.chivo(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: kLight,
              height: 1.5,
            ),
          ),
          const Icon(
            Entypo.chevron_right,
            color: kLight,
            size: 15.0,
          ),
          Text(
            "Type",
            style: GoogleFonts.chivo(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: kLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kPrimary,
        appBar: AppBar(
          title: _breadCrumbs,
          backgroundColor: kPrimary,
          elevation: 0,
          leading: const SizedBox(),
          leadingWidth: 0.0,
        ),
        body: Container(
          margin: kDefaultBodyPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70.0),
              CheckboxListTile(
                value: selectedRole == "customer" ? true : false,
                onChanged: (v) {
                  setState(() {
                    selectedRole = "customer";
                  });
                },
                title: Text(
                  "Customer",
                  style: GoogleFonts.roboto(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kLight,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: selectedRole == "merchant" ? true : false,
                onChanged: (v) {
                  setState(() {
                    selectedRole = "merchant";
                  });
                },
                title: Text(
                  "Merchant",
                  style: GoogleFonts.roboto(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kLight,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 62,
                child: TextButton(
                  onPressed: () => onProceed(),
                  style: TextButton.styleFrom(
                    //primary: kFadeWhite,
                    backgroundColor: kLight,
                    shape: const RoundedRectangleBorder(
                      borderRadius: kDefaultRadius,
                    ),
                  ),
                  child: Text(
                    "PROCEED",
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70.0),
            ],
          ),
        ),
      ),
    );
  }
}
