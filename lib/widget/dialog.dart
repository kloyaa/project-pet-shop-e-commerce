import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

Future dialogLoading(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: Colors.black54,
          elevation: 0,
          contentPadding: const EdgeInsets.all(0),
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.all(0),
          content: SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45.0,
                  child: LoadingIndicator(
                    indicatorType: Indicator.circleStrokeSpin,
                    colors: [kPrimary],
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 25.0),
                Text(
                  "We are Uploading your images \nto a secured cloud, Please wait.",
                  style: GoogleFonts.roboto(
                    color: kPrimary,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
