import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum BottomSheetType { toast, removePreviousItem }

bottomSheet({message, required BottomSheetType type, action}) {
  if (type == BottomSheetType.toast) {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25.0),
        child: Text(
          message,
          style: GoogleFonts.roboto(color: kWhite),
        ),
      ),
      backgroundColor: kPrimary,
    );
  }
  if (type == BottomSheetType.removePreviousItem) {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Clear previous items?",
              style: GoogleFonts.roboto(
                color: kWhite,
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              message,
              style: GoogleFonts.roboto(
                color: kWhite,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 25),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 62,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kWhite),
                      shape: const RoundedRectangleBorder(
                        borderRadius: kDefaultRadius,
                      ),
                    ),
                    child: Text(
                      "No",
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  height: 62,
                  child: TextButton(
                    onPressed: () {
                      action();
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      //primary: kFadeWhite,
                      backgroundColor: kLight,
                      shape: const RoundedRectangleBorder(
                        borderRadius: kDefaultRadius,
                      ),
                    ),
                    child: Text(
                      "Clear",
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
      backgroundColor: kPrimary,
    );
  }
}
